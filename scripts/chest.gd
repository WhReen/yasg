extends NinePatchRect
 
@onready var rewards = $Rewards
@onready var options = %Options
var reward_set = false

func _ready():
	randomize()
	hide()
	$Close.hide()
	
func open():
	$"../Darken".show()
	show()
	get_tree().paused = true
	var chesttween = create_tween()
	chesttween.set_speed_scale(1)
	chesttween.tween_property($Box, "rotation_degrees", 30, 0.05)
	chesttween.chain().tween_property($Box, "rotation_degrees", -30, 0.1)
	chesttween.chain().tween_property($Box, "rotation_degrees", 0, 0.1)
	chesttween.chain().tween_property($Box, "rotation_degrees", 30, 0.05).set_delay(0.2)
	chesttween.chain().tween_property($Box, "rotation_degrees", -30, 0.1)
	chesttween.chain().tween_property($Box, "rotation_degrees", 0, 0.1)
	chesttween.chain().tween_property($Explosion, "scale", Vector2(2.306,2.111), 0.1).set_delay(0.2)
	await chesttween.finished
	chesttween.kill()
	set_reward()
	$Close.show()
	
func set_reward():
	clear_reward()
	var chance = randf()
	var weight = [5.0,2.0,1.0]
	if chance < get_weighted_chance(weight, 0):
		upgrade_items(2,3)
	elif chance < get_weighted_chance(weight, 1):
		upgrade_items(1,4)
	else:
		upgrade_items(0,5)
		
func clear_reward():
	reward_set = false
	for slot in rewards.get_children():
		slot.get_child(0).texture = null
		slot.hide()
		
func upgrade_items(start, end):
	for index in range(start,end):
		var upgrades = options.get_available_upgrades()
		
		if upgrades.size() == 0:
			add_gold(index)
		else:
			var selected_upgrade : Item
			selected_upgrade = upgrades.pick_random()
 
			if selected_upgrade is Weapon and selected_upgrade.max_level_reached():
				rewards.get_child(index).get_child(0).texture = selected_upgrade.evolution.icon
			else:
				rewards.get_child(index).get_child(0).texture = selected_upgrade.icon
 
			selected_upgrade.upgrade_item()

func _on_close_pressed() -> void:
	$Explosion.set_scale(Vector2(0.01,0.01))
	$"../Darken".hide()
	hide()
	$Close.hide()
	clear_reward()
	get_tree().paused = false
	
func add_gold(index):
	var gold : Gold = load("res://resources/pickup/Gold.tres")
	gold.player_reference = owner
	rewards.get_child(index).get_child(0).texture = gold.icon
	rewards.get_child(index).show()
	gold.activate()
	
func get_weighted_chance(weight, index):
	var modified_weight = []
	var sum = 0
	for i in range(weight.size()):
		if i == 0:
			modified_weight.append(weight[i])
			sum += weight[i]
		else:
			modified_weight.append(weight[i] * owner.luck)
			sum += weight[i] * owner.luck
 
	var cumulative = 0
	for i in range(index + 1):
		cumulative += modified_weight[i]
 
	return float(cumulative)/sum
