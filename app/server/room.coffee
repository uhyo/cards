# Server-side Code

rooms=[]
###
room:{
	"id":number
	"name":name
	"type":"dm"
	"game":Game
	"user1":userid
	"user1name":name
	"user2":userid
	"user2name":name
	"time":number
}
###
class Room
	constructor:(@id,@name,@type,@user1,@user1name,@user2,@user2name)->
		@game=SS.server[@type].game.init()
		@time=Date.now()
	getObj:->
		{
			id:@id,name:@name,type:@type,user1:@user1,user1name:@user1name,user2:@user2,user2name:@user2name,time:@time
		}


exports.actions =

	getRooms:(cb)->cb rooms
	newRoom:(name,cb)->
		unless !name || 0 < name.length < 30
			cb {error:"ルーム名が不正です"}
			return
		M.rooms.find({}).count (err,count)=>
			if err?
				cb {error:"DB err:#{err}"}
			try
				room = new Room count+rooms.length, name, @session.attributes.game, @session.user_id, @session.attributes.user.name,  "", ""
				rooms.push room
				cb room.getObj()
				SS.publish.channel 'rooms','newRoom',room.getObj()
			catch e
				cb {error:"#{e}"}
# ルーム一覧で待つ人
	roomListen:(cb)->
		@session.channel.subscribe('rooms')
		cb true
	roomUnlisten:(cb)->
		@session.channel.unsubscribe('rooms')
		cb truem
		
# ルームに入る人
	enter:(roomid,cb)->
		room=rooms.filter((r)->r.id==roomid)[0]
		unless room?
			cb {error:"そのルームは存在しません"}
			return
		unless @session.user_id
			cb {error:"ログインして下さい"}
			return
		@session.channel.subscribe("room_#{roomid}")
		
		if room.user2=="" && @session.user_id != room.user1
			room.user2=@session.user_id
			room.user2name=@session.attributes.user.name
			# 情報チェンジ
			SS.publish.channel 'rooms','updateRoom',room.getObj()
			SS.publish.channel "room_#{room.id}", "roomInfo",room.getObj()
		
		cb room.getObj()
# ルームから出る人
	bye:(roomid,cb)->
		@session.channel.unsubscribe("room_#{roomid}")
		cb null
# 
