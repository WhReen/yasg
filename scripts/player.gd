extends CharacterBody2D

@export var take_damage_sound = AudioStream
var health : float = 100:
	set(value):
		health = max(value, 0)
		if health >= max_health:
			health = max_health
		%Health.value = value
		if health <= 0:
			get_tree().paused = true
			%toMainMenu.show()
			$UI/Darken.show()
			%toMainMenu/GameOver.show()
			$UI/toMainMenu/NewRecord.text = "TIME RECORD: \n"+str(SaveData.max_time[0]) + ":" + str(SaveData.max_time[1]).lpad(2, '0')
			$UI/toMainMenu/NewRecord.show()

var movement_speed : float = 300 :
	set(value):
		movement_speed = value
		%SpeedSt.text = str(value)
var max_health : float = 100 :
	set(value):
		max_health = value
		%Health.max_value = value
var recovery : float = 0
var armor : float = 0
var might : float = 1.0 :
	set(value):
		might = value
		%MightSt.text = str(value)
var area : float = 0
var magnet : float  = 0:
	set(value):
		magnet = value
		%Magnet.shape.radius = 10 + value
var growth : float = 1 :
	set(value):
		growth = value
		%GrowthSt.text = str(value)
var luck : float = 1
var nearest_enemy
var nearest_enemy_distance : float = 150 + area
var gold : int = 0:
	set(value):
		gold = value
		%Gold/Label.text = str(value)
		

var level : int = 1:
	set(value):
		level = value
		%Level.text = "Lv." + str(value)
		%Options.show_options()
		if level >= 2:
			%XP.max_value += 10
		elif level >= 21:
			%XP.max_value += 13
		elif level >= 41:
			%XP.max_value += 16
var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
var total_XP : int = 0
var lastpos : Vector2 = self.global_position
var distance_traveled : float = 0

func _ready():
	Persistence.gain_bonus_stats(self)

func _physics_process(delta: float) -> void:
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation
	else:
		nearest_enemy_distance = 150 + area
		nearest_enemy = null

	velocity = Input.get_vector("left", "right", "up", "down") * movement_speed
	move_and_collide(velocity * delta)
	
	check_XP()
	health += recovery * delta

	distance_traveled += self.global_position.distance_to(lastpos)
	lastpos = self.global_position

func take_damage(amount):
	health -= max(amount * (amount / (amount + armor)), 0)
	SoundManager.play_sfx(take_damage_sound)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func check_XP():
	if XP >= %XP.max_value:
		XP -= %XP.max_value
		level += 1
 
func gain_XP(amount):
	XP += amount * growth
	total_XP += amount * growth

func _on_magnet_area_entered(pickable: Area2D) -> void:
	if pickable.has_method("follow"):
		pickable.follow(self)
		
func gain_gold(amount):
	gold += amount
	
func open_chest():
	$UI/Chest.open()
	
func get_distance_traveled() -> float:
	return distance_traveled
	
func set_distance_traveled(amount = 0):
	distance_traveled = amount
