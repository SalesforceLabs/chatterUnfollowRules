public with sharing class UnfollowUtilityRunDelayMethods {
    
    // Constructor - this only really matters if the autoRun function doesn't work right
    public UnfollowUtilityRunDelayMethods() {
    }
    
    public void runQueueBatchJobs(){
        Boolean runFromButton=FALSE;
        unfollowExecute.unfollowQueueBatchJobs(runFromButton);
    }//runQueueBatchJobs
    
    public void runQueueDelayBatchJob(){
        UnfollowRecordsDelayed.unfollowQueueDelayBatchJob();
    }//runQueueDelayBatchJob
    
    
    public void runTryBatchJobsAgain(){
        unfollowTryBatchJobsAgain.unfollowTryBatchJobsAgain();
    }//runTryBatchJobsAgain
}//UnfollowUtilityRunDelayMethods