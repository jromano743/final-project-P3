extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var all_items_collected = false
var is_finish: bool = false;
signal end_level

func _ready():
	var current_leve = get_tree().get_current_scene().get_name()
	
	var node_game_manager = get_node("/root/"+str(current_leve)+"/GameManager")
	var node_ball = get_node("/root/"+str(current_leve)+"/Ball")
	
	connect("end_level", node_game_manager, "_on_WinGate_end_level")
	connect("end_level", node_ball, "_on_WinGate_end_level")

func _on_Item_win_game():
	pass

func _on_GameManager_win_game():
	print("Win GATE: Señal recibida - Todos los items fueron recolectados")
	all_items_collected = true

func _on_WinGate_body_entered(body):
	if body.get_parent().is_in_group("Player"):
		#print("El player paso sobre mi")
		if(!is_finish and all_items_collected):
			print("Señal END LEVEL - Emitida")
			emit_signal("end_level")


func _on_GameManager_end_level():
	is_finish = true
