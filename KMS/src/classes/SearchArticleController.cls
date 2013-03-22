public with sharing class SearchArticleController {

    public String choosenType{set;get;}
    public String artName{set;get;}
    
    public superItemMap[] dataSetAll {get;set;}
    public superItemMap[] dataSetOne {get;set;}
    public superItemMap[] dataSetTwo {get;set;}
    public superItemMap[] dataSetThree{get;set;}
    
    public Integer allNumber{get;set;}
    public Integer csNumber{get;set;}
    public Integer bpNumber{get;set;}
    public Integer kvNumber{get;set;}
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Best Practices','Best Practices'));
        options.add(new SelectOption('Code Share','Code Share'));
        options.add(new SelectOption('Knowledge Videos','Knowledge Videos'));
        
        return options;
    }
    
    public void search(){
        allNumber=0;csNumber=0;bpNumber=0;kvNumber=0;
        String q='SELECT id,Name,Title__c,Description__c,Video_URL__c,Category__c from Article__c WHERE (Category__c=';
        
        if(choosenType == 'All'){
            q+= '\'Code\' OR Category__c= \'Best Practices\' OR Category__c= \'Knowledge Videos\' OR Category__c= \'All\' ) ';
        }else if(choosenType == 'Best Practices'){
            q+= '\'Best Practices\' )';
        }else if(choosenType == 'Code Share'){
            q+= '\'Code\' )';
        }else if(choosenType == 'Knowledge Videos'){
            q+= '\'Knowledge Videos\' )';
        }
        q+=' AND Title__c like \'%'+artName+ '%\' '; 
        
        try{
            system.debug('--------------'+q);
            List<Article__c> a = Database.query(q);
            
            dataSetOne = new superItemMap[]{};
            dataSetTwo = new superItemMap[]{};
            dataSetThree = new superItemMap[]{};
            dataSetAll = new superItemMap[]{};
            
            for(integer ii=0;ii<a.size();ii++){                        
                if(a[ii].Category__c == 'All'){                     
                    dataSetAll.add(new superItemMap(a[ii].Id,a[ii].Title__c,a[ii].Description__c,a[ii].Video_URL__c));                                                                            
                }                                           
            }
            allNumber =   dataSetAll.size();  
            system.debug('-------------'+allNumber );
            
            for(integer ii=0;ii<a.size();ii++){        
                if(a[ii].Category__c == 'Best Practices'){
                    dataSetOne.add(new superItemMap(a[ii].Id,a[ii].Title__c,a[ii].Description__c,a[ii].Video_URL__c));                                                                                        
                }                                        
            }
            bpNumber = dataSetOne.size();
            system.debug('-------------'+bpNumber ); 
            for(integer ii=0;ii<a.size();ii++){                       
                if(a[ii].Category__c == 'Code'){
                    dataSetTwo.add(new superItemMap(a[ii].Id,a[ii].Title__c,a[ii].Description__c,a[ii].Video_URL__c));                          
                }                                      
            }
            csNumber = dataSetTwo.size();
            system.debug('-------------'+csNumber ); 
            for(integer ii=0;ii<a.size();ii++){                        
                if(a[ii].Category__c == 'Knowledge Videos'){
                    dataSetThree.add(new superItemMap(a[ii].Id,a[ii].Title__c,a[ii].Description__c,a[ii].Video_URL__c));                                       
                }                           
            } 
            kvNumber = dataSetThree.size();   
            system.debug('-------------'+kvNumber ); 
        }catch(Exception e){
            System.debug('-------------'+e);        
        }
        
    }
    
    
    
    public class superItemMap{
        public String f1 {get;set;}
        public String f2 {get;set;}
        public String f3 {get;set;}
        public String f4 {get;set;}
        public String f5 {get;set;}
        public date f6 {get;set;}
        public String f7 {get;set;}
        
        public superItemMap(String fc1, String fc2, String fc3,String fc4) {
            f1 = fc1;
            f2 = fc2;
            f3 = fc3;
            f4 = fc4;   
            
        }

    }
}