extends Node

var music_menu = load("res://Sounds/menu_music.wav")
var audio_manager

func _ready():
	var current_level = get_tree().get_current_scene().get_name()
	audio_manager = get_node("/root/"+str(current_level)+"/AudioManager")
	
	audio_manager.play_music(music_menu)

#Botones del menu
func _on_Jugar_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")

func _on_Practica_pressed():
	get_tree().change_scene("res://Scenes/Level0.tscn")

func _on_Salir_pressed():
	get_tree().quit()
