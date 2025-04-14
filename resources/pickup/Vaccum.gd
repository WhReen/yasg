extends Pickups
class_name PickupMagnet

func activate():
	super.activate()
	player_reference.get_tree().call_group("Pickup","follow", player_reference, true)
