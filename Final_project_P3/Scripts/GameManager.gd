extends Node


# Declare member variables here. Examples:
#Audio manager
var audio_manager

#Walls
var blue_walls
var red_walls
var yellow_walls

#Player (ball)
var ball
var lives = 5

#Level Data
var items = 10
var current_level
var current_level_number
var next_level
var MAX_LEVELS = 3

#Persistens data
var current_Time

#File data
var score

#Flag
var change_level
var game_over: bool = false
var exit_game: bool = false

#Hud - Hud items
var hud
var hud_lives
var hud_circle
var hud_time
var hud_level

#Sonidos
var music_level = load("res://Sounds/music_level.wav")
var sound_lost = load("res://Sounds/lost.wav")
var sound_end_level = load("res://Sounds/end-level.wav")
var sound_all_items = load("res://Sounds/all-item.wav")
var music_menu = load("res://Sounds/menu_music.wav")

#Señales
signal win_game
signal end_level

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_tree().get_current_scene().get_name()
	current_level_number = int(current_level[5])
	
	#Audio manager
	audio_manager = get_node("/root/"+str(current_level)+"/AudioManager")
	
	if "evel" in current_level:
		setup_level()
	else:
		setup_end()

#Configuracion inicial del nivel
func setup_level():
	next_level = current_level_number + 1
	
	#Flags
	change_level = false
	
	#Toma la pelota
	ball = get_parent().get_node("Ball")
	
	#HUD
	hud = get_node("/root/"+current_level+"/HUD")
	hud_time = get_node("/root/"+current_level+"/HUD/Time")
	hud_lives = get_node("/root/"+current_level+"/HUD/Lives")
	hud_circle = get_node("/root/"+current_level+"/HUD/Circle")
	hud_level = get_node("/root/"+current_level+"/HUD/Level")
	
	#HUD Setup
	hud_level.text = "Level: " + str(current_level_number)
	hud_lives.text = "Lives: " + str(lives)
	
	#Toma todos los nodos con los que la pelota debe chocar
	red_walls = get_parent().get_node("Red_Wall")
	red_walls.modulate = Color(2,0,0,1)
	hud_circle.modulate = Color(2,0,0,1)
	
	blue_walls = get_parent().get_node("Blue_Wall")
	blue_walls.modulate = Color(0,0,2,1)
	
	yellow_walls = get_parent().get_node("Yellow_Wall")
	yellow_walls.modulate = Color(2,2,0,1)
	
	#Configuracion inicial del nivel
	disableWalls()
	activeWall(red_walls)
	red_walls.modulate = Color(2,0,0,1)
	
	audio_manager.play_music(music_level)
	
	if(current_level_number == 0):
		hud_level.text = "Practice Level"
		hud_lives.text = " "
	
	#Load data
	if(current_level_number > 1):
		loadData()
		hud_time.set_time(current_Time)
		hud_lives.text = "Lives: " + str(lives)

#Configuracion de pantalla final
func setup_end():
	loadData()
	var secs = fmod(current_Time, 60)
	var mins = fmod(current_Time, 60*60) / 60
	var time_passed = "%02d : %02d" % [mins, secs]
	
	get_node("/root/"+current_level+"/Score").text = "Time: " + str(time_passed)
	get_node("/root/"+current_level+"/Goal").text = "Lives: " + str(lives)
	
	audio_manager.play_music(music_menu)

#Carga de datos (si existen), para el nivel
func loadData() -> bool:
	var save_data = File.new()
	if not save_data.file_exists("user://game_save/levels/data.save"):
		print("Archivo de guardado no encontrado")
		return false
	
	save_data.open("user://game_save/levels/data.save", File.READ)
	
	while(save_data.get_position() < save_data.get_len()):
		var node_data = parse_json(save_data.get_line())
		
		current_Time = node_data["time"]
		lives = node_data["lives"]
		
		print(current_Time, lives)
	
	save_data.close()
	print(current_level+": JUEGO CARGADO")
	return true

#Guarda los datos del nivel
func saveData() -> void:
	var file = File.new()#Almacena la informacion
	var directory: Directory = Directory.new()#indica donde se guardara la informacion
	
	directory.make_dir_recursive("user://game_save/levels/")#Creamos la ruta de guardado
	file.open("user://game_save/levels/data.save", File.WRITE)#Abrimos el archivo
	
	#var save_nodes = get_tree().get_nodes_in_group("Save") #Nodos que perteneces al grupo Save
	#var scenes_data = {}   #Diccionario con la info de la escena
	
	var scene_data = make_data()
	file.store_line(to_json(scene_data))
	
	print(current_level+": JUEGO GUARDADO")
	
	file.close()

