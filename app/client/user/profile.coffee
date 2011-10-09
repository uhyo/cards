#page module?

name_length_max=20

exports.start=->
	$("section.profile p.edit").click (je)->
		t=je.target
		inp=document.createElement "input"
		inp.value=t.textContent
		inp.name=t.dataset.pname
		inp.type=t.dataset.type
		inp.maxlength=t.dataset.maxlength
		np=document.createElement "p"
		np.appendChild inp
		t.parentNode?.replaceChild np,t
		inp.focus()
		
	$("section.profile form").submit (je)->
		je.preventDefault()
		q=SS.client.util.formQuery je.target
		q.userid=$("p.userid").get(0).textContent
		console.log q
		SS.client.util.prompt "プロフィール","パスワードを入力して下さい","password",(result)->
			if result
				q.password=result
				console.log q
				SS.server.user.changeProfile q,(result)->
					console.log result
					if result.error?
						SS.client.util.message "エラー",result.error
					else
						SS.client.app.page "templates-user-profile",result,SS.client.user.profile
exports.end=->
