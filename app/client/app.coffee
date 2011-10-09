# Client-side Code

# Bind to socket events
#SS.socket.on 'disconnect', ->  $('#message').text('SocketStream server is down :-(')
#SS.socket.on 'reconnect', ->   $('#message').text('SocketStream server is up :-)')

findParent = (node,callback)->
	while node=node.parentNode
		if callback(node)
			break
	node

#小文字で！
isTag = (node,tagname)->
	node.nodeName.toLowerCase()==tagname
	
exports.init= ->
	$("#templates-upmenu-unlogin").tmpl().appendTo("#userinfo")
	
	document.addEventListener "click",evclick,false
	document.addEventListener "submit",evsubmit,false
	
	SS.client.app.page "templates-page-top",null
	
#	SS.server.app.init (mes)-> console.log mes

	# ログイン
	SS.events.on 'login', (message)->
		loginuser message
	
exports.page=(templatename,params,pageobj)->
	cdom=$("#content").get(0)
	jQuery.data(cdom,"end")?()
	jQuery.removeData cdom,"end"
	$("#content").empty()
	$("##{templatename}").tmpl(params).appendTo("#content")
	if pageobj
		pageobj.start()
		jQuery.data cdom, "end", pageobj.end
	
evclick=(e)->
	t=e.target
	if (menu=findParent t,((node)-> isTag(node,"menu"))) && (findParent menu,(node)-> node.id=="userinfo")
		# 上メニューのコマンド
		switch t.name
			when "login"
				#ログインウィンドウ
				showWindow "templates-user-login"
			when "newentry"
				#新規登録
				showWindow "templates-user-newentry"
			when "logout"
				#ログアウト
				SS.server.user.logout (result)->
					console.log result
					SS.client.app.page "templates-page-top",null,null
					$("#userinfo").empty()
					$("#templates-upmenu-unlogin").tmpl().appendTo("#userinfo")
	else if $(t).hasClass("closer")
		win=$(t).closest(".login")
		closeWindow t if win.length>0
		
					

# 戻り値：jQuery
showWindow= (templatename)->
	x=Math.floor(Math.random()*100-200+document.documentElement.clientWidth/2)
	y=Math.floor(Math.random()*100-200+document.documentElement.clientHeight/2)

	win=$("##{templatename}").tmpl().hide().css({left:"#{x}px",top:"#{y}px",}).appendTo("body").fadeIn()#.draggable()
	$(".getfocus",win).focus()

#要素を含むWindowsを消す
closeWindow= (node)->
	w=$(node).closest(".window")
	w.hide "normal",-> w.remove()
	
evsubmit=(e)->
	form=e.target
	e.preventDefault()
	switch form.name
		when "loginform"
			#ログイン
			SS.server.user.login {userid: form.elements["userid"].value, password: form.elements["password"].value},(result)->
				if !result
					closeWindow form
				else
					form.getElementsByClassName("error")[0].textContent="ユーザーIDまたはパスワードが違います。"
		when "newentryform"
			# 新規登録
			#console.log SS.server.user.newentry
			SS.server.user.newentry {userid: form.elements["userid"].value, password: form.elements["password"].value},(result)->
				if result
					form.getElementsByClassName("error")[0].textContent=result
				else
					#ウィンドウを閉じる
					closeWindow form
#ログインした
loginuser=(user)->
	$("#userinfo").empty()
	$("#templates-upmenu-login").tmpl(user).appendTo("#userinfo")
	SS.client.app.page "templates-user-profile",user,SS.client.user.profile
