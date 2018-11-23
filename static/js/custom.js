$(document).ready(function() {

/* Navbar item activation listener */
	var pageTitle = $("title").text();
	$(".nav-item").each(function(){
		$(this).removeClass("active");
		var navTitle = $(this).attr("nav-title");
		if(navTitle==pageTitle){
			$(this).addClass("active");
		}
	});

/* Predict button listener */
	$(".predict-btn").click(function(){

		var temp = $("tbody tr");
		var dict = {};

		temp.each(function(index){
			var checkFlag = $(this).find(".form-check-input").prop('checked');
			if(checkFlag == true){
				var recordID = $(this).attr('id');
				var recordValue = $(this).find("select").find(":selected").text();
				dict[recordID] = recordValue;
			}
		});
		console.log(dict);

		$.get("/predictFromList",dict,
		function(data, status){
			console.log("Data: " + data + " - " + "Status: " + status);
		});
		reload();
	});

/* Retrain button listener */
	$(".retrain-btn").click(function(){

		var temp = $("tbody tr");
		var dict = {};

		temp.each(function(index){
			var checkFlag = $(this).find(".form-check-input").prop('checked');
			if(checkFlag == true){
				var recordID = $(this).attr('id');
				var recordValue = $(this).find("select").find(":selected").text();
				dict[recordID] = recordValue;
			}
		});
		console.log(dict);

		$.get("/updateRetrainFlag",dict,
		function(data, status){
			console.log("Data: " + data + " - " + "Status: " + status);
		});
	});

});
