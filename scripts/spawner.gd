extends Node2D

@export var player : CharacterBody2D
@export var enemy : PackedScene
@export var destructible : PackedScene
@export var destructible_travel_distance : float = 1000

var distance : float = 800
var can_spawn : bool = true
var timeRecord : Array = [0,0]

@export var enemy_types : Array[Enemy]

var minute : int:
	set(value):
		minute = value
		%Minute.text = str(value)
		
var second : int:
	set(value):
		second = value
		if second >= 60:
			second -= 60
			minute += 1
		%Second.text = str(second).lpad(2, '0')
		
func _ready() -> void:
	if SaveData.max_time:
		timeRecord = SaveData.max_time
	else:
		SaveData.max_time = [0,0]
		SaveData.set_and_save()

func _physics_process(delta: float) -> void:
	if get_tree().get_node_count_in_group("Enemy") < 1000:
		can_spawn = true
	else:
		can_spawn = false
	
	if player.get_distance_traveled() >= 1000:
		spawn_destructible(get_random_position())
		player.set_distance_traveled(0)
	
	if ((minute*60)+second) > ((timeRecord[0]*60)+timeRecord[1]):
		timeRecord[0] = minute
		timeRecord[1] = second

func spawn(pos : Vector2, elite : bool = false):
	if not can_spawn and not elite:
		return
	
	var enemy_instance = enemy.instantiate()
	
	enemy_instance.type = enemy_types[min(minute, enemy_types.size()-1)]
	enemy_instance.position = pos
	enemy_instance.player_reference = player
	enemy_instance.elite = elite
	if minute > enemy_types.size():
		enemy_instance.health = enemy_instance.health * ceil(minute/enemy_types.size()) + minute
		enemy_instance.speed = enemy_instance.speed * ceil(minute/enemy_types.size()) + minute
		enemy_instance.damage = enemy_instance.damage * ceil(minute/enemy_types.size()) + minute
	
	get_tree().current_scene.add_child(enemy_instance)
	
func spawn_destructible(pos):
	
	var object_instance = destructible.instantiate()
	
	object_instance.position = pos
	get_tree().current_scene.add_child(object_instance)
	
func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
	
func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position())

func _on_timer_timeout() -> void:
	second += 1
	amount(second % 10)

func _on_pattern_timeout() -> void:
	for i in range(75):
		spawn(get_random_position())

func _on_elite_timeout() -> void:
	spawn(get_random_position(), true)
