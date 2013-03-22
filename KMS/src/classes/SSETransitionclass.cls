public class SSETransitionclass {
Public Attachment myfile {get;set;}
public blob Attach { get; set; }
//public string att { get; set; }
public string btn{get;set;}
public string Title{get;set;}
public string Des{get;set;}
public Article__c art{get;set;}
public string share{get;set;}
public string Embed{get;set;}

           public SSETransitionclass() {
                art=new Article__c();
                myfile = new Attachment();     
                         }
public SSETransitionclass(String Title, String Des,string share,string Embed,Attachment a ){ 
   art = new Article__c();
      art.Title__c=Title;
      art.Description__c=Des;
      art.Share__c=share;
      art.Embed__c=Embed;
       myfile=a;
       insert art;
       
   }
   public SSETransitionclass(ApexPages.StandardController controller) {
        
    }
    
     public  List<SelectOption> options = new List<SelectOption>();

    public List<SelectOption> getItems() {
        options.add(new SelectOption('Share','Share'));
        
        options.add(new SelectOption('Embed','Embed'));
        return options;
    }
public PageReference viewpdf() {
         PageReference pageRef = new PageReference('/apex/webpagedo1?id=Article.Id');
         return pageRef;
       
    }
      public PageReference dosave() {
      String artid = System.currentPagereference().getParameters().get('artid');
        insert art;
         Attachment a = new Attachment(parentId = art.id, name=myfile.name, body = myfile.body);
        insert a;
        
        PageReference pageRef = new PageReference('/apex/webpagedo1');
              
        return pageRef;
           }
public PageReference preview() {
         PageReference pageRef = new PageReference('/apex/webpagedo1');
         return pageRef;
       
    }
   
}