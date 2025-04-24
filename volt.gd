extends CharacterBody3D


const GRAVITY = 2.0

var start = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not is_on_floor() and start:
		velocity.y += -GRAVITY
		
	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()


func _on_delay_timeout() -> void:
	start = true
