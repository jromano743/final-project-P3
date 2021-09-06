extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var init_position
var rb

# Called when the node enters the scene tree for the first time.
func _ready():
	init_position = self.global_transform
	var rb = get_node(".")


func resetPosition():
	#rb.linear_velocity = Vector2.ZERO
	global_transform.origin = init_position.get_origin()
