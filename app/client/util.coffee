
exports.showWindow=showWindow=(templatename,tmpl)->
	x=Math.floor(Math.random()*100-200+document.documentElement.clientWidth/2)
	y=Math.floor(Math.random()*100-200+document.documentElement.clientHeight/2)

	win=$("##{templatename}").tmpl(tmpl).hide().css({left:"#{x}px",top:"#{y}px",}).appendTo("body").fadeIn()#.draggable()
	$(".getfocus",win.get(0)).focus()
	win

#要素を含むWindowを消す
exports.closeWindow=closeWindow= (node)->
	w=$(node).closest(".window")
	w.hide "normal",-> w.remove()
	
#true,false
exports.ask=(title,message,cb)->
	win = showWindow "templates-util-ask",{title:title,message:message}
	win.submit (je)-> je.preventDefault()
	win.click (je)->
		t=je.target
		if t.name=="yes"
			cb true
			closeWindow t
		else if t.name=="no"
			cb false
			closeWindow t
#String / null
exports.prompt=(title,message,type="text",cb)->
	win = showWindow "templates-util-prompt",{title:title,message:message}
	inp=win.find("input.prompt").get(0)
	inp.type=type
	win.submit (je)-> je.preventDefault()
	win.click (je)->
		t=je.target
		if t.name=="ok"
			cb? inp.value
			closeWindow t
		else if t.name=="cancel"
			cb? null
			closeWindow t
	
		


exports.message=(title,message,cb)->
	win = showWindow "templates-util-wmessage",{title:title,message:message}
	win.submit (je)-> je.preventDefault()
	win.click (je)->
		t=je.target
		if t.name=="ok"
			cb? true
			closeWindow t
			
			
exports.formQuery=(form)->
	q={}
	el=form.elements
	for e in el
		if e.tagName.toLowerCase()=="input"
			if e.type!="submit" && e.type!="reset" && e.type!="button"
				q[e.name]=e.value
	q
	
