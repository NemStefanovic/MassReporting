@RestResource(urlMapping='/BulkPDFAttach/*')
global with sharing class BulkPDFAttach{    	
	global class JSONout {
		global List<String> accountIDs;
		global List<String> datains;
	}
      
  	@HttpPost
    global static void doPost(JSONout JSONin) {   
		System.debug('REST call: BulkPDFattach');
		
		List<String> AccountIDs = JSONin.accountIDs; 
		List<string> datains= JSONin.datains;		

		list<Attachment> alldatain = new List<Attachment>();
		list<Attachment> deletelist = new List<Attachment>();
		
		for (integer i=0; i < datains.size(); i++) {
		    	PageReference pageref = new PageReference('/apex/PDFreport'); 
		    	
		    	// the data attachment
		    	pageref.getParameters().put('attachmentID',datains.get(i));			    	

		    	String currenttime = Datetime.now().format('yyyyMMddHHmmss');
	    	
		    	Attachment attach = new Attachment(parentId = AccountIDs.get(i), name='autoreport_'+currenttime+'.pdf', body = Blob.valueOf('tobereplaced') );  // pageref.getContentasPDF()
				attach.body = pageref.getContentAsPDF();
				
				alldatain.add(attach);					    			    	
		}
		
		// insert all PDF attachments					    	
		insert alldatain;	 		
		
		// delete all temporary data attachments					    	
		deletelist = [SELECT id, name FROM Attachment WHERE id IN :datains];		
		delete deletelist;
				        					
    }            
}