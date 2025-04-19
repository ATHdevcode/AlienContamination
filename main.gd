extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$kills.text = "KILLS: "+str(Global.total_kills)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.camerssenstivity = $HSlider.value


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")
