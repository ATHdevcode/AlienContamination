extends CharacterBody3D


const SPEED = 4.0

@onready var player = get_parent().get_node("player")

var ishttingawall = false

func _physics_process(delta: float) -> void:
	look_at(player.position)
	
	if not ishttingawall:
		position.x = move_toward(position.x, player.position.x, SPEED*delta)
		position.z = move_toward(position.z, player.position.z, SPEED*delta)
		position.y = move_toward(position.y, player.position.y+3, SPEED*delta)
	else:
		
		position.y += SPEED * delta
	
	
	
	if $RayCast3D.is_colliding():
		if $RayCast3D.get_collider().is_in_group("wall"):
			ishttingawall = true
	else:
		ishttingawall = false
			
		#print($RayCast3D.get_collider().get_groups())
	
	move_and_slide()
