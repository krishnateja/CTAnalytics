public with sharing class ArticleDetailPageController {

    Public Article__c ar{get; set;}
    Public String ArId{get; set;}
    Public String Send{get; set;}
    Public LIST <Attachment> NA{get; set;}
    Public LIST<Attachment> NA1{get; set;}
    Public Integer num{get;set;}

   /* Public String NA{get; set;}*/

    public ArticleDetailPageController(ApexPages.StandardController controller) {
    ArId = apexpages.currentpage().getparameters().get('id');  
   ar = [SELECT (SELECT Id, Title FROM Notes),Description__c,Embed__c,Name,Share__c,Title__c,Video_URL__c,Id,Share_Flag__c  FROM Article__c where Id =: ArId];
   
  NA =[SELECT Id,ParentId FROM Attachment where ParentId=:ArId ];
 num = NA.size();
  system.debug('--num--'+num);
if(num > 0)
{

NA1=NA;
}


 System.debug('------NA1--------'+NA1);

  }   
}