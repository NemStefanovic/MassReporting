public with sharing class Init {
	
	// Demo 1
	// JSONdemo.rundemo();
	
	// Demo 2
	// HTTPcalloutbasic.callREST();
		
	/* Demo 3
	Init.removeAccounts();
	Init.createAccounts(100);
	Bulkgenerate.startProcess();
	*/
	
	// create accounts in bulk
	public static void createAccounts(integer num) {
		List<Account> accts = new List<Account>();
		for (integer i=0; i < num;i++) {
			Account a = new Account();
			a.name = 'AUTO'+(i+1);
			a.AccountNumber = Datetime.now().format('yyyyMMddHHmmssSSS');
			a.Phone = ''+Math.round(Math.random()*10000000);
			accts.add(a);
		}
		insert accts;
		system.debug(accts);
	}
	
	public static void removeAccounts() {
		List<Account> accts = [SELECT id, name FROM Account WHERE name LIKE 'AUTO%'];
		Set<String> ids = new Set<String>();
		for (integer i=0; i < accts.size(); i++) {
			ids.add(accts.get(i).id);
		}
		List<Attachment> atts = [SELECT id, name,parentid FROM Attachment WHERE parentid=:ids];
		delete atts;
		delete accts;
	}
}