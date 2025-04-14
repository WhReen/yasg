extends Button

var isPaused : bool = false
var music_volume = AudioServer.get_bus_effect(2,0)
@export var music_bgm : AudioStreamMP3

func _ready():
	visible = false
	$GameOver.hide()
	$Paused.hide()
	$NewRecord.hide()
	SoundManager.play_bgm(music_bgm)

func _on_pressed() -> void:
	get_tree().paused = false
	if owner.health <= 0:
		SaveData.gold += owner.gold
		SaveData.set_and_save()
	$GameOver.hide()
	$Paused.hide()
	music_volume.volume_db = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		menu()
	
func menu():
	if !get_tree().paused && !isPaused:
		get_tree().paused = true
		$Paused.show()
		$"../Darken".show()
		isPaused = true
		visible = true
		music_volume.volume_db = -10
	elif get_tree().paused && isPaused:
		$Paused.hide()
		$"../Darken".hide()
		music_volume.volume_db = 0
		isPaused = false
		visible = false
		get_tree().paused = false
