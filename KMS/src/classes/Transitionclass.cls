public class Transitionclass {
 public blob Attach { get; set; }
  public string att { get; set; }
public LIST<Article__c> art{get;set;}


   public Transitionclass (){
   art=[SELECT id,Name,Category__c,Description__c,Title__c,Video_URL__c FROM Article__c];
  

}
   public PageReference dosave() {
  
    
        return null;
    }

   
   public  List<SelectOption> options = new List<SelectOption>();

    public List<SelectOption> getItems() {
        options.add(new SelectOption('Share','Share'));
        options.add(new SelectOption('Embed','Embed'));
        return options;
    }

   public PageReference viewpdf() {
  
    PageReference pageRef = new PageReference('/apex/webpagedo1');
        return pageRef;
       
    }
 
}