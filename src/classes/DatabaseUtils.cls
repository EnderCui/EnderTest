public with sharing class DatabaseUtils 
{
    public static final String EQUALS = '=';
    public static final String NOT_EQUALS = '!=';

    public static final String NULL_QUERY_VALUE = 'null';
    public static final String BLANK_QUERY_VALUE = '\'\''; 

    public static final String DML_OPERATION_UPSERT = 'upsert';
    private static final String COMMA = ',';

    /**
    *    @description Retrieves a custom metadata type by a type and a qualifier.
    *    @param metadataTypeName api name of a custom metadata type.
    *    @param fields fields which should be retrieved.
    *    @param qualifier a custom metadata type's qualifier.
    *    @author ypa
    */
    public static List<Sobject> doQueryMetadataType(String metadataTypeName, List<String> fields, String qualifier)
    {
        String query = 'SELECT ';
        query += String.join(new List<String>(fields), ',');
        query += ' FROM ' + metadataTypeName;
        query += ' WHERE QualifiedApiName = \'' + String.escapeSingleQuotes(qualifier) + '\'';
        query += ' LIMIT 100';

        return Database.query(query);
    }

    /**
    *    @description Just retrieves sobjects.
    *    @param sobjectApi a sobject api to be retrieved.
    *    @param fields fields which should be retrieved.
    *    @return List<Sobject> target sobjects.
    *    @author ypa
    */
    public static List<Sobject> getSobjects(String sobjectApi, List<String> fields)
    {
        String query = 'SELECT ';
        query += String.join(new List<String>(fields), ',');
        query += ' FROM ' + sobjectApi;
        query += ' LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        return Database.query(query);
    }

    /**
    *    @description Returns sobjects of necessary type by particular parent type ids.
    *    @param sobjectApi target sobject api name.
    *    @param fields necessary fields.
    *    @param parentRelationshipApi relationship api name to parent.
    *    @param parentIds parents ids.
    *    @param optionalOrderByApi optional field api by which records should be ordered.
    *    @param optionalOrder optional order direction.
    *    @return List<Sobject> target sobjects.
    *    @author ypa
    */
    public static List<Sobject> getSobjectsByParent(String sobjectApi, List<String> fields, String parentRelationshipApi, 
                                                    Set<Id> parentIds, String optionalOrderByApi, String optionalOrder)
    {
        //Filter fields from duplicates and at least one field api must present in a query.
        fields = fields == null ? new List<String>() : fields;
        Set<String> targetFields = new Set<String>(fields);
        targetFields.add('Id');
        
        String soql = 'SELECT ' + String.join(new List<String>(fields), ',') + ' FROM ' + sobjectApi + ' ';
        soql += 'WHERE ' + parentRelationshipApi + ' IN: parentIds ';
        if (String.isNotBlank(optionalOrderByApi) && String.isNotBlank(optionalOrder))
        {
            soql += 'ORDER BY ' + optionalOrderByApi + ' ' + optionalOrder + ' ';
        }
        soql += 'LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        return Database.query(soql);
    }

    /**
    *    @description Returns sobjects by ids.
    *    @param sobjectTypeName target sobject type name.
    *    @param fields necessary fields.
    *    @param ids Sobject related ids.
    *    @return List<Sobject> target sobjects.
    *    @author ypa
    */
    public static List<Sobject> getRelatedSobjects(String sobjectTypeName, List<String> fields, Set<Id> ids)
    {
        String query = 'SELECT ';
        query += String.join(new List<String>(fields), ',');
        query += ' FROM ' + sobjectTypeName;
        query += ' WHERE Id IN: ids';   
        query += ' LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        return Database.query(query);
    }

    /**
    *    @description Returns sobjects by ids.
    *    @param sobjectTypeName target sobject type name.
    *    @param fields necessary fields.
    *    @param ids Sobject related ids.
    *    @param queryLimit a query limit.
    *    @return List<Sobject> target sobjects.
    *    @author ypa
    */
    public static List<Sobject> getRelatedSobjects(String sobjectTypeName, List<String> fields, Set<Id> ids, Integer queryLimit)
    {
        String query = 'SELECT ';
        query += String.join(new List<String>(fields), ',');
        query += ' FROM ' + sobjectTypeName;
        query += ' WHERE Id IN: ids';   
        query += ' LIMIT ' + queryLimit;

        return Database.query(query);
    }

    /**
    *    @description Returns sobjects which are not in provided ids.
    *    @param sobjectTypeName target sobject type name.
    *    @param fields necessary fields.
    *    @param ids Sobject related ids.
    *    @return List<Sobject> target sobjects.
    *    @author ypa
    */
    public static List<Sobject> getNotRelatedSobjects(String sobjectTypeName, List<String> fields, Set<Id> ids)
    {
        String query = 'SELECT ';
        query += String.join(new List<String>(fields), ',');
        query += ' FROM ' + sobjectTypeName;
        query += ' WHERE Id NOT IN: ids';   
        query += ' LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        return Database.query(query);
    }

    /**
    *    @description Returns records by global search taking in consideration possible different logcail operators between search terms.
    *    @param sobjectTypeApi target sobject type name.
    *    @param terms searchterms to be traversed.
    *    @param logicalOperators optional logical operators to be used between serach terms.
    *    @param fields fields to be returned.
    *    @return List<Sobject> target sobjects.
    *    @author ypa
    */
    public static String getSobjectsByGlobalSearchQuery(String sobjectTypeApi, List<String> terms, List<String> logicalOperators, List<String> fields)
    {
        //If terms don't take place.
        //Or logical operators structure has incorrect number of items.
        if (terms == null || terms.size() == 0 ||
            (logicalOperators != null && logicalOperators.size() != 0 && terms.size() != logicalOperators.size() + 1))
        {
            return '';
        }

        String searchTerms = '';

        //Logical operators don't take place - just joins items.
        if (logicalOperators == null || logicalOperators.size() == 0)
        {
            searchTerms = String.join(terms, ' ');

        //Otherwise contructs search terms taking in consideration logical operators.
        } else
        {
            List<String> termsWithLogicalOperators = new List<String>();
            for (Integer i = 0; i < terms.size(); i++)
            {
                String operator = i < logicalOperators.size() ? logicalOperators.get(i) : '';
                String term = '"' + terms.get(i) + '" ' + operator;
                term = term.trim();

                termsWithLogicalOperators.add(term);
            }
            searchTerms = String.join(termsWithLogicalOperators, ' ');
        }

        return 'FIND \'' + searchTerms + '\' ' + 
               'IN ALL FIELDS ' + 
               'RETURNING ' + sobjectTypeApi + '(' + String.join(fields, ',') + ')';
    }

    /**
    *    @description Returns records by global search taking in consideration possible different logcail operators between search terms.
    *    @param sobjectTypeApi target sobject type name.
    *    @param terms searchterms to be traversed.
    *    @param logicalOperators optional logical operators to be used between serach terms.
    *    @param fields fields to be returned.
    *    @return List<Sobject> target sobjects.
    *    @author ypa
    */
    public static List<Sobject> getSobjectsByGlobalSearch(String sobjectTypeApi, List<String> terms, List<String> logicalOperators, List<String> fields)
    {
        String searchQuery = getSobjectsByGlobalSearchQuery(sobjectTypeApi, terms, logicalOperators, fields);
        if (String.isBlank(searchQuery))
        {
            return new List<Sobject>();
        }

        return Search.query(searchQuery).get(0);
    }

    /**
    *    @description Dynamically casts an object value to soql acceptable view.
    *    @param value a value to be transformed.
    *    @return a soql acceptable value.
    *    @author ypa
    */
    public static String toLiteral(Object value, Boolean quote)
    {
        String literal = '';
        if (value == null)
        {
            literal += NULL_QUERY_VALUE; 
        } else if(value instanceof String || value instanceof ID)
        {
            String manipulated = (String) value;
            if (String.isNotBlank(manipulated))
            {
                manipulated = String.escapeSingleQuotes(manipulated);
                literal += quote ? '\'' + manipulated + '\'' : manipulated; 
            }
        } else if(  value instanceof Boolean ||
                    value instanceof Integer || 
                    value instanceof Long    || 
                    value instanceof Double  || 
                    value instanceof Decimal)
        {
            literal += value;
        } else if(value instanceof Date)
        {
            literal += Datetime.newInstanceGmt(((Date)value).year(), ((Date)value).month(), ((Date)value).day()).formatGmt('yyyy-MM-dd');
        } else if(value instanceof Datetime)
        {
            literal += ((Datetime) value).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        }

        return literal;
    }

    /**
    *    @description Retrieves a record with all of sobject fields.
    */
    public static Sobject getRecordWithAllFields(Id recordId)
    {
        if (String.isBlank(recordId))
        {
            return null;
        }

        Set<String> fieldsSet = ReflectionUtils.getSobjectFields(recordId.getSobjectType().getDescribe().getName()).keySet();
        List<String> fields = new List<String>(fieldsSet);

        //US137/TA180: Filter KPI fields
        Integer j = 0;
        while (j < fields.size())
        {
            if(fields.get(j).startsWithIgnoreCase('KpiTime'))
            {
                fields.remove(j);
            }
            else
            {
                j++;
            }
        }

        List<Sobject> targetRecord = DatabaseUtils.getRelatedSobjects(
            recordId.getSobjectType().getDescribe().getName(),
            fields,
            new Set<Id>{recordId}
        );

        return targetRecord.size() > 0 ? targetRecord.get(0) : null;
    }

    /**
    *    @description Creates a clone of a record taking in consideration all of a sobject fields.
    */
    public static Sobject cloneRecord(Id recordId)
    {
        if (String.isBlank(recordId))
        {
            return null;
        }
        
        Sobject targetRecord = getRecordWithAllFields(recordId);

        return targetRecord == null ? targetRecord : targetRecord.clone(false, false, false, false);
    }

    /**
    *    @description US107, SCSI-1125. Creates several clones of a record taking in consideration all of a sobject fields.
    */
    public static List<Sobject> makeSeveralClonesFromRecord(Id recordId, Integer numberOfClones)
    {
        if (String.isBlank(recordId) || numberOfClones <= 0)
        {
            return new List<Sobject>();
        }
        
        Sobject targetRecord = getRecordWithAllFields(recordId);
        List<Sobject> clones = new List<Sobject>();
        for (Integer i = 0; i < numberOfClones && targetRecord != null; i++)
        {
            clones.add(targetRecord.clone(false, false, false, false));
        }

        return clones;
    }

    /**
    *    @description US107, SCSI-1125. To avoid the dml exception per a transaction - truncates a list structure.
    */
    public static List<Sobject> truncateHonoringDMLLimit(List<Sobject> records)
    {
        for (Integer i = records.size() - 1; i >= 0 && i > (Limits.getLimitDMLRows() - Limits.getDMLRows() - 1); i--)
        {
            records.remove(i);
        }

        return records;
    }

    /**
    *    @description Checks whether an user has edit permissions on a record.
    *    @param userId a context user.
    *    @param recordId a record to be checked.
    *    @return a boolean indicator.
    *    @author ypa
    */
    public static Boolean isUserHasEditAccessOnRecord(Id userId, Id recordId)
    {
        return [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: userId AND RecordId =: recordId].get(0).HasEditAccess;
    }

    /**
    *    @description Executes dml asychronously.
    */
    public static void upsertAsynchronously(List<Sobject> records)
    {
        AsyncDmlOperationHandler asyncDmlOperationHandler = new AsyncDmlOperationHandler(records, DML_OPERATION_UPSERT, true);

        System.debug(LoggingLevel.INFO, '*** : ' + Limits.getLimitQueueableJobs());
        System.debug(LoggingLevel.INFO, '*** : ' + Limits.getQueueableJobs());
        if(Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()){
            System.enqueueJob(asyncDmlOperationHandler);
        }
    }

    /**
    *    @description Executes an upsert operation over a set of generic sobjects.
    */
    public static void executeCustomUpsert(List<Sobject> records)
    {
        if (records.size() > 0)
        {
            List<Sobject> forUpdate = new List<Sobject>();
            List<Sobject> forInsert = new List<Sobject>();
            for (Sobject sobj : records)
            {
                if (sobj.get('Id') != null)
                {
                    forUpdate.add(sobj);
                } else 
                {
                    forInsert.add(sobj);
                }
            }

            if (forUpdate.size() > 0)
            {
                update forUpdate;
            }
            if (forInsert.size() > 0)
            {
                insert forInsert;
            }
        }
    }

    /*
     * Returns records based on an object passed as criteria
     *
     */
    public static List<Sobject> getRecordsByCriteria(Sobject criteria, List<String> fields, String additionalWhere, String operator)
    {
        // set default operator as OR
        operator = String.isEmpty(operator) ? ' OR ' : operator;

        // validate empty fields
        if(fields == null || fields.size() < 1)
        {
            return new  List<Sobject>();
        }

        //validate empty criteria
        if(criteria == null)
        {
            return new  List<Sobject>();
        }

        String objectType = criteria.getSObjectType().getDescribe().label;

        List<String> whereClause = new List<String>();
        for(String field : fields)
        {
            String fieldValue = StringUtils.defaultEscapeSingleQuotes(criteria.get(field));
            if(String.isNotEmpty(fieldValue))
            {
                whereClause.add(field + ' like \'%' + fieldValue + '%\'');
            }
        }


        String whereClauseStr = '';
        if(whereClause.size() > 0 || String.isNotEmpty(additionalWhere))
        {
            whereClauseStr += 'WHERE ';

            if(whereClause.size() > 0)
            {
                whereClauseStr += '('   + String.join(whereClause, operator) + ') ';
            }

            if(String.isNotEmpty(additionalWhere))
            {
                whereClauseStr += whereClause.size() > 0 ? 'AND '   + additionalWhere + ' ' : additionalWhere + ' ';
            }

        }

        String query =
                'SELECT '   + String.join(fields, COMMA) + ' ' +
                'FROM '     + objectType + ' ' +
                whereClauseStr +
                'ORDER BY ' + String.join(fields, COMMA) + ' ' +
                'LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        System.debug('query ' + query);
        return Database.query(query);
    }
}