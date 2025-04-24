extends Area3D


const speed = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_transform.origin -= transform.basis.z.normalized() * speed * delta



func _on_area_entered(area: Area3D) -> void:
	if area.name != "hitarea":
		$CPUParticles3D.emitting = true
		$free.start()


func _on_body_entered(body: Node3D) -> void:
	if body.name != "player":
		$CPUParticles3D.emitting = true
		$free.start()


func _on_free_timeout() -> void:
	
	queue_free()


func _on_full_timeout() -> void:
	$CPUParticles3D.emitting = true
	queue_free()
