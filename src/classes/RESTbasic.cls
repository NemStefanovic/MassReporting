@RestResource(urlMapping='/RESTbasic/*')
global with sharing class RESTbasic {

	@HttpPost
	global static void doPost(string input) {
		string re = 'Made it! Got string:'+input;   
		// code goes here
		system.debug(re);
		// send a response
		
		RestContext.response.responseBody = Blob.valueOf(re);
	} 

}