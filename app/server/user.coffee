# Server-side Code
hashlib=require('hashlib');

exports.actions =

# ログイン
# cb: 失敗なら真
	login: (query,cb)->
		@session.authenticate 'auth', query, (response)=>
			console.log response
			if response.success
				@session.setUserId response.userid
				cb false
				SS.publish.user response.userid,'login', response
			else
				cb true
				
# ログアウト
	logout: (cb)->
		@session.user.logout(cb)
			
# 新規登録
# cb: エラーメッセージ（成功なら偽）
	newentry: (query,cb)->
		unless /^\w*$/.test(query.userid)
			cb "ユーザーIDが不正です"
			return
		unless /^\w*$/.test(query.password)
			cb "パスワードが不正です"
			return
		M.users.find({"userid":query.userid}).count (err,count)->
			if count>0
				cb "そのユーザーIDは既に使用されています"
				return
			userobj = makeuserdata(query)
			M.users.insert userobj,{safe:true},(err,records)->
				if err?
					cb "DB err:#{err}"
					return
				SS.server.user.login query,cb
				
# ユーザーデータが欲しい
	userData: (userid,password,cb)->
		M.users.findOne {"userid":query.userid},(err,record)->
			if err?
				cb null
				return
			if !record?
				cb null
				return
			delete record.password
			unless password && record.password==SS.server.user.crpassword(password)
				delete record.email
			cb record
				
# プロフィール変更 返り値=変更後 {"error":"message"}
	changeProfile: (query,cb)->
		M.users.findOne {"userid":@session.user_id,"password":SS.server.user.crpassword(query.password)},(err,record)=>
			if err?
				cb {error:"DB err:#{err}"}
				return
			if !record?
				cb {error:"ユーザー認証に失敗しました"}
				return
			if query.name?
				if query.name==""
					cb {error:"ニックネームを入力して下さい"}
					return
					
				record.name=query.name
			if query.email?
				record.email=query.email
			if query.comment?
				record.comment=query.comment
			M.users.update {"userid":@session.user_id}, record, {safe:true},(err,count)->
				if err?
					cb {error:"プロフィール変更に失敗しました"}
					return
				cb record
				


#パスワードハッシュ化
	crpassword: (raw)-> raw && hashlib.sha256(raw+hashlib.md5(raw))
#ユーザーデータ作る
makeuserdata=(query)->
	{
		userid: query.userid
		password: SS.server.user.crpassword(query.password)
		name: query.userid
		comment: ""
	}
