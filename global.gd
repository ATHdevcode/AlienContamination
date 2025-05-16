extends Node2D


var totalenemy = 0;
var total_kills = 0;

enum modes {
	BABY, NORM
}

#settings
var camerssenstivity = 8;
var gamemode = modes.BABY;
var instantplay = false

var value;

@onready var timer = get_node("loadtime")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lerp
	pass # Replace with function body.



func _process(delta: float) -> void:
	$CanvasLayer/Label2.text = str(value)
	
func sfxtoggle(val:bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), val)

func musictoggle(val:bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), val)
	
func togglescreen():
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ProgressBar, "value", 300, 0.6)
	#$CanvasLayer/ProgressBar.value = lerp(0, 100, 0.5)
	$CanvasLayer.visible = not $CanvasLayer.visible
