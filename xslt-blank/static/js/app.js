log=console.log
locale={}
$(document).ready(function(){
	$("."+appData.moduleName).addClass("active")

	$('.tooltip-trigger').tooltip()

	$('#user-settings').popover({
		html:true,
		placement:"bottom",
		content:$("#user-settings .details").html(),
		container: '#user-settings'
	})

	var updateLocales=function(){
		$("*[data-locale]").each(function(n,node){
			$(node).html(locale[$(node).attr("data-locale")] || locale["noLocaleString"])
		})
	}

	var x=$.ajax({
		url:"/locale/"+$("html").attr("lang")+".json",
		success:function(data){
			locale=data
			updateLocales()
		},
		error:function(a,b,c,d){
			log(a,b,c,d)
		},
		dataType:"json"
	})

	$(document).bind("ajaxSuccess", function(){
		updateLocales()
	})

	if (innerWidth>750) {}

})
