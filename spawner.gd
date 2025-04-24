extends Marker3D


const KROTO = preload("res://kroto.tscn")

var max_spawn = -1;

func _ready() -> void:
	Global.totalenemy = 0;
	Global.total_kills = 0;

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	
	#max_spawn = max(floor((Global.total_kills) / 4), 2)
	if Global.totalenemy <= max_spawn:
		var inst = KROTO.instantiate();
		inst.position = position
		inst.life = randf_range(1.0, 4.0);
		inst.SPEED = randf_range(3.0, 6.0);
		get_parent().add_child(inst);
	
