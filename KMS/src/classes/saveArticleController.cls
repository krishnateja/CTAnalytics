public class saveArticleController{

    public blob Attach { get; set; }
    public string att { get; set; }
    public string btn{get;set;}
    public string Title{get;set;}
    public string Des{get;set;}
    public Article__c art{get;set;}
    public string share{get;set;}
    public string Embed{get;set;}
    public boolean saveFlag{set;get;}
    public boolean previewFlag{set;get;}
    
    public saveArticleController(){
        saveFlag=true;
        previewFlag=false;    
    }
            
    public pageReference dosave() {
    
        system.debug('----------------'+Title ); 
        system.debug('----------------'+Des ); 
        
        art = new Article__c();
        art.Title__c=Title;
        art.Description__c=Des;
        art.Share__c=share;
        //art.Embed__c=Embed;
        insert art;
        
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = art.id; // the record the file is attached to
        attachment.IsPrivate = true;
     
        try {
          insert attachment;
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));          
        } finally {
          attachment = new Attachment(); 
        }
     
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully')); 
        pageReference pr = new pageReference('/apex/homepage');
      return pr;  
    }
    
    public Attachment attachment {
        get {
          if (attachment == null)
            attachment = new Attachment();
          return attachment;
        }
        set;
    }
    
    public pagereference showPreview() {
    system.debug('----------------');
     /*  saveFlag=false;
        previewFlag=true;
        system.debug('----------------'+Title ); 
        system.debug('----------------'+Des ); 
        Title = 'test';
        Des = 'test'; */
    //  Title = .Title ;   
    //   Des = attachment.description;
     //  pageReference pr4 = new pageReference('/apex/previewPage');
      //pageReference pr = new pageReference('/apex/ArticleDetailpage?id='+art.Id);
      return Page.previewPage;
        
       
    }
    
    public pagereference nextPage() {
 // pageReference pr=new pageReference('/apex/previewPage');
 // return Pr;
     return Page.previewPage;
      
       
    }
     public pagereference backPage() {
     return Page.saveArticle;
     }
    
   
}