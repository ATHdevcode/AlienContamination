extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#for i in get_children():
		
		#if i.name != "player" and is_instance_of(i, Node3D) and i.name != "DirectionalLight3D":
		#	print(i.name)
		#	if i.position.distance_to($player.position) > 40:
		#		i.hide()
		#	else:
		#		i.show()
