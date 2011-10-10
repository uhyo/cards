
game=require '../game.coffee'

class DMPlayer extends game.Player
	constructor:->
		@hands  = new game.FlexibleField "private"	# 手札
		@deck   = new game.FlexibleField "hidden"	# 山札
		@field  = new game.FlexibleField "public"	# 場
		@shields= new ShieldZone			# シールド
		@manas  = new game.FlexibleField "public"	# マナ
		@trash  = new game.FlexibleField "public"	# 墓地
		@chojigen=new game.FlexibleField "public"	# 超次元
		
class ShieldZone extends game.FlexibleField
	constructor:->
		@visibility="transparent"
		
class Card extends game.Card
	constructor:->
		@position=0		#0=縦 1=横
		@back=0			#0=表 1=裏
		@name=null

exports.actions =
#新しいゲームを作成
	init:->
		return {
			user1:new DMPlayer
			user2:new DMPlayer
		}
