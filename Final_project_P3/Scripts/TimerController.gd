extends Label

var time = 0
var time_on = true
var current_level

# Called when the node enters the scene tree for the first time.

func _ready():
		current_level = get_tree().get_current_scene().get_name()

func _process(delta):
	if(time_on):
		time += delta;
	
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "%02d : %02d" % [mins, secs]
	text = time_passed

func _on_Time_Start():
	time_on = true

func _on_Time_Stop():
	time_on = false

func _on_Time_Reset():
	time = 0


func _on_WinGate_end_level():
	_on_Time_Stop()
	var node_game_manager = get_node("/root/"+str(current_level)+"/GameManager").set_Final_Time(time)
