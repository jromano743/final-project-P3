extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var init_position
var audio_manager
var sound_bounce = load("res://Sounds/bounce.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	init_position = self.global_transform
	#pause_mode = Node.PAUSE_MODE_STOP
	
	#Nivel actual
	var current_level = get_tree().get_current_scene().get_name()
	
	#AudioManager
	audio_manager = get_node("/root/"+str(current_level)+"/AudioManager")

func _physics_process(delta):
	#Velocity Control
	if abs(linear_velocity.x) > 1100:
		linear_velocity.x -= linear_velocity.x * 0.01
	if abs(linear_velocity.y) > 1100:
		linear_velocity.y -= linear_velocity.y * 0.01

func resetPosition():
	global_transform.origin = init_position.get_origin()

func _on_Ball_body_entered(body):
	audio_manager.play_sfx(sound_bounce)
