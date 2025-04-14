extends Control

@export var menu_bgm : AudioStreamMP3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_bgm(menu_bgm)
	if SaveData.max_time:
		$"Menu/Time Record".text += str(SaveData.max_time[0]) + ":" + str(SaveData.max_time[1]).lpad(2, '0')
	else:
		$"Menu/Time Record".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_upgrades_pressed() -> void:
	$UpgradeWindow.show()
	$Menu.hide()
	
func _on_back_to_menu_pressed() -> void:
	$UpgradeWindow.hide()
	$Menu.show()


func _on_delete_pressed() -> void:
	$UpgradeWindow/Delete/ConfirmDelete.show()


func _on_confirm_delete_pressed() -> void:
	SaveData.reset_data()
	$UpgradeWindow/Delete/ConfirmDelete.hide()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
