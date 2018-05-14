// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets
//= require popper

$("document").ready(function(){	
	$("#loginform").on("mouseover", function(){
		// ajaxgetcall("/uselogin/loginform");
		setButtonClass(this.id);
	});
});

var setButtonClass = (x)=>{
	// $("#"+x).addClass("btn btn-success");	
	// ajaxgetcall('http://localhost:3000/apiusers/apiuserlist');
};
var ajaxgetcall = (req)=>{
	$.ajax({		
		type: "get",
		url: req,
		beforeSend: function (xhr) {
  			xhr.setRequestHeader("apikey", "asdfghjklz");
		},
		// data: {"apikey":"asdfghjklz"},
		success: (d)=>{
			alert("Success:" +JSON.stringify(d));
		},
		error: function(error){
          alert(JSON.stringify(error));
      } 
	})
};