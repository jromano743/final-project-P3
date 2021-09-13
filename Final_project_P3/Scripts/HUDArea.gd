extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hud

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_level = get_tree().get_current_scene().get_name()
	hud = get_node("/root/"+str(current_level)+"/HUD")




func _on_HUDArea_body_entered(body):
	if body.get_parent().is_in_group("Player"):
		hud.modulate = Color(1,1,1,0.1)


func _on_HUDArea_body_exited(body):
	if body.get_parent().is_in_group("Player"):
		hud.modulate = Color(1,1,1,1)
