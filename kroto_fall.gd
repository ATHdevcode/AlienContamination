extends CharacterBody3D



const ASTRIOD = preload("res://astriod.tscn")

const ASTRIOD_2 = preload("res://astriod_2.tscn")

const SPEED = 4.0;

var health = 650

const maxhealth = 650

var playerdam = 8

signal dead


func _ready() -> void:
	$AnimationPlayer.play("RESET")


func _process(delta: float) -> void:
	
	
	look_at(get_parent().get_node("player").position)
	#rotation.z = 0
	
	if position.distance_to(get_parent().get_node("player").position) < radius:
		
		position.x = move_toward(position.x, -get_parent().get_node("player").position.x, SPEED*delta)
		position.z = move_toward(position.z, -get_parent().get_node("player").position.z, SPEED*delta)
	
	if position.distance_to(get_parent().get_node("player").position) > radius+1:
		#look_at(get_parent().get_node("player").position)
		position.x = move_toward(position.x, get_parent().get_node("player").position.x, SPEED*delta)
		position.z = move_toward(position.z, get_parent().get_node("player").position.z, SPEED*delta)
		
	
	var cameraref = get_parent().get_node("player").get_node("SpringArm3D").get_node("Head").get_node("Camera3D")

	
	$CanvasLayer/ProgressBar.position = cameraref.unproject_position($ui.global_position)
	if position.distance_to(get_parent().get_node("player").position) > 35:
		$CanvasLayer/ProgressBar.hide()
	else:
		$CanvasLayer/ProgressBar.show()
	
	$CanvasLayer/ProgressBar.value = health

	
func _on_timer_timeout() -> void:
	var tween = create_tween();

	tween.tween_property($CSGCombiner3D, "position", Vector3(0,0.2,0), 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	
	tween.tween_property($CSGCombiner3D, "position", Vector3(0,-0.2,0), 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)


func _on_timer_2_timeout() -> void:
	var tween = create_tween();

	tween.tween_property($CSGCombiner3D, "rotation", $CSGCombiner3D.rotation+Vector3(0,0.5,0), 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	
	#tween.tween_property($CSGCombiner3D, "rotation", Vector3(0,-0.5,0), 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)

var angle = 0;
var radius = 12

func _on_fall_timeout() -> void:
	var point = Marker3D.new()
	if angle >= 360:
		angle = 0
	else:
		angle += 20
	
	point.position.z = global_position.z + radius*cos(angle)
	point.position.x = global_position.x + radius*sin(angle)
	point.position.y = global_position.y - 5
	
	var mesh = Sprite3D.new()
	mesh.texture = load("res://assets/pointer.png")
	point.add_child(mesh)
	
	var inst = ASTRIOD.instantiate()
	inst.position.y = global_position.y + 50
	inst.targert_location = point.position
	inst.target = point;
	
	get_parent().add_child(inst)
	
	get_parent().add_child(point)

var angle2 = 0

var asteriodamt = 1

func _on_fall_2_timeout() -> void:
	radius = randi_range(5, 14)
	asteriodamt = min(asteriodamt, 20)
	for i in range(asteriodamt):
		var point = Marker3D.new()
		
		angle2 = randi_range(0, 180)
		
		point.position.z = global_position.z + radius*cos(angle2)
		point.position.x = global_position.x + radius*sin(angle2)
		point.position.y = global_position.y - 5
		
		var mesh = Sprite3D.new()
		mesh.texture = load("res://assets/pointer.png")
		point.add_child(mesh)
		
		var inst = ASTRIOD.instantiate()
		inst.position.y = global_position.y + 50
		inst.targert_location = point.position
		inst.target = point;
		
		get_parent().add_child(inst)
		
		get_parent().add_child(point)
		



func _on_amt_timeout() -> void:
	asteriodamt += 1


func _on_hita_area_entered(area: Area3D) -> void:
	if area.is_in_group("kill"):
		health -= playerdam


func _on_supper_timeout() -> void:
	var point = Marker3D.new()
		
	
	
	point.position.z = global_position.z
	point.position.x = global_position.x
	point.position.y = global_position.y
	
	var mesh = Sprite3D.new()
	mesh.texture = load("res://assets/pointer.png")
	point.add_child(mesh)
	
	var inst = ASTRIOD_2.instantiate()
	inst.position.y = global_position.y + 80
	inst.targert_location = point.position
	inst.target = point;
	
	get_parent().add_child(inst)
	
	get_parent().add_child(point)
	
	playerdam = 15
	
	$weak.start()
	$AnimationPlayer.play("weak")


func _on_sup_timeout() -> void:
	$supper.start()


func _on_secfall_timeout() -> void:
	$fall2.start()


func _on_fall_3_timeout() -> void:
	var point = Marker3D.new()
	
	
	point.position.z =  get_parent().get_node("player").position.z
	point.position.x = get_parent().get_node("player").position.x
	point.position.y = global_position.y - 5
	
	var mesh = Sprite3D.new()
	mesh.texture = load("res://assets/pointer.png")
	point.add_child(mesh)
	
	var inst = ASTRIOD.instantiate()
	inst.position.y = global_position.y + 50
	inst.targert_location = point.position
	inst.target = point;
	
	get_parent().add_child(inst)
	
	get_parent().add_child(point)


func _on_thir_timeout() -> void:
	$fall3.start()


func _on_weak_timeout() -> void:
	$AnimationPlayer.stop()
	playerdam = 8
