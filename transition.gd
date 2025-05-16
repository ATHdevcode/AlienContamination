extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var sc = "res://settings.tscn";

	
func transplay(screen):
	sc = screen
	show()
	$AnimationPlayer.play("tr")
	
func changescene():
	get_tree().change_scene_to_file(sc)
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	hide()
