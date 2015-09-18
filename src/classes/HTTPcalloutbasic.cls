public with sharing class HTTPcalloutbasic {

		public static void callREST() {
			   string sessionid = UserInfo.getSessionId();
		       		       		       
		       String outbody = 'test string 1234';		       
		       System.debug('The JSON string generated:' + outbody);
		       
		       HttpRequest req = new HttpRequest();
		       req.setEndpoint('https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/RESTbasic/');
		       req.setMethod('POST');
		       req.setBody('{"input":"'+outbody+'"}');
		       req.setHeader('Authorization', 'Bearer '+ sessionId);
		       req.setHeader('content-type', 'application/json');
		       req.setTimeout(60000); // milliseconds 
		        
			   Http http = new Http();       
			   HTTPResponse res = http.send(req);
			   
			   system.debug(res);
			   system.debug(res.getBody());
		}

}