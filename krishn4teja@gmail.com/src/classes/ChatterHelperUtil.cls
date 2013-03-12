public class ChatterHelperUtil{

    public String fOccurance;
    public String sOccurance;
    public String finalString;
    public String u;
    public Integer hashTagTimes{set;get;}
    public List<HashTags__c> hashTagNames{set;get;}
    public List<String> uniqueHasTags{set;get;}
    public List<String> uniqueAtmentionedUsers {set;get;}
    public String pieStr {set;get;}
    public String pieStrATM  {set;get;}                
    public Integer mDay{set;get;}
    public Integer tDay{set;get;}
    public Integer wDay{set;get;}
    public Integer thDay{set;get;}
    public Integer fDay{set;get;}
    public Integer saDay{set;get;}
    public Integer suDay{set;get;}
    
    
    public ChatterHelperUtil(){
        u = Userinfo.getUserId();
        User usr = [select id,name from User where id=:u];
        hashTagTimes = [SELECT count() FROM HashTags__c where At_Mentions__c =: usr.name];
        hashTagNames = [SELECT Name FROM HashTags__c where OwnerId =: u and Flag__c = true];
        uniqueHasTags = new List<String>();
        //uniqueHasTags.clear();
        integer i=0;
        pieStr = '[\'Hash Tags\', \'Count\'],';
        for(HashTags__c htc : hashTagNames ){             
            if(i==0){
                uniqueHasTags.add(htc.name);    
            }else{
                integer j=0;
                integer checkExistance=0;     
                for(;j<uniqueHasTags.size();J++){                    
                    if(htc.name.equalsIgnoreCase(uniqueHasTags[j])){
                        checkExistance++;
                    }                                            
                } 
                if(checkExistance == 0){
                    uniqueHasTags.add(htc.name);           
                }
          
            }
            
            i++;
        }
        for(integer k=0;k<uniqueHasTags.size();k++){
            Integer hastTagCount = [select count() from HashTags__c where (OwnerId =: u and Name=:uniqueHasTags[k] and Flag__c=true)]; 
            system.debug('------hastTagCount ---------'+hastTagCount );
            pieStr+= '[\''+uniqueHasTags[k]+'\','+ hastTagCount+'],'; 
            system.debug('------pieStr---------'+pieStr);  
        } 
        
        system.debug('------pieStrFinal---------'+pieStr); 
        pieStr = pieStr.substring(0,pieStr.length()-1);
                    
        mDay = [select count() from Posted_Details__c where Day__c ='Monday'];
        tDay = [select count() from Posted_Details__c where Day__c ='Tuesday'];
        wDay = [select count() from Posted_Details__c where Day__c ='Wednesday'];
        thDay = [select count() from Posted_Details__c where Day__c ='Thursday'];
        fDay = [select count() from Posted_Details__c where Day__c ='Friday'];
        saDay = [select count() from Posted_Details__c where Day__c ='Saturday'];
        suDay = [select count() from Posted_Details__c where Day__c ='Sunday'];
        
        //uniqueAtmentionedUsers = new List<String>();
        
        
        List<At_Mentioned_User__c > atmPiechart = [select id,Mention_Count__c,User_Name__c from At_Mentioned_User__c order by Mention_Count__c DESC ];
        pieStrATM = '[\'User\', \'No Of Times @-Mentioned\'],';
        for(integer k=0;k<atmPiechart.size();k++){
            Integer hastTagCount = [select count() from HashTags__c where OwnerId =: u and Name=:uniqueHasTags[k]]; 
            pieStrATM += '[\''+atmPiechart[k].User_Name__c +'\','+ atmPiechart[k].Mention_Count__c+'],';   
        }
        system.debug('------pieStrATM---------'+pieStrATM); 
        pieStrATM = pieStrATM.substring(0,pieStrATM .length()-1); 
        
        
        system.debug('---------------'+pieStr );
        system.debug('---------------'+uniqueHasTags);
    }    
    
    public static String fetchFinalStr(String body,String searchChar){
        String finalStr='';
        Integer bodylength = body.length();
        Integer fOccurance = body.indexOf('#');
        Integer sOccurance = body.indexOf(' ',fOccurance);
        if(sOccurance < 0){
            finalStr = body.substring(fOccurance,bodylength );
        }else{
            finalStr = body.substring(fOccurance,sOccurance);             
        }

        return finalStr;
    }

    public static String insertHasTagRecord(boolean f,String finalString,String fid, String hastagId,String dayOfWeek){
    
        if(hastagId == null){
            HashTags__c htAtMention = new HashTags__c();
            htAtMention.FID__c = fid;
            htAtMention.name = finalString;
            htAtMention.Flag__c = f;                                                //True for HashTag and False for @-Mention
            htAtMention.Day__c = dayOfWeek;
            insert htAtMention;
            return htAtMention.id; 
        }else{
            HashTags__c htAtMention = new HashTags__c(id=hastagId);
            htAtMention.FID__c = fid;
            htAtMention.name = finalString;
            htAtMention.Flag__c = f;                                                //True for HashTag and False for @-Mention
            htAtMention.Day__c = dayOfWeek;
            update htAtMention;
            return htAtMention.id; 
        }
        
                   
    }
    
    public void viewAnalytics(){
    
    }
}