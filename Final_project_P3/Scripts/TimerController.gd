extends Label

var time = 0
var time_on = true
var current_level

func _ready():
	current_level = get_tree().get_current_scene().get_name()

func _process(delta):
	#Mientras el reloj funcione, lo actualiza
	if(time_on):
		time += delta;
	
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "Time: %02d : %02d" % [mins, secs]
	text = time_passed

#Enciende el reloj
func time_Start():
	time_on = true

#Apaga el reloj
func time_Stop():
	time_on = false

#Reinicia el reloj
func time_Reset():
	time = 0

#Devuelve el tiempo actual del reloj
func get_time():
	return time

#Establece el tiempo actual
func set_time(curren_time):
	time = curren_time
