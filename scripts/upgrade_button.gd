extends TextureButton
 
@export var skill : Skill

var enabled : bool = false:
	set(value):
		enabled = value
		$Panel.show_behind_parent = value
		if value:
			$Panel/ColorRect.show()
			$Line2D.default_color = Color(0.58,0.58,0.58,0.75)
func _ready():
	texture_normal = skill.texture
	$Label.hide()
	$Label.text = skill.name + " | Cost: " + str(skill.cost) + "\n\n" +  skill.stats.description
	
	if get_parent().name == "Self":
		is_self()
		return
	
	$Line2D.clear_points()
	if get_index() < get_parent().get_children().size() -1 :
			$Line2D.add_point(Vector2($Panel.size.x/2, $Panel.size.y/2))
			$Line2D.add_point(get_parent().get_child(get_index()+1).global_position - global_position + Vector2($Panel.size.x/2, $Panel.size.y/2))	

func _physics_process(_delta: float) -> void:
	if is_hovered():
		$Label.global_position = get_viewport().get_mouse_position()
		$Label.global_position += Vector2(-$Label.size.x,-$Label.size.y)
	if enabled:
		$Label.text = skill.name + " | Enabled" + "\n\n" +  skill.stats.description
 
func is_upgradable() -> bool:
	if get_index() == 0:
		return true
	elif get_index() > 0:
		if get_parent().get_child(get_index() - 1).enabled == true:
			return true
		else:
			return false
	return false
 
 
func _on_pressed():
	if skill.cost <= SaveData.gold and is_upgradable() and not enabled:
		SaveData.gold -= skill.cost
		SaveData.set_and_save()
		enabled = true
		get_parent().get_parent().set_skill_tree()
		get_parent().get_parent().get_total_stats()


func _on_panel_mouse_entered() -> void:
	$Label.show()
	

func _on_panel_mouse_exited() -> void:
	$Label.hide()
	
func is_self():
	enabled = true
	texture_normal = skill.texture
	$Label.hide()
	$Label.text = skill.name + " | Cost: " + str(skill.cost) + "\n\n" +  skill.stats.description
	
	$Panel/ColorRect.show()
	$Line2D.default_color = Color(0.58,0.58,0.58,0.75)
	
	$Line2D.clear_points()
	$Line2D.add_point(Vector2($Panel.size.x/2, $Panel.size.y/2))
	for eachup in get_parent().get_parent().get_children() :
		if eachup.name == get_parent().name:
			pass
		else:
			$Line2D.add_point(Vector2($Panel.size.x/2, $Panel.size.y/2))
			$Line2D.add_point(eachup.get_child(0).global_position - global_position + Vector2($Panel.size.x/2, $Panel.size.y/2))
