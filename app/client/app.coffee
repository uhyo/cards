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
	
	SS.server.app.init (mes)-> console.log mes
	
evclick=(e)->
	t=e.target
	console.log t
	if (menu=findParent t,((node)-> isTag(node,"menu"))) && (findParent menu,(node)-> node.id=="userinfo")
		# 上メニューのコマンド
		switch t.name
			when "login"
				#ログインウィンドウ
				showWindow "templates-user-login"
			when "newentry"
				#新規登録
				showWindow "templates-user-newentry"
	console.log menu

showWindow= (templatename)->
	x=Math.floor(Math.random()*100-200+document.documentElement.clientWidth/2)
	y=Math.floor(Math.random()*100-200+document.documentElement.clientHeight/2)

	console.log $("##{templatename}").tmpl().hide().css({left:"#{x}px",top:"#{y}px",}).appendTo("body").fadeIn()#.draggable()
	
evsubmit=(e)->
	form=e.target
	switch form.name
	#	when "login"
			# ログイン
			#SS.server.
		when "newentry"
			# 新規登録
			SS.server.user.newentry {userid: form.elements["
