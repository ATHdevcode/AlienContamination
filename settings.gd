extends Node2D





func _on_sfx_toggled(toggled_on: bool) -> void:
	Global.sfxtoggle(not toggled_on);


func _on_prev_pressed() -> void:
	Transition.transplay("res://main.tscn")


func _on_music_toggled(toggled_on: bool) -> void:
	Global.musictoggle(not toggled_on)


func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.instantplay = toggled_on
