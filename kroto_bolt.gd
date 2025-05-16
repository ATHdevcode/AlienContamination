extends CharacterBody3D


const BOLT = preload("res://bolt.tscn")
@onready var target = get_parent().get_node("player")

var health = 500

const maxhealth = 500

var uivisible = true

signal dead

func _ready() -> void:
	$zone/CollisionShape3D.shape.radius = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(target.position)
	
	var cameraref = get_parent().get_node("player").get_node("SpringArm3D").get_node("Head").get_node("Camera3D")

	
	$CanvasLayer/ProgressBar.position = cameraref.unproject_position($ui.global_position)
	if position.distance_to(get_parent().get_node("player").position) > 35:
		$CanvasLayer/ProgressBar.hide()
	elif uivisible:
		$CanvasLayer/ProgressBar.show()
	
	$CanvasLayer/ProgressBar.value = health


func _on_timer_timeout() -> void:
	var inst = BOLT.instantiate()
	
	inst.position = global_position
	inst.position.y = global_position.y + 3;
	inst.speed = randf_range(2.0, 4.0)
	
	get_parent().add_child(inst)
	




func _on_zonestart_timeout() -> void:
	var tween = create_tween()
	
	
	tween.parallel().tween_property($zone/CSGSphere3D, "radius", 26, 2).set_trans(Tween.TRANS_SINE)
	$zone/CollisionShape3D.shape.radius
	tween.parallel().tween_property($zone/CollisionShape3D.shape, "radius", 26, 2).set_trans(Tween.TRANS_SINE)
	
	$zoneend.start()

func _on_zoneend_timeout() -> void:
	var tween = create_tween()
	$zonestart.start()
	tween.parallel().tween_property($zone/CSGSphere3D, "radius", 0.5, 1).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property($zone/CollisionShape3D.shape, "radius", 0.5, 1).set_trans(Tween.TRANS_SINE)



func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	uivisible = true


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	uivisible = false




func _on_hitter_area_entered(area: Area3D) -> void:
	if area.is_in_group("kill"):
		health -= 10
		
		if health <= 0:
			$death.play("die")
			$Timer.stop()
			$zonestart.stop()
			$zoneend.stop()
			$hitter.queue_free()
			$CanvasLayer.hide()

func _on_death_animation_finished(anim_name: StringName) -> void:
	queue_free()
