extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Global.togglescreen()
	get_tree().paused = false
	get_tree().reload_current_scene();


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn");
