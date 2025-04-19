extends CharacterBody3D

@export var SPEED = 3.0

@export var life = 2

var isfloat = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.totalenemy += 1

var follow = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta * isfloat
		
	
	look_at(get_parent().get_node("player").position)
	
	if follow:
		position.x = move_toward(position.x, get_parent().get_node("player").position.x, SPEED*delta)
		position.z = move_toward(position.z, get_parent().get_node("player").position.z, SPEED*delta)
		position.y = move_toward(position.y, get_parent().get_node("player").position.y+3, SPEED*delta)
		
		
	
	move_and_slide()
	


func _on_hit_area_entered(area: Area3D) -> void:

	if area.is_in_group("kill"):
		if life <= 0:
			$AnimationPlayer.play("boom")
			
			
		else:
			life -= 1
			$CPUParticles3D.global_position = area.global_position
			$CPUParticles3D.emitting = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	isfloat = 1
	$OmniLight3D.queue_free();
	$OmniLight3D2.queue_free();
	$hit.queue_free()
	$Timer.start();
	follow = false


func _on_timer_timeout() -> void:
	Global.totalenemy -= 1
	Global.total_kills += 1
	queue_free()
	
