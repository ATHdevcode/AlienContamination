extends CanvasLayer




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$ColorRect.position = event.position
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$ColorRect.position.x = get_parent().get_node("hole").position.x
	$ProgressBar.value = get_parent().playerhealth
	var tween = get_tree().create_tween();
	tween.tween_property($ProgressBar2, "value", $ProgressBar.value, 1.5)
	$Label.text = "KILLS: "+str(Global.total_kills)
	#$ColorRect.position = get_parent().get_node("Head/Camera3D").unproject_position(get_parent().get_node("hole").global_position)
