public with sharing class BulkSender {
	
	// used to serialize/deserialize JSON for Metadata notes
	// This is information about the report (not content of report itself)	
    public class MetaNotes {
    	public string username {get; set;}		
    	public string thedatetime {get; set;}
    	
    	// describes individual rows, tables, segments of the reports
    	public List<string> stuff {get; set;}
    	public List<string> morestuff {get; set;}    	    
    }     

	// This function is made future to ensure the BulkAttach method transaction completes its DML operations.
	// Then a PDF can be generated since it requires a separate session.
	@future(callout=true)
	public static void finishPDFattach(List<String> AccountIDs, List<string> datains) {
		// OauthAuthentication
		String sessionId; 
		try {
			sessionId = OauthAuthenticate();
		} catch (Exception e) {
			System.debug('Authentication failure. Exception:'+e);
			return;
		}
			
		if (sessionId == null) {
			System.debug('Null session Id. Aborting PDF generation.');
			return;
		}

       System.debug('sessionID:'+sessionId);
       
       // build the JSON string here              
       BulkPDFAttach.JSONout tmp = new BulkPDFAttach.JSONout(); 
       tmp.accountIDs = AccountIDs; 
       tmp.datains = datains;
       
       String outbody = JSON.serialize(tmp);
       
       System.debug('The JSON string generated:' + outbody);
       
       HttpRequest req = new HttpRequest();
       req.setEndpoint(secret.endpointURL);
       req.setMethod('POST');
       req.setBody('{"JSONin":'+outbody+'}');
       req.setHeader('Authorization', 'Bearer '+ sessionId);
       req.setHeader('Content-Type', 'application/json');      
       req.setTimeout(60000); // milliseconds 
        
	   Http http = new Http();       
	   HTTPResponse res = http.send(req);
	}
	
	// This handles the Oauth authentication
	//
	//  based on information from our connected app in setup > create > apps,   in connect app section called "OauthGateway"
	// 
    public static String OauthAuthenticate() {
    	String URL = 'https://login.salesforce.com/services/oauth2/token';
        String body = '';
        // add parameters here
        body += 'grant_type=password&';			// this is hard coded for username password Oauth flow 
        body += 'client_id='+secret.oauthclient+'&';	// from the client_id parameter on our connected app
        body += 'client_secret='+secret.oauthsecret+'&';
        body += 'username='+secret.oauthuser+'&';
        body += 'password='+secret.oauthpasstoken;         
        
        Http http = new Http();
       	HttpRequest req = new HttpRequest();
       	req.setEndpoint(URL);
       	req.setMethod('POST');
        req.setBody(body);
       	req.setTimeout(15000); // milliseconds 
       	
       	HttpResponse response = null;
       	try {
       			response = http.send(req);
       	} catch (System.CalloutException e) {
       		// callout exception, possible timeout
       		System.debug('Callout exception, possible timeout, Exception:'+e);       		
       		throw e;
       		       		
    	}
       	system.debug('response is:'+response);
    	
    	if (response == null) {
    		system.debug('Invalid response from Oauth Authentication callout.');
    		return null;
    	}
    	
        // Parse JSON response to get all the field values.
        //
	    JSONParser parser = JSON.createParser(response.getBody());

        String thesessionId = null;
	    while (parser.nextToken() != null) {
	            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
	                (parser.getText() == 'access_token')) {
	                // Get the value.
	                parser.nextToken();
	                // Compute the grand total price for all invoices.
	                thesessionId = parser.getText();
	            }
	    }
	            		        
       	return thesessionId;
    } 
	
}