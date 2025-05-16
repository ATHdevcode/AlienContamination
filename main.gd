extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$overlay/AnimationPlayer.play("RESET")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$kills.text = "KILLS: "+str(Global.total_kills)



func _on_button_pressed() -> void:
	$overlay.show()
	$overlay/AnimationPlayer.play("open")
	
	


func _on_delay_timeout() -> void:
	get_tree().change_scene_to_file("res://level.tscn")


func _on_button_2_pressed() -> void:

	Global.gamemode = Global.modes.NORM
	$overlay.hide()
	Global.timer.start()
	Global.togglescreen()
	$delay.start()


func _on_button_1_pressed() -> void:
	
	Global.gamemode = Global.modes.BABY
	$overlay.hide()
	Global.timer.start()
	Global.togglescreen()
	$delay.start()


func _on_e_pressed() -> void:
	$overlay/AnimationPlayer.play("RESET")
	$overlay.hide()


func _on_settings_pressed() -> void:
	Transition.transplay("res://settings.tscn")
	#get_tree().change_scene_to_file("res://settings.tscn")
