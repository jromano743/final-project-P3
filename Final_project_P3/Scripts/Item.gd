extends Area2D

signal item_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_level = get_tree().get_current_scene().get_name()
	#print("Nivel del item: "+str(current_level))
	var node_game_manager = get_node("/root/"+str(current_level)+"/GameManager")
	connect("item_collected", node_game_manager, "_on_Item_item_collected")


func _on_Area2D_body_entered(body):
	if body.get_parent().is_in_group("Player"):
		#print("Señal del item enviada")
		emit_signal("item_collected")
		queue_free()
