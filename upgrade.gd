extends Area3D

enum {
	Speedup,
	Bullletup,
	Healthup,
	Autokill,
	Loles,
	Volt,
	Impulse
}

var allupgardes = [Speedup,
	Bullletup,
	Healthup,
	Autokill,
	Impulse]
	
var autokillactive = false

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
			
	
	if autokillactive:
		for i in get_parent().get_children():
			if i.is_in_group("kroto"):
				i.autokillspawn = true
		


func _on_body_entered(body: Node3D) -> void:

	if body.name == "player" and body.reward > 0:
		if body.level >= 3:
			allupgardes.append(Volt)
			allupgardes.append(Loles)
		var clonedupdates = []
		#clonedupdates.assign(allupgardes)
		clonedupdates.append_array(allupgardes)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_parent().get_node("player").mouse_captured = false
		
		for i in $CanvasLayer/HBoxContainer.get_children():
			i.queue_free()
		
		for i in range(3):
			var index = randi_range(0, clonedupdates.size()-1)
			
			var button  = TextureButton.new()
			
			button.theme = load("res://tip.tres")
			
			
			#button.text = clonedupdates[index]
			
			if clonedupdates[index] == Speedup:
				button.tooltip_text = "SPEEDUP\n-----------\nSlightyl increases your speed"
				button.texture_normal = load("res://assets/card3.png")
				button.pressed.connect(_speedupbutton)
			elif clonedupdates[index] == Bullletup:
				button.tooltip_text = "BULLETUP\n-----------\nIncreases your total bullet capacity"
				button.texture_normal = load("res://assets/card2.png")
				button.pressed.connect(_bulletup)
			elif clonedupdates[index] == Healthup:
				button.tooltip_text = "HEALTH HEAL\n-----------\nFully Restores your health"
				button.texture_normal = load("res://assets/card1.png")
				button.pressed.connect(_healthheal)
			elif clonedupdates[index] == Autokill:
				button.tooltip_text = "Autokill\n-----------\nFor each enemy you kill there is 10% chance to spawn a autokill"
				button.texture_normal = load("res://assets/card4.png")
				button.pressed.connect(_autokill)
			elif clonedupdates[index] == Loles:
				button.tooltip_text = "Loles\n-----------\nEach time you get hurt there is 40% chance that a Loles will spawn"
				button.texture_normal = load("res://assets/card6.png")
				button.pressed.connect(_loles)
			elif clonedupdates[index] == Volt:
				button.tooltip_text = "Volt Shiled\n-----------\nGet yourself a shiled around you"
				button.texture_normal = load("res://assets/card5.png")
				button.pressed.connect(_voltshiled)
			elif clonedupdates[index] == Impulse:
				button.tooltip_text = "Pulse of Pain\n-----------\nWhen you are really hurt, a Pulse kills all."
				button.texture_normal = load("res://assets/card7.png")
				button.pressed.connect(_impulse)
				
			clonedupdates.remove_at(index)
				
			$CanvasLayer/HBoxContainer.add_child(button)
		
		#clonedupdates.assign(allupgardes)
		clonedupdates.append_array(allupgardes)
		
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

func _autokill():
	autokillactive = true
	for i in get_parent().get_children():
		if i.is_in_group("kroto"):
			i.autokillspawn = true
	print("Autokill active")
	applayandcontinue(true)

func _loles():
	$"../player".loles = true
	applayandcontinue(true)

func _voltshiled():
	$"../player".shieldup = true
	applayandcontinue(true)

func _impulse():
	$"../player".impulse = true
	applayandcontinue(true)


func _on_player_rewardon() -> void:
	$SpotLight3D.show()
	$SpotLight3D/AnimationPlayer.play("spot")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$SpotLight3D.hide()
