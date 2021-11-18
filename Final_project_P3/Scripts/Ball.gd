extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var init_position
var audio_manager
var sound_bounce = load("res://Sounds/bounce.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	init_position = self.global_transform
	pause_mode = Node.PAUSE_MODE_STOP
	
	#Nivel actual
	var current_level = get_tree().get_current_scene().get_name()
	
	#AudioManager
	audio_manager = get_node("/root/"+str(current_level)+"/AudioManager")


func resetPosition():
	global_transform.origin = init_position.get_origin()

func _on_Ball_body_entered(body):
	audio_manager.play_sfx(sound_bounce)
