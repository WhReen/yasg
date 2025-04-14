extends Pickups
class_name Health

@export var amount : float = 20.0

func activate():
	super.activate()
	print( str(player_reference.health) + " and max health is " + str(player_reference.max_health) )
	player_reference.health = player_reference.health + player_reference.max_health*(amount/100)
