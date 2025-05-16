extends CanvasLayer





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = not get_tree().paused
		visible = not visible


func _on_re_pressed() -> void:
	get_tree().paused = not get_tree().paused
	visible = not visible
