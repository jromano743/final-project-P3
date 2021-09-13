extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Botones del menu
func _on_Jugar_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")

func _on_Practica_pressed():
	get_tree().change_scene("res://Scenes/Level0.tscn")

func _on_Salir_pressed():
	get_tree().quit()
