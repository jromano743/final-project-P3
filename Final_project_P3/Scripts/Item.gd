extends Area2D

signal item_collected

#Conecta la señal del item con la del game manager
func _ready():
	var current_level = get_tree().get_current_scene().get_name()
	var node_game_manager = get_node("/root/"+str(current_level)+"/GameManager")
	connect("item_collected", node_game_manager, "_on_Item_item_collected")

#Envia la señal cuando la pelota atraviesa el item
func _on_Area2D_body_entered(body):
	if body.get_parent().is_in_group("Player"):
		emit_signal("item_collected")
		queue_free()
