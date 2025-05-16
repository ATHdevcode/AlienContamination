extends CharacterBody3D

const HELLET = preload("res://hellet.tscn")

const LASER = preload("res://laser.tscn")

var health = 200

const maxhealth = 200

signal dead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	var cameraref = get_parent().get_node("player").get_node("SpringArm3D").get_node("Head").get_node("Camera3D")

	
	$CanvasLayer/ProgressBar.position = cameraref.unproject_position($ui.global_position)
	if position.distance_to(get_parent().get_node("player").position) > 35:
		$CanvasLayer/ProgressBar.hide()
	else:
		$CanvasLayer/ProgressBar.show()
	
	$CanvasLayer/ProgressBar.value = health
	


func _on_bullet_timeout() -> void:
	for i in $CSGCylinder3D/bullethole.get_children():
		var inst1 = HELLET.instantiate();
		inst1.global_position = i.global_position
		inst1.rotation = i.rotation
		
		get_parent().add_child(inst1);


func _on_turn_timeout() -> void:
	var tween = get_tree().create_tween();
	tween.tween_property($CSGCylinder3D, "rotation",$CSGCylinder3D.rotation+Vector3(0,10,0) , 1)


func _on_supper_timeout() -> void:
	$supper.wait_time += 1
	look_at(get_parent().get_node("player").position)
	$laserpointer.look_at(get_parent().get_node("player").position)
	await get_tree().create_timer(0.2).timeout
	
	var inst1 = LASER.instantiate();
	inst1.position = $laserpointer.position
	inst1.look_at(get_parent().get_node("player").global_position)
		
	add_child(inst1);
	
	$supper/Timer.start()
	
	await get_tree().create_timer(0.3).timeout
	var tween = get_tree().create_tween();
	tween.tween_property(self, "rotation",$CSGCylinder3D.rotation+Vector3(0,10,0) , 5)


	


func _on_timer_timeout() -> void:
	$supper.start()
	rotation.x = 0
	rotation.z = 0


func _on_hitter_area_entered(area: Area3D) -> void:
	if area.is_in_group("kill"):
		health -= 2
		if health <= 0:
			dead.emit()
			$AnimationPlayer.play("dead");
			$bullet.stop()
			$supper.stop()
			$turn.stop()
			$remove.start();
		


func _on_hitter_2_area_entered(area: Area3D) -> void:
	if area.is_in_group("kill"):
		health -= 8
		if health <= 0:
			$AnimationPlayer.play("dead");
			$bullet.stop()
			$supper.stop()
			$turn.stop()
			$remove.start();


func _on_remove_timeout() -> void:
	queue_free()


func _on_start_body_entered(body: Node3D) -> void:
	print("name:")
	print(body.name)
	if body.name == "player":
		$bullet.start()
		$turn.start()
		$supper.start()
		$start.queue_free()


func _on_start_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		$bullet.start()
		$turn.start()
		$supper.start()
		$start.queue_free()
