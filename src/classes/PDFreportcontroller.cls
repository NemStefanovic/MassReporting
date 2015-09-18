public with sharing class PDFreportcontroller {
	public Attachment theattachment {get; set;}	// the attachment has the required content, and the parentid
	public List<BulkGenerate.ReportEntry> payload {get; set;}			// this is the body of the attachment in List<String> format
			 
	public PDFreportcontroller() {
		payload = new List<BulkGenerate.ReportEntry>();
		
		// get the attachment ID. The info in the attachment will be used to build the page
		ID attachID = Apexpages.currentPage().getParameters().get('attachmentID');
		if (attachID == null) {
			return;
		}
		
		System.debug('received id:'+attachID);
		
		// query the attachment by ID
		theattachment = [SELECT id, name, parentId, body FROM Attachment WHERE id=:attachID];
		if (theattachment == null) {
			return;
		}
		
		// convert body from blob to string, then JSON deserialize.
		payload = (List<BulkGenerate.ReportEntry>)JSON.deserialize(theattachment.body.toString(), List<BulkGenerate.ReportEntry>.Class);
				
	}
}