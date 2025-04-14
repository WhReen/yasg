extends Sprite2D
 
var current_shake : float = 0
var shake_amount : float = 5
var shake_duration : float = 0.2
var health : float = 5:
	set(value):
		health = value
		if health < 0:
			drop_item()
var separation : float
@onready var player_reference = get_tree().current_scene.find_child("Player")
 
var drop_node = preload("res://scenes/pickups.tscn")
@export var drops : Array[Pickups]
var myposition = global_position
 
 
func _physics_process(delta):
 
	separation = (player_reference.position - position).length()
	if separation < player_reference.nearest_enemy_distance:
		player_reference.nearest_enemy = self
	
	
	if current_shake > 0:
		current_shake -= shake_amount * delta / shake_duration
		global_position = Vector2(randf_range(global_position.x-current_shake, global_position.x+current_shake), randf_range(global_position.y-current_shake, global_position.y+current_shake))
	if current_shake < 0:
		current_shake = 0
 
 
func take_damage(amount = 1):
	health -= 1
	current_shake = shake_amount
 
 
func drop_item():
	var item = drops.pick_random()
	var weights = []
 
	for pickup in drops:
		if pickup is Gold:
			weights.append(pickup.weight)
		else:
			weights.append(pickup.weight * player_reference.luck)
 
 
	var chance = randf()
	for i in range(drops.size()):
		if chance < get_weighted_chance(weights, i):
			item = drops[i]
			break
 
	var item_to_drop = drop_node.instantiate()
 
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
 
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
	queue_free()
	
func get_weighted_chance(weight, index):
	var sum = 0
	for i in range(weight.size()):
		sum += weight[i]
 
	var cumulative = 0
	for i in range(index + 1):
		cumulative += weight[i]
 
	return float(cumulative)/sum
