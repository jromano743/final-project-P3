extends Area2D

signal item_collected
var sound_item_collected = load("res://Sounds/item.wav")
var audio_manager

#Conecta la señal del item con la del game manager
func _ready():
	#Nivel actual
	var current_level = get_tree().get_current_scene().get_name()
	
	#GameManager
	var node_game_manager = get_node("/root/"+str(current_level)+"/GameManager")
	
	#AudioManager
	audio_manager = get_node("/root/"+str(current_level)+"/AudioManager")
	
	#Señales
	connect("item_collected", node_game_manager, "_on_Item_item_collected")

#Envia la señal cuando la pelota atraviesa el item
func _on_Area2D_body_entered(body):
	if body.get_parent().is_in_group("Player"):
		emit_signal("item_collected")
		audio_manager.play_sfx(sound_item_collected)
		queue_free()
