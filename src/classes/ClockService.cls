/*
*   @description Clock Service
*/
public with sharing class ClockService implements  IClockService {

    private Datetime fakeDatetime {get;set;}

    public ClockService(Datetime fakeDatetime)
    {
        this.fakeDatetime = fakeDatetime;
    }

    public ClockService() {}

    public Datetime now()
    {
        if(Test.isRunningTest() && this.fakeDatetime != null)
        {
            return this.fakeDatetime;
        }

        return Datetime.now();
    }
}