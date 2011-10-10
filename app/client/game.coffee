exports.start=(room)->
	SS.client.app.socket.on 'roomInfo', (room,channel)->
		if channel=="room_#{room.id}"
			setRoomInfo room
	thisRoom=room
	SS.client[room.type].game.init room
			

exports.end=->
	SS.server.room.bye thisRoom.id,(result)->
	thisRoom=null


setRoomInfo=(room)->
	$("#user1").text(room.user1name ? "---");
	$("#user2").text(room.user2name ? "---");

thisRoom=null
