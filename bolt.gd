extends Area3D


@onready var target = get_parent().get_node("player")

var speed = 2.0

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var targert_location = target.position
	if active:
		position.x = move_toward(position.x, targert_location.x, speed*delta)
		position.z = move_toward(position.z, targert_location.z, speed*delta)
		position.y = move_toward(position.y, targert_location.y+1.8, speed*delta)
		


func _on_timer_timeout() -> void:
	queue_free()


func _on_activate_timeout() -> void:
	active = true





func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()
