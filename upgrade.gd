extends Area3D



var allupgardes = ["speed", "bulletamt", "healthheal"]

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../player".reward > 0:
		for i in $Node.get_children():
			i.emitting = true;
	else:
		for i in $Node.get_children():
			i.emitting = false;
		


func _on_body_entered(body: Node3D) -> void:

	if body.name == "player" and body.reward > 0:
		var clonedupdates = []
		#clonedupdates.assign(allupgardes)
		clonedupdates.append_array(allupgardes)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_parent().get_node("player").mouse_captured = false
		
		for i in $CanvasLayer/HBoxContainer.get_children():
			i.queue_free()
		
		for i in range(3):
			var index = randi_range(0, clonedupdates.size()-1)
			
			var button  = Button.new()
			
			button.text = clonedupdates[index]
			
			if clonedupdates[index] == "speed":
				button.pressed.connect(_speedupbutton)
			elif clonedupdates[index] == "bulletamt":
				button.pressed.connect(_bulletup)
			elif clonedupdates[index] == "healthheal":
				button.pressed.connect(_healthheal)
				
			clonedupdates.remove_at(index)
				
			$CanvasLayer/HBoxContainer.add_child(button)
		
		#clonedupdates.assign(allupgardes)
		clonedupdates.append_array(allupgardes)
		print(clonedupdates)
		$CanvasLayer.show()
		body.reward -= 1;
		$Camera3D.current = true;
		get_tree().paused = true
		
func applayandcontinue(updarde):
	get_tree().paused = false
	$Camera3D.current = false
	$"../player/SpringArm3D/Head/Camera3D".current = true
	get_parent().get_node("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().get_node("player").mouse_captured = true
	$CanvasLayer.hide()
	
	if updarde:
		$killzone.position.y = 0;
		$"../player".cooldownself = true

	$Timer.start()


func _on_button_pressed() -> void:
	applayandcontinue(false)


func _on_timer_timeout() -> void:
	$killzone.position.y = 50;
	$"../player".cooldownself = false

func _speedupbutton():
	print("Speed is up++")
	$"../player".base_speed += 0.8
	applayandcontinue(true)

func _healthheal():
	print("Healed!")
	$"../player".playerhealth = 100;
	applayandcontinue(true)
	
func _bulletup():
	print("bullets++")
	$"../player".maxbullets += 2
	applayandcontinue(true)


func _on_player_rewardon() -> void:
	$SpotLight3D.show()
	$SpotLight3D/AnimationPlayer.play("spot")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$SpotLight3D.hide()
