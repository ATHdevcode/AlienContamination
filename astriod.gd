extends Area3D


var targert_location = null
var target;

const SPEED = 18.0

const FIRE = preload("res://fire.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if targert_location != null:
		look_at(targert_location)
	

		position.x = move_toward(position.x, targert_location.x, SPEED*delta)
		position.z = move_toward(position.z, targert_location.z, SPEED*delta)
		position.y = move_toward(position.y, targert_location.y, SPEED*delta)
		
		if (position.distance_to(targert_location) < 3):
			$CPUParticles3D3.emitting = true
			$CSGSphere3D.queue_free()
			if $Timer != null:
				$Timer.start()
			
			targert_location = null
			$AnimationPlayer.play("fade")
			$last.start()


func _on_last_timeout() -> void:
	if target != null:
		target.queue_free()
	queue_free()


func _on_timer_timeout() -> void:
	var inst = FIRE.instantiate()
	inst.position = global_position
	get_parent().add_child(inst)
	$CollisionShape3D.queue_free()
