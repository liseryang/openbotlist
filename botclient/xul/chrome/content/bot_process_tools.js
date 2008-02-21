
function change_url(event) {

	// Variables for convenient access to specific elements in the XUL
    var urlbox = document.getElementById("url");
    var contentview = document.getElementById("contentview");
    var wordcountbox = document.getElementById("wordcount");
    var charcountbox = document.getElementById("charcount");
    var elemcountbox = document.getElementById("elemcount");
    
    // Fake up the update code for now, to allow running in Firefox
    wordcountbox.previousSibling.value = " (fake)";
    wordcountbox.value = "1000";
    charcountbox.previousSibling.value += " (fake)";
    charcountbox.value = "100";
    elemcountbox.previousSibling.value += " (fake)";
    elemcountbox.value = "10";
}

function runProcess() {
	var wordcountbox = document.getElementById("wordcount");
	wordcountbox.previousSibling.value = " Starting";
	
	try {
		// create an nsILocalFile for the executable
		var file = Components.classes["@mozilla.org/file/local;1"]
	                     .createInstance(Components.interfaces.nsILocalFile);
		file.initWithPath("/home/bbrown/workspace_omega/botlistprojects_beta/botbert/bin/bot_scan_job.sh");		
	
		// create an nsIProcess
		var process = Components.classes["@mozilla.org/process/util;1"]
	                        .createInstance(Components.interfaces.nsIProcess);
		process.init(file);
	
		// Run the process.
		// If first param is true, calling thread will be blocked until
		// called process terminates.
		// Second and third params are used to pass command-line arguments
		// to the process.
		var args = ["test", "argument2"];
		process.run(false, args, args.length);
	} catch(err) {
		alert(err);
		return;
	}
	wordcountbox.previousSibling.value = " Done";
}