# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D

var lockonenabled = 1

const BULLET = preload("res://bullet.tscn")
const GOBLER = preload("res://gobler.tscn")

var getmouse:Vector2;

var maxbullets = 6;
var bullets = maxbullets;
var reloadtime = 1.3;

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = false

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 7.0
## Speed of jump.
@export var jump_velocity : float = 6.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "ui_left"
## Name of Input Action to move Right.
@export var input_right : String = "ui_right"
## Name of Input Action to move Forward.
@export var input_forward : String = "ui_up"
## Name of Input Action to move Backward.
@export var input_back : String = "ui_down"
## Name of Input Action to Jump.
@export var input_jump : String = "ui_accept"
## Name of Input Action to Sprint.
@export var input_sprint : String = "sprint"
## Name of Input Action to toggle freefly mode.
@export var input_freefly : String = "freefly"

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false

## IMPORTANT REFERENCES
@onready var head: Node3D = $SpringArm3D/Head
@onready var collider: CollisionShape3D = $Collider
@onready var camera = $SpringArm3D/Head/Camera3D



var ishitground = false

var playerhealth = 100;

var nexLevelUpPoints = 5;

var level = 0;

var levelPoints = 0

var reward = level;

var camerasensetivity = 6;

var inzone = false



func _ready() -> void:
	#camera = $Head2/Camera3D2
	#head = $Head2
	$CanvasLayer/VFlowContainer/Label2.text = str(bullets)+"/"+str(maxbullets);
	
	$reload.wait_time = reloadtime
	
	$CanvasLayer/ProgressBar.max_value = playerhealth;
	$CanvasLayer/ProgressBar2.max_value = playerhealth;
	
	
	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x




func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		#manual aim
		
		
		# auto aim
		if DisplayServer.is_touchscreen_available() and lockonenabled == 1:
			var distancese = []
			for i in get_parent().get_children():
				if i.is_in_group("kroto"):
					distancese.append(position.distance_to(i.position))
			distancese.sort()
			for i in get_parent().get_children():
				if i.is_in_group("kroto"):
					if position.distance_to(i.position) == distancese[0]:
						$hole.look_at(i.position)
		else:
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * 10
			getmouse = event.position
		
			$hole.look_at(to)
		
		
		var val:int = $hole.rotation.x
		
		if val < 0:
			ishitground = true;

		else:
			ishitground = false;
			
		
		
var firstperson = -1

signal respawnboss

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if not DisplayServer.is_touchscreen_available() and event is InputEventMouseMotion:
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	if Input.is_action_just_pressed("tog"):
		firstperson *= -1
		if firstperson == 1:
			camera = $Head2/Camera3D2
			head = $Head2
			
			camera.current = true
			$SpringArm3D/Head/Camera3D.current = false
		else:
			camera = $SpringArm3D/Head/Camera3D
			head = $SpringArm3D/Head
			
			camera.current = true
			$Head2/Camera3D2.current = false
			
		
	
		

	

	
	
	if mouse_captured and event is InputEventMouseMotion and (OS.get_name() == "Linux" or OS.get_model_name() == "GenericDevice"):
		
		
		
		rotate_look(event.relative)
	rotate_look($"CanvasLayer/Virtual Joystick".output)
	

	
	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _physics_process(delta: float) -> void:
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return
	
	rotate_look($"CanvasLayer/Virtual Joystick2".output*Vector2(camerasensetivity,camerasensetivity))
		


	if Input.is_action_just_pressed("shoot") and ((getmouse.y < 384) or (getmouse.y > 384 and getmouse.x >340 and getmouse.x <  940)):
		
		if ishitground and bullets > 0:
			velocity.y = jump_velocity
		if $coolof.is_stopped():
			$coolof.start();
			
	
		
	$shiled.visible = shieldup
	

	if playerhealth <= 0:
		if Global.gamemode == Global.modes.BABY and get_parent().current_boss != null:
			
			get_parent().current_boss.queue_free()
			playerhealth = 100
			position = Vector3(-19,76,31)
			emit_signal("respawnboss")
		else:
			if Global.instantplay:
				Global.togglescreen()
				get_tree().reload_current_scene()
			else:
				release_mouse()
				$death.show()
			
				if $Collider != null:
					$SpringArm3D/Head/Camera3D.current = false
					$death/Camera3D.global_position = $SpringArm3D/Head/Camera3D.global_position
					$death/Camera3D.global_rotation = $SpringArm3D/Head/Camera3D.global_rotation
					$death/Camera3D.current = true
					$death/Camera3D.reparent(get_parent())
					$Collider.queue_free()
		#get_tree().paused = true
		#get_tree().change_scene_to_file("res://main.tscn");
	
	# Apply gravity to velocity
	
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Apply jumping
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	# Modify speed based on sprinting
	if can_sprint and Input.is_action_pressed(input_sprint):
			move_speed = sprint_speed
	elif not inzone:
		move_speed = base_speed
	else:
		move_speed = 2.0

	# Apply desired movement to velocity
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if move_dir:
			$Char/AnimationPlayer.play("walking")
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.y = 0
	
	# Use velocity to actually move
	move_and_slide()


## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(rot_input : Vector2):
	
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	
	
	#rotate_y($SpringArm3D.rotation.y)
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)


func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


## Checks if some Input Actions haven't been created.
## Disables functionality accordingly.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false


func _on_coolof_timeout() -> void:
	
	if bullets > 0:
		var inst = BULLET.instantiate();
		inst.global_position = $hole.global_position
		inst.rotation = $hole.global_rotation
		get_parent().add_child(inst);
		bullets -= 1
		$CanvasLayer/VFlowContainer/Label2.text = str(bullets)+"/"+str(maxbullets);
		$hole/AnimationPlayer.play("shoot")
		$AudioStreamPlayer3D.play()
	else:
		$CanvasLayer/VFlowContainer/Label2.text = "Reloading..";
		if $reload.is_stopped():
			$reload.start()
	
	
	
	



var damage = 10


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("hurt")
	playerhealth -= damage;



var cooldownself = false
var shieldup:bool = false
var impulse = false
var loles = false



signal rewardon;


func _on_hitarea_area_entered(area: Area3D) -> void:
	
	if not cooldownself and not shieldup:
		if area.is_in_group("hurt"):
			damage = 10
			
			$hitarea/kill.start();
		if area.is_in_group("out"):
			damage = 50
			$hitarea/kill.start();
		if area.is_in_group("ex"):
			
			damage = 40
			$hitarea/kill.start();
		if area.is_in_group("shell"):
			$AnimationPlayer.play("hurt")
			playerhealth -= 10
	if area.is_in_group("aster"):
		$AnimationPlayer.play("hurt")
		damage = 100/position.distance_to(area.position)
		playerhealth -= damage
	if area.is_in_group("extra"):
		$AnimationPlayer.play("hurt")
		damage = 1500/(position.distance_to(area.position)/2)
		playerhealth -= damage
	if area.is_in_group("slow"):
		inzone = true
			
		 
	if playerhealth < 90 and loles:
		if randi_range(1, 10 ) == 1:
			var inst = GOBLER.instantiate()
			inst.position = position
			inst.position.x += 10
			inst.position.z += 8
			
			get_parent().add_child(inst)
	if playerhealth < 39 and  impulse:
		var tween = create_tween()
		tween.parallel().tween_property($impulse/CSGCylinder3D, "radius", 12, 0.8).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property($impulse/CollisionShape3D.shape, "radius", 12, 0.8).set_trans(Tween.TRANS_SINE)
		$impulse/retact.start()
		
	#if area.is_in_group("volt"):
	#	levelPoints += 1;
	#	if levelPoints >= nexLevelUpPoints:
	#		level += 1
	#		rewardon.emit()
	#		reward += 1
	#		nexLevelUpPoints *= 2
	#		levelPoints = 0
	#	area.queue_free()


func _on_hitarea_area_exited(area: Area3D) -> void:
	if area.is_in_group("hurt"):
		$Mesh.material_overlay.albedo_color= Color.TRANSPARENT
		$hitarea/kill.stop();
	if area.is_in_group("out"):
		$hitarea/kill.stop();
	if area.is_in_group("ex"):
		print("got hit")
		playerhealth -= 30
		$hitarea/kill.stop();
	if area.is_in_group("slow"):
			inzone = false
	
	
	


func _on_reload_timeout() -> void:
	bullets = maxbullets
	$CanvasLayer/VFlowContainer/Label2.text = str(bullets)+"/"+str(maxbullets);
	
	

func _on_touch_screen_button_pressed() -> void:
	lockonenabled *= -1


signal levelupp;

func _on_hitarea_body_entered(body: Node3D) -> void:
	if body.is_in_group("volt"):
		levelPoints += 1;
		if levelPoints >= nexLevelUpPoints:
			level += 1
			levelupp.emit()
			rewardon.emit()
			reward += 1
			nexLevelUpPoints *= 2
			levelPoints = 0
		body.queue_free()


func _on_hitarea_2_area_entered(area: Area3D) -> void:
	if area.is_in_group("bolt"):
			playerhealth-= 25
			area.queue_free()


func _on_shiled_body_entered(body: Node3D) -> void:
	if body.is_in_group("kroto") and shieldup:
		$shiled/backup.start()
		shieldup = false


func _on_backup_timeout() -> void:
	shieldup = true


func _on_retact_timeout() -> void:
	var tween = create_tween()
	tween.parallel().tween_property($impulse/CSGCylinder3D, "radius", 0.2, 1).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property($impulse/CollisionShape3D.shape, "radius", 0.2, 1).set_trans(Tween.TRANS_SINE)
	impulse = false
