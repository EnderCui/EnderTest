/**
 * Created by marius on 07/02/2017.
 */

public with sharing class DateUtil {

    /**
     * Converts from String to DateTime
     * Supported formats:
     * 2017/01/10 20:00
     */
    public static DateTime parseStringToDateTime(String dateStr) {

        if(String.isEmpty(dateStr))
        {
            return null;
        }

        String[] split = dateStr.split('/');
        if(split == null || split.size() != 3)
        {
            return null;
        }

        Integer year = Integer.valueOf(split[0]);
        Integer month = Integer.valueOf(split[1]);
        Integer day = Integer.valueOf(split[2].substringBefore(' '));

        String[] hourminuteseconds = dateStr.substringAfter(' ').split(':');
        if(hourminuteseconds == null || hourminuteseconds.size() != 2)
        {
            return null;
        }

        Integer  hour = Integer.valueOf(hourminuteseconds[0]);
        Integer  minute = Integer.valueOf(hourminuteseconds[1]);

        return DateTime.newInstance(year, month, day, hour, minute, 0);
    }

    /**
     * Converts from String to Date
     * Supported formats:
     * 2017/01/10
     */
    public static Date parseStringToDate(String dateStr) {
        if(String.isEmpty(dateStr))
        {
            return null;
        }

        String[] split = dateStr.split('/');
        if(split == null || split.size() != 3)
        {
            return null;
        }

        Integer year = Integer.valueOf(split[0]);
        Integer month = Integer.valueOf(split[1]);
        Integer day = Integer.valueOf(split[2].substringBefore(' '));

        return Date.newInstance(year, month, day);
    }

    public static String valueOf(Date dt)
    {
        return dt.year() + '/' + padWithZero(dt.month()) + '/' + padWithZero(dt.day());
    }

    public static String valueOfDateTime(DateTime dt)
    {
        return dt.year() + '/' + padWithZero(dt.month())  + '/' + padWithZero(dt.day()) + ' ' + padWithZero(dt.hour()) + ':' + padWithZero(dt.minute());
    }

    private static String padWithZero(Integer numberP)
    {
        return numberP < 10 ? '0' + String.valueOf(numberP) : String.valueOf(numberP);
    }
}