# Server-side Code
# 新規登録
# cb: エラーメッセージ（成功なら偽）

exports.actions =
	newentry: (query,cb)->
		M.users.find({"userid":query.userid}).count (err,count)->
			if err?
				cb "そのユーザーIDは既に使用されています"
				return
			userobj = 
				userid: query.userid
				password: crpassword(query.password)
			M.users.insert(userobj,{safe:true},(err,records)->
				if err?
					cb "DB err:#{err}"
					return
				cb false


#パスワードハッシュ化
crpassword=(raw)-> raw
