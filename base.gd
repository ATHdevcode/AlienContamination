extends Node



func _ready() -> void:
	$CSGCylinder3D2/CPUParticles3D.speed_scale = 1.7
	$CSGCylinder3D2/Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_timer_timeout() -> void:
	var tween = get_tree().create_tween();
	tween.tween_property($CSGCylinder3D2/CPUParticles3D, "speed_scale", 1, 2.0)
