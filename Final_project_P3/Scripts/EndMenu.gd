extends Node

#Botones del menu
func _on_Retry_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")

func _on_Menu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
