extends Node3D



const KROTO_ALPHA = preload("res://kroto_alpha.tscn")
const KrotoBolt = preload("res://kroto_bolt.tscn")
const KROTO_FALL = preload("res://kroto_fall.tscn")


var current_boss = null
var boss_data = null

func _ready() -> void:
	Global.togglescreen()
	print("Time taken = "+str(Global.timer.wait_time - Global.timer.time_left))
	

func _process(delta: float) -> void:
	
	pass
	
	#for i in get_children():
		
		#if i.name != "player" and is_instance_of(i, Node3D) and i.name != "DirectionalLight3D":
		#	print(i.name)
		#	if i.position.distance_to($player.position) > 40:
		#		i.hide()
		#	else:
		#		i.show()
	
func _backtonormal():
	current_boss = null
	$spawner.spawn = true
	$spawner2.spawn = true


func _on_player_levelupp() -> void:
	if $player.level == 3:
		$spawner.spawn = false
		$spawner2.spawn = false
		
		var inst = KROTO_ALPHA.instantiate()
		inst.position = $bossarea.position
		add_child(inst)
		inst.dead.connect(_backtonormal)
		
		$CanvasLayer/AnimationPlayer.play("blink")
		
		current_boss = inst
		boss_data = KROTO_ALPHA
	elif $player.level == 5:
		$spawner.spawn = false
		$spawner2.spawn = false
		
		var inst = KrotoBolt.instantiate()
		inst.position = $bossarea.position
		add_child(inst)
		inst.dead.connect(_backtonormal)
		
		$CanvasLayer/AnimationPlayer.play("blink")
		
		current_boss = inst
		boss_data = KrotoBolt
	elif $player.level == 8:
		$spawner.spawn = false
		$spawner2.spawn = false
		
		var inst = KROTO_FALL.instantiate()
		inst.position = $bossarea.position
		add_child(inst)
		inst.dead.connect(_backtonormal)
		
		$CanvasLayer/AnimationPlayer.play("blink")
		
		current_boss = inst
		boss_data = KROTO_FALL
	


func _on_player_respawnboss() -> void:
	$spawner.spawn = false
	$spawner2.spawn = false
	
	var inst = boss_data.instantiate()
	inst.position = $bossarea.position
	add_child(inst)
	inst.dead.connect(_backtonormal)
	
	$CanvasLayer/AnimationPlayer.play("blink")
	
	current_boss = inst
