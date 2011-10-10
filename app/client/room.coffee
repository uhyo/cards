exports.start=->
	$("section.rooms form").submit (je)->
		je.preventDefault()
		SS.client.util.prompt "ルーム作成","ルームの名前を入力して下さい",{maxlength:30},(name)->
			SS.server.room.newRoom name,(result)->
				console.log result
				if result.error?
					SS.client.app.message "エラー","ルーム作成に失敗しました：#{result.error}"
					return
				#oneRoom result
	
	SS.server.room.getRooms (rooms)->
		for room in rooms
			oneRoom room
	SS.server.room.roomListen (result)->
	SS.client.app.socket.on 'newRoom',(msg,channel)->
		if channel=="rooms"
			oneRoom msg
	SS.client.app.socket.on 'updateRoom',(msg,channel)->
		if channel=="rooms"
			oneRoom msg
exports.end=->
	SS.server.room.roomUnlisten (result)->
	SS.client.app.socket.off 'newRoom'
				
				
				
exports.oneRoom=oneRoom=(room)->
	console.log room
	t=$("#roomstable").get(0)
	
	tr=null
	for r in t.rows
		if r.dataset.id=="#{room.id}"
			tr=r
			break
	if tr
		$(tr).empty()
	else
		tr=t.insertRow -1
		tr.dataset.id=room.id

	td=tr.insertCell 0
	a=document.createElement "a"
	a.href="/room/#{room.id}"
	a.textContent=room.name
	td.appendChild a
	td=tr.insertCell 1
	a=document.createElement "a"
	a.href="/user/#{room.user1}"
	a.textContent=room.user1name
	td.appendChild a
	
	td=tr.insertCell 2
	if room.user2
		a=document.createElement "a"
		a.href="/user/#{room.user2}"
		a.textContent=room.user2name
		td.appendChild a
	else
		td.textContent="募集中"
	
