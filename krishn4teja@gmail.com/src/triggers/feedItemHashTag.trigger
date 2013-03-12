trigger feedItemHashTag on FeedItem (after insert) {

    Integer dynamicIndex;
    Integer index;
    Integer indexBlankSpace;
    String firstName ='';
    String dynamicQuery = '';
    String fullName = '';
    String hasTagId = '';
    String transferId='';
    
    boolean existsInFeedItemFlag;
    boolean existsInFeedItemFlagAtm ;
    for(FeedItem fi : Trigger.new){
        
        String body = fi.body; 
        HashTags__c htAtMention = new HashTags__c();
        
        DateTime theDate = Date.today();
        Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
        String dayOfWeek=dt.format('EEEE');

        
        if(body.contains('@')){
          
           index = body.indexOf('@');
           indexBlankSpace = body.indexOf(' ',index);           
           firstName = body.substring(index+1,indexBlankSpace );
           
           dynamicIndex = indexBlankSpace;
           
           dynamicQuery = 'SELECT name,firstname,lastname,id,email from USER where name LIKE\''+firstName+'%\'';
           List<User> u =  Database.query(dynamicQuery );
           
           system.debug('-----'+u);
           
           for(User usr : u){
               system.debug('-----'+usr);
               fullName = usr.firstname + ' '+usr.lastname;               
               existsInFeedItemFlag = body.contains('@'+fullname);
               if(existsInFeedItemFlag ){   
                        
                    htAtMention.FID__c = fi.id;
                    htAtMention.name = fullname;
                    htAtMention.Flag__c = false; 
                    htAtMention.At_Mentions__c = fullName;                                               //True for HashTag and False for @-Mention
                    htAtMention.Day__c = dayOfWeek;
                    Insert htAtMention;
                    transferId = htAtMention.id;
               }
           }                
     
        }
                   
        if(body.contains('#')){
            
            String fHashTagString = ChatterHelperUtil.fetchFinalStr(body ,'#');
            
            if(htAtMention != null)
                hasTagId = ChatterHelperUtil.insertHasTagRecord(true,fHashTagString ,fi.id,htAtMention.id,dayOfWeek);
            else    
                hasTagId = ChatterHelperUtil.insertHasTagRecord(true,fHashTagString ,fi.id,'',dayOfWeek);               
        }
        
        
        Posted_Details__c pd = new Posted_Details__c();
        pd.body__c = fi.body;
        pd.Day__c = dayOfWeek;
        insert pd; 
        
        integer atmCount=0;
        atmCount = body.countMatches('@');
        for(integer ii=0;ii<atmCount;ii++){
        index = body.indexOf('@');
        indexBlankSpace = body.indexOf(' ',index);           
        firstName = body.substring(index+1,indexBlankSpace );
           
        dynamicIndex = indexBlankSpace;
           
        dynamicQuery = 'SELECT name,firstname,lastname,id,email from USER where name LIKE\''+firstName+'%\'';
        List<User> u =  Database.query(dynamicQuery );
           
        system.debug('-----'+u);
           
        for(User usr : u){
        system.debug('-----'+usr);
        fullName = usr.firstname + ' '+usr.lastname;   
        system.debug('-----------Trigger---------'+body);     
        system.debug('-----------Trigger---------'+fullname);        
        existsInFeedItemFlagAtm = body.contains('@'+fullname);
        system.debug('-----------Trigger---------'+existsInFeedItemFlagAtm );   
        if(existsInFeedItemFlagAtm ){  
             At_Mentioned_User__c[]  amuc = [select id,Mention_Count__c,User_Name__c from At_Mentioned_User__c where User_Name__c=:fullname];              
             system.debug('-----------Trigger---------'+fullname);
             if(amuc.size() >0){
                 At_Mentioned_User__c  amucInsert = new At_Mentioned_User__c  (id=amuc[0].id);
                 amucInsert.Mention_Count__c = amuc[0].Mention_Count__c+1;
                 update amucInsert;
                                  
             }else{
                 system.debug('-----------In Else loop Trigger---------');
                 At_Mentioned_User__c  amucInsert = new At_Mentioned_User__c  ();
                 amucInsert.User_Name__c = fullname;
                 amucInsert.Mention_Count__c = 1;
                 amucInsert.ParentId__c = Userinfo.getUserId();
                 insert amucInsert;
             }      
        }
            
    }
}
        
           
       
       
    
    }

}