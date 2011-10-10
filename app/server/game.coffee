# Server-side Code

exports.actions =

# 正しいゲームか
	isGame:(name)-> name=="dm"||name=="vg"
	
	
class exports.Card
	constructor:(@name)->

# カードを置く場所
class exports.Field
	constructor:(@visibility)->	# "public", "private", "hidden", "transparent"

class exports.FixedField extends exports.Field
	constructor:(@visibility,@length)->
		i=0
		@cards= while i++<@length
			null
			
	number:->@length

class exports.FlexibleField extends exports.Field
	constructor:(@visibility)->
		@cards=[]
	number:->@cards.length
		
class exports.Player
	constructor:->
		@userid=null
		@fields=[]