#Crea el diccionario para guardar los datos del nivel
func make_data():
	var save_dic: Dictionary = {
		"filename": filename,
		"time": current_Time,
		"lives": lives
	}
	
	return save_dic

#Eventos de entrada
func _input(event):
	if event.is_action_pressed("red_button"):
		activeWall(red_walls)
		red_walls.modulate = Color(2,0,0,1)
		hud_circle.modulate = Color(2,0,0,1)
	
	if event.is_action_pressed("blue_button"):
		activeWall(blue_walls)
		blue_walls.modulate = Color(0,0,2,1)
		hud_circle.modulate = Color(0,0,2,1)
	
	if event.is_action_pressed("yellow_button"):
		activeWall(yellow_walls)
		yellow_walls.modulate = Color(2,2,0,1)
		hud_circle.modulate = Color(2,2,0,1)
	
	if event.is_action_pressed("ui_cancel"):
		exit_game = true
		prepare_transition()

#Deshabilita los muros (color y colisiones)
func disableWalls():
	blue_walls.modulate = Color(0,0,255,0.1)
	red_walls.modulate = Color(255,0,0,0.1)
	yellow_walls.modulate = Color(255,255,0,0.1)
	
	changeLayerMask(blue_walls, 2)
	changeLayerMask(red_walls, 2)
	changeLayerMask(yellow_walls, 2)

#Habilitas los muros (color y colisiones)
func activeWall(wall):
	disableWalls()
	changeLayerMask(wall, 1)
	wall.visible = true

#Cambia el valor de la layermask
func changeLayerMask(wall, mask):
	var nodes = wall.get_children()
	for i in nodes:
		var sub_nodes = i.get_children()
		for j in sub_nodes:
			j.set_collision_mask(mask)

#Evento que se activa cuando un item es recolectado
func _on_Item_item_collected():
	items = items -1
	var items_left = "Señal recibida - Items faltantes: " + String(items)
	#print(items_left)
	if(items <= 0):
		emit_signal("win_game")

#Evento realiza el cambio de escena del juego (otorga una vida, guarda los datos y cambia el nivel)
func _on_WinGate_end_level():
	change_level = true
	lives += 1
	prepare_transition()

#Funcion que prepara los datos para la transicion a otra escena
func prepare_transition():
	if ball: 
		ball.queue_free()
	var name_scene = get_tree().get_current_scene().get_name()
	print(name_scene)
	if (not ("GameWin" in name_scene or "GameOver" in name_scene)):
		hud_time.time_Stop()
		current_Time = hud_time.get_time()
		saveData()
	emit_signal("end_level")
	print("Preparacion completa")

#Evento que establece el tiempo del game manager con el mismo del reloj (reloj->manager)
func set_Final_Time(time):
	current_Time = time
	var secs = fmod(current_Time, 60)
	var mins = fmod(current_Time, 60*60) / 60
	
	var time_passed = "%02d : %02d" % [mins, secs]
	current_Time = time
	
	print(current_Time)

#Evento que se activa cuando la pelota abandona el area 2D
func _on_GameZone_body_exited(body):
	if exit_game: return
	if(not change_level):
		if lives > 1:
			body.linear_velocity = Vector2.ZERO
			body.resetPosition()
			audio_manager.play_sfx(sound_lost)
			lives -= 1
			hud_lives.text = "Lives: " + str(lives)
		else:
			hud_time.time_Stop()
			body.queue_free()
			audio_manager.play_sfx(sound_end_level)
			lives -= 1
			hud_lives.text = "Lives: " + str(lives)
			game_over = true
			prepare_transition()
	print("Un objeto salio del area")

func change_Level():
	#ESC is Pressed
	print(exit_game)
	if(exit_game): 
		print("Pasa por el cambio al menu principal")
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		return
	
	#Change Level in Game
	if(not game_over and next_level <= MAX_LEVELS):
		get_tree().change_scene("res://Scenes/Level"+str(next_level)+".tscn")
	elif (not game_over and next_level > MAX_LEVELS):
		get_tree().change_scene("res://Scenes/GameWin.tscn")
	else:
		get_tree().change_scene("res://Scenes/GameOver.tscn")

func _on_TransitionScreen_finish_fade_out():
	print("Transicion Finalizada")
	change_Level()
