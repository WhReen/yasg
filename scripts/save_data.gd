extends Node2D
 
var gold = 0
var skill_tree = []
var max_time : Array = [0,0]

const PATH = "user://player_data.cfg"
@onready var config = ConfigFile.new()
 
func _ready():
	load_data()
 
func save_data():
	config.save(PATH)
  
func load_data():
	if config.load(PATH) != OK:
		set_and_save()

	gold = config.get_value("Player", "gold", 0)
	skill_tree = config.get_value("Player", "skill_tree", [])
	max_time = config.get_value("Player", "max_time", [0,0])
	
func reset_data():
	config = ConfigFile.new()
	gold = config.get_value("Player", "gold", 0)
	skill_tree = config.get_value("Player", "skill_tree", [])
	max_time = config.get_value("Player", "max_time", [0,0])
	set_and_save()

func set_data():
	config.set_value("Player", "gold", gold)
	config.set_value("Player", "skill_tree", skill_tree)
	config.set_value("Player", "max_time", max_time)
 
func set_and_save():
	set_data()
	save_data()
