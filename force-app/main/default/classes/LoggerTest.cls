/**
* @author:  Solved by Software, Co
*/

@isTest
public with sharing class LoggerTest {
    @isTest
    public static void TestLogger() {
        Test.setMock(HttpCalloutMock.class, new ChargebeeInvocableTest.ChargebeeHttpResponseGenerator());
        Test.startTest();
        Logger.CreateLogFromRequest(new HttpRequest(), '', '');
        Logger.CreateLog('', '', '', '', false, '');
        Test.stopTest();  
    }
}