extends Node2D





func _process(delta: float) -> void:
	pass
	if get_tree().paused:
		$AudioStreamPlayer.volume_db = -10
		$AudioStreamPlayer.pitch_scale = 0.5
	else:
		$AudioStreamPlayer.volume_db = 0
		$AudioStreamPlayer.pitch_scale = 1


func _enter_tree() -> void:
	get_tree().connect("node_added", _on_node_added)
	
func _on_node_added(node):
	if node.name == "Main":
		if not $AudioStreamPlayer.stream == load("res://sfx/Alien Contamination.mp3"):
			$AudioStreamPlayer.stream = load("res://sfx/Alien Contamination.mp3")
			$AudioStreamPlayer.play()
	elif node.name == "level":
		if not $AudioStreamPlayer.stream == load("res://sfx/The contaminated.wav"):
			$AudioStreamPlayer.stream = load("res://sfx/The contaminated.wav")
			$AudioStreamPlayer.play()
		
