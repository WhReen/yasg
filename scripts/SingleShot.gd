extends Weapon
class_name SingleShot
 
func shoot(source, target, scene_tree):
	if target == null or scene_tree.paused == true:
		return
		
	SoundManager.play_sfx(sound, pitchRandom)
	var projectile = projectile_node.instantiate()
 
	projectile.position = source.position
	projectile.damage = damage
	projectile.speed = speed
	projectile.source = source
	projectile.direction = (target.position - source.position).normalized()
	projectile.find_child("Sprite2D").texture = texture
 
	scene_tree.current_scene.add_child(projectile)
 
func activate(source, target, scene_tree):
	shoot(source, target, scene_tree)
	
func upgrade_item():
	if max_level_reached():
		slot.item = evolution
		return
	
	if not is_upgradable():
		return
		
	var upgrade = upgrades[level - 1]
	
	damage += upgrade.damage
	cooldown += upgrade.cooldown
	speed += upgrade.speed
	
	level += 1
