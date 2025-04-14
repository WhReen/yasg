extends Item
class_name Weapon
 
@export var damage : float
@export var cooldown : float
@export var speed : float
 
@export var projectile_node : PackedScene = preload("res://scenes/projectile.tscn")
 
@export var upgrades : Array[Upgrade]

@export var item_needed : PassiveItem
@export var evolution : Weapon
@export var sound : AudioStream
@export var pitchRandom : bool

var slot

func activate(_source, _target, _scene_tree):
	pass
	
func is_upgradable() -> bool:
	if level <= upgrades.size():
		return true
	return false

func upgrade_item():
	if not is_upgradable():
		return
		
	var upgrade = upgrades[level - 1]
	
	damage += upgrade.damage
	cooldown += upgrade.cooldown
	
	level += 1
	
func max_level_reached():
	if upgrades.size() + 1 == level and upgrades.size() != 0 and evolution != null:
		return true
	return false
