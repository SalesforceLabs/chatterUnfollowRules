@isTest
private class UnfollowTests3DeleteMe{
//utility class to create dummy users
    public static List<User> createUsers(Long numUsers, string profileName){
        Profile p = [select id from profile where Name=:profileName]; 
        List<user> users=new List<user>();
        for (Integer i=0; i<numUsers;i++){
            User u = new User(alias = 'user', email=profileName.replace(' ','')+'user'+i+'@testorg.com', 
                emailencodingkey='UTF-8', lastName='testUser'+i, languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, 
                timezonesidkey='America/Los_Angeles', userName=profileName.replace(' ','')+'user'+i+'@testorg.com');
            users.add(u);
        }//for 1    
        insert users;
        return users;
    }//createUsers
    
    //utility class to create dummy data to test.  This custom object is used as standard objects tend to have validation rules, failing the insert of records
    public static List<Id> createUnfollowTestRecords(Long numRecords,Boolean check, Date dat, DateTime datTim, Decimal dec, String em, String ph, String pick, string str,String ur ) {
        List<UnfollowTest__c> testRecords = new List<UnfollowTest__c>{};
        Integer i;
        for (i=0;i<numRecords;i++){
            UnfollowTest__c t = new UnfollowTest__c(Name='test'+i, String__c=str,Checkbox__c = Check,Date__c= dat, DateTime__c=datTim,  Decimal__c=Dec, Email__c=em, Phone__c=ph, Picklist__c=pick, URL__c=ur);
            testRecords.add(t);
        }//for
        insert testRecords;
        List<Id> Ids=new List<Id>();
        for (UnfollowTest__c t:testRecords){
            Ids.add(t.Id);
        }//for 1
        return Ids;
    }//createUnfollowTestRecords
 
    //utility class to create dummy Subscriptions to test
    public static List<EntitySubscription> createSubs(List<User> users, List<Id> recordIds){
        List<EntitySubscription> subs=new List<EntitySubscription>();
        for (User u: users){
            for (Id rId:recordIds){
                subs.add(new EntitySubscription(ParentId=rId, SubscriberId=u.Id));
            }//for 2
        }//for 1
        insert subs;
        return subs;
    }//createSubs

    //utility class to create rules 
    public static UnfollowRule__c createUR(Boolean Active, String urON,  String urFN, String urOperator, String urValue ,Double urDD) {
        UnfollowRule__c ur=new UnfollowRule__c(Active__c=Active, objectName__c=urON, fieldName__c=urFN, Operator__c=urOperator, Value__c=urValue,  daysDelay__c=urDD );
        return ur;
    }//createLSR

    //This deletes the existing rules in case this app is already installed & this is an upgrade installation
    public static void cleanUpTestData() {
        List<UnfollowRule__c> urs=[Select ID from UnfollowRule__c LIMIT 100];
        List<UnfollowBatchJobsQueue__c> uqs = [SELECT Id FROM UnfollowBatchJobsQueue__c LIMIT 100];
        List<UnfollowTest__c> tRecs=[SELECT Id FROM UnfollowTest__c LIMIT 500];
        delete urs;
        delete uqs;
        delete tRecs;
    }//cleanUpTestData
/*
   static testMethod void verifyUnfollowQueueEmptiesProperly(){
        Double URDaysDelay=1;
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        String Str='asdf';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Phone = '415-555-5555';
        String Email = 'test@test.com';
        String Url='www.test.com';
          
        cleanUpTestData();
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        List<UnfollowQueue__c> pendingRecords=new List<UnfollowQueue__c>();
        //Note that these should have Criteria Met Date as in the past so they should "unqueue"
        for(Id i:recordIds){
            pendingRecords.add(new UnfollowQueue__c(recordId__c=i,daysDelay__c=URdaysDelay, CriteriaMetDate__c=date.today()-URDaysDelay.intValue()));
        }//for 1
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);
        //Note these will have the Criteria Met Date as today, so they shouldn't leave the queue
        for(Id i:recordIds2){
            pendingRecords.add(new UnfollowQueue__c(recordId__c=i,daysDelay__c=URdaysDelay, CriteriaMetDate__c=date.today()));
        }//for 1

        insert pendingRecords;

        test.startTest();
            UnfollowRecordsDelayed.unfollowQueueDelayBatchJob();  
        test.stopTest();
        
        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds AND ScheduledUnfollowDate__c=TODAY];
        system.assertEquals(0,uqs.size());
        List<EntitySubscription> es=[SELECT Id FROM EntitySubscription WHERE ParentId IN:recordIds];
        system.assertEquals(0,es.size());   
             
        uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds2 AND ScheduledUnfollowDate__c!=TODAY];
        system.assertEquals(numRecordsToCreate,uqs.size());
        es=[SELECT Id FROM EntitySubscription WHERE ParentId IN:recordIds2];
        system.assertEquals(numRecordsToCreate*numUsersToCreate,es.size());   
    }//verifyUnfollowQueueEmptiesProperly
*/

}//UnfollowTests3DeleteMe