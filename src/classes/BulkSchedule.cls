global with sharing class BulkSchedule implements Schedulable {
	global void execute(SchedulableContext sc){
		// this starts the bulk report generation process.
		BulkGenerate.startProcess(); 
	}

	// call this to schedule the job every noon every day
	public static void scheduleTrades(){
		String sch = '0 0 12 * * ?';   // Sec Min Hr DayOfMonth Month DayOfWeek (OptYear) 
		system.schedule('Sched1',sch,new BulkSchedule());  
	}	
	
}