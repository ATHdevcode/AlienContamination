extends CharacterBody3D


var tracker = []

const BULLET = preload("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#$gun.look_at($"../player".position)
	
	print(tracker.size())
	if tracker.size() > 0:
		
		
		if $coolof.is_stopped():
			$coolof.start()
		print(tracker)
		if get_parent().is_ancestor_of(tracker[0]):
			$gun.look_at(tracker[0].position)
			
		for i in tracker:
			if i.life < 1:
				tracker.erase(i)
		
	else:
		
		$coolof.stop()
	
	


func _on_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("kroto"):
		$gun.material_overlay.albedo_color = "41aae6"
		tracker.append(body)
		$gun.look_at(body.position)


func _on_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("kroto"):
		# noticable performance cost worth to note
		tracker.erase(body)
		
		$gun.material_overlay.albedo_color = Color.TRANSPARENT
		


func _on_coolof_timeout() -> void:
	
	var inst1 = BULLET.instantiate();
	inst1.global_position = $gun/Marker3D.global_position
	inst1.rotation = $gun.rotation
	
	get_parent().add_child(inst1)
