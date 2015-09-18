public with sharing class JSONdemo {

	class Record {
		string firstname {get; set;}
		string lastname {get; set;}
		string entitytype {get; set;} 
		string thedate {get; set;}
		string searchtime {get; set;}
	}
	
	public static void rundemo() {
		// Create the data to attach to the account
		List<Record> reclist = new List<Record>();		
		for (integer i=0;i<10;i++) {
			Record rec = new Record();					// populate the record fields
			rec.firstname = 'first'+(i+1);		
			rec.lastname = 'last'+(i+1);
			rec.entitytype = 'ent'+(i+1);
			rec.thedate = Datetime.now().format('yyyy/MM/dd');
			rec.searchtime = Datetime.now().format('HH:mm:ss');

			reclist.add(rec);								
		}
		String jsonstr = JSON.serialize(reclist);
		Account myacct = new Account();
		myacct.name = 'acct_demo2';
		insert myacct;
		
		system.debug('JSON string:'+jsonstr);
		
		// create the attachment, store the JSON string
		Attachment datain;
		try {
			datain = new Attachment(parentId =myacct.id,name='demo2', body = Blob.valueOf(jsonstr) );
			insert datain; 
		} catch (Exception e) {	// Catch errors
			datain = new Attachment(parentId = myacct.id, name='Error', body = Blob.toPdf('Error: Could not create attachment. Exception:'+e) );
			insert datain; 
			return;			
		}
				
		// deserialize the data
		List<Record> rec2 = (List<Record>)JSON.deserialize(datain.body.toString(),List<Record>.class);  	// de-serialize
		for (integer vv=0; vv < rec2.size(); vv++) {
			system.debug('Record #'+(vv+1)+';');		
			system.debug('first name:'+rec2.get(vv).firstname);
			system.debug('last name:'+rec2.get(vv).lastname);
			system.debug('Entity:'+rec2.get(vv).entitytype);
			system.debug('Date:'+rec2.get(vv).thedate);
			system.debug('Search Time:'+rec2.get(vv).searchtime);
		}
		
		// clean up from the demo
		delete datain;
		delete myacct;		
	}


}