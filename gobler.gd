extends CharacterBody3D


var thefood:Node3D

var SPEED = 5.0

var ate = false

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#look_at(get_parent().get_node("player").position)
	if thefood != null and not ate:
		look_at(thefood.position)
		position.x = move_toward(position.x, thefood.position.x, SPEED*delta)
		position.z = move_toward(position.z, thefood.position.z, SPEED*delta)
		position.y = move_toward(position.y, thefood.position.y+3, SPEED*delta)
		


func _on_eat_body_entered(body: Node3D) -> void:
	if body.is_in_group("kroto"):
		thefood = body
		$eat.queue_free()


func _on_eat_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("kroto"):
		ate = true
		body.queue_free()
		Global.totalenemy -= 1
		$Timer.start()



func _on_timer_timeout() -> void:
	$CSGCombiner3D/AnimationPlayer.play("die")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
