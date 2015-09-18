public with sharing class BulkGenerate {

    public static void startProcess() 	{   

			System.debug('Bulk generaton process start.');
		 	    				
			// iteratively process each report here, attach results as JSON string to temporary
			// attachments on each account.
			List<Attachment> alldatain = new List<Attachment>();
			List<Account> myaccounts = [SELECT id, name, MetaNotes__c, stuff__c FROM Account WHERE name LIKE 'AUTO%'];		
			for (integer i=0; i < myaccounts.size(); i++) {
				// get the current time, as the search time
		    	String currenttime = Datetime.now().format('YYYY-MM-dd HH:mm:ss');

				// generate the first report content here												 
	    		List<ReportEntry> currentdata = fakeprocessing();
	    		
	    		// attach the processed data (intended for report content) 
	    		Attachment datain;
				String pdfpendingjson = JSON.serialize(currentdata); 
	    		try {
			    	datain = new Attachment(parentId = myaccounts.get(i).id, name='PDF_PENDING', body = Blob.valueOf(pdfpendingjson) );
			    	alldatain.add(datain);
	    		} catch (Exception e) {
					System.debug('Error: Could not create attachment. Exception:'+e);
					
					// create the appropriate error message, and attachment
			    	datain = new Attachment(parentId = myaccounts.get(i).id, name='Error', body = Blob.toPdf('Error: Could not create attachment. Exception:'+e) );					
			    	alldatain.add(datain);
					continue; 
	    		}
									
				// are there any existing notes to deserialize in the selected account?
				BulkSender.MetaNotes finalnotes = new BulkSender.MetaNotes(); 
    			finalnotes.username = 'John Doe';		
    			finalnotes.thedatetime = currenttime;    	
		    	finalnotes.stuff = new List<String>{'stuff1','stuff2','stuff3'};
											
				// deserialize the existing metadata, if it exists				
				string existingnotes = myaccounts.get(i).MetaNotes__c;	
				BulkSender.MetaNotes pastnotes;
				if (existingnotes == null || existingnotes == '') // no notes entered as of yet
				{
					// nothing to deserilize
					pastnotes = new BulkSender.MetaNotes();
				} else {	// deserialize the existing notes
					pastnotes = (BulkSender.MetaNotes)JSON.deserialize(existingnotes,BulkSender.MetaNotes.class);

					// add the past metadata "stuff" to current "stuff"
					for (integer k=0; k < pastnotes.stuff.size();k++) {
						finalnotes.stuff.add(pastnotes.stuff.get(k));
					}				
				}
												
				myaccounts.get(i).MetaNotes__c = JSON.serialize(finalnotes);		// attach the JSON string						
			}
					   	
			insert alldatain;			// one bulk insert done here			
			update myaccounts;			// update the accounts all in bulk	    	
						
			// finally, schedule a future to come around and replace the data with a PDF attachment
			List<String> aids = new List<String>();
			List<String> attids = new List<String>();
			for (integer i = 0; i < myaccounts.size();i++) {
				if (Math.mod(i, 50) == 0 && i > 0) {	
					// send off the future
					BulkSender.finishPDFattach(aids,attids);

					aids.clear();
					attids.clear();
				}								
				aids.add(myaccounts.get(i).id);					
				attids.add(alldatain.get(i).id);					
			}
			// send off whatever is left.
			BulkSender.finishPDFattach(aids,attids);
    }
    
    // This object is passed in an attachment 
    public class ReportEntry {
                
        public string ID {get; set;}    
        public string name {get; set;}
        public string summary {get; set;}
        public string dailyposition {get; set;}
    	public string trend {get; set;}	
    	public string delta {get; set;}	
    
    }    
        
    // Any processing work is done here!!
    // Returns a list of type Datawrapper (above), each of which will be an entry in the report
    public static List<ReportEntry> fakeprocessing() {
    	List<ReportEntry> ret = new List<ReportEntry>();
    	Integer rndnum = 30;
    	for (integer i=0; i < rndnum; i++) {
    		ReportEntry tmp = new ReportEntry();    	
			List<String> rndstr = new List<String>();
			for (integer v=0; v < 6; v++) {
				string randomstr = constructTestString();		
				if (randomstr.length() > 10)
					randomstr = randomstr.substring(0,10);	    				    	
			    rndstr.add(randomstr);
			} 
			    
			tmp.ID = rndstr.get(0);
			tmp.name = rndstr.get(1);
			tmp.summary = rndstr.get(2);
			tmp.dailyposition = rndstr.get(3);
			tmp.trend = rndstr.get(4);
			tmp.delta = rndstr.get(5);
		    ret.add(tmp);
    	}
	    
    	return ret;
    }

	// this method constructs a random string
	public static String constructTestString() {
	    String sampleref = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
	    
	    Integer rndnum1 = Math.mod(Math.abs(Crypto.getRandomInteger()),sampleref.length());	    
	    Integer rndnum2 = Math.mod(Math.abs(Crypto.getRandomInteger()),sampleref.length());	    
	    String sample1 = sampleref.substring(rndnum1); 
	    String sample2 = sampleref.substring(sampleref.length()-1-rndnum2); 		
	    	    
		if (Math.mod(rndnum1,2)==0)	    	    
	    	return sample1+sample2;
	    else
	    	return sample2+sample1;
	    	
	}
}