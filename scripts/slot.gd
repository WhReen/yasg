extends PanelContainer

@export var item : Weapon:
	set(value):
		if item != null and item.has_method("reset"):
			item.reset()
			
		item = value
		$MarginContainer/TextureRect.texture = value.icon
		$Cooldown.wait_time = value.cooldown
		item.slot = self
		
func _physics_process(delta: float) -> void:
	if item != null and item.has_method("update"):
		item.update(delta)

func _on_cooldown_timeout() -> void:
	if item:
		$Cooldown.wait_time = item.cooldown
		item.activate(owner, owner.nearest_enemy, get_tree()) #owner should be Player
