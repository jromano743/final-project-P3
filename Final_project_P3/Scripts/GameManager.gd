extends Node


# Declare member variables here. Examples:
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
var next_level

#Persistens data
var current_Time

#File data
var score

#Flag
var change_level

signal win_game

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_level()

func setup_level():
	current_level = get_tree().get_current_scene().get_name()
	next_level = int(current_level[5]) + 1
	
	#Flags
	change_level = false
	
	#Toma la pelota
	ball = get_parent().get_node("Ball")
	
	#Toma todos los nodos con los que la pelota debe chocar
	red_walls = get_parent().get_node("Red_Wall")
	red_walls.modulate = Color(255,0,0,1)
	
	blue_walls = get_parent().get_node("Blue_Wall")
	blue_walls.modulate = Color(0,0,255,1)
	
	yellow_walls = get_parent().get_node("Yellow_Wall")
	yellow_walls.modulate = Color(255,255,0,1)
	
	#Configuracion inicial del nivel
	disableWalls()
	activeWall(red_walls)
	red_walls.modulate = Color(255,0,0,1)
	
	#Load data
	if(int(current_level[5]) > 1):
		loadData()
		get_node("/root/"+str(current_level)+"/Label").set_time(current_Time)

func loadData() -> bool:
	var save_data = File.new()
	if not save_data.file_exists("user://game_save/levels/data.save"):
		print("Archivo de guardado no encontrado")
		return false#11:15
	
	save_data.open("user://game_save/levels/data.save", File.READ)
	
	while(save_data.get_position() < save_data.get_len()):
		var node_data = parse_json(save_data.get_line())
		
		current_Time = node_data["time"]
		lives = node_data["lives"]
		
		print(current_Time, lives)
	
	save_data.close()
	print(current_level+": JUEGO CARGADO")
	return true

func saveData() -> void:
	var file = File.new()#Almacena la informacion
	var directory: Directory = Directory.new()#indica donde se guardara la informacion
	
	directory.make_dir_recursive("user://game_save/levels/")#Creamos la ruta de guardado
	file.open("user://game_save/levels/data.save", File.WRITE)#Abrimos el archivo
	
	#var save_nodes = get_tree().get_nodes_in_group("Save") #Nodos que perteneces al grupo Save
	#var scenes_data = {}   #Diccionario con la info de la escena
	
	var scene_data = save()
	file.store_line(to_json(scene_data))
	
	print(current_level+": JUEGO GUARDADO")
	
	file.close()

func save():
	var save_dic: Dictionary = {
		"filename": filename,
		"time": current_Time,
		"lives": lives
	}
	
	return save_dic

func _input(event):
	if event.is_action_pressed("red_button"):
		activeWall(red_walls)
		red_walls.modulate = Color(255,0,0,1)
	
	if event.is_action_pressed("blue_button"):
		activeWall(blue_walls)
		blue_walls.modulate = Color(0,0,255,1)
	
	if event.is_action_pressed("yellow_button"):
		activeWall(yellow_walls)
		yellow_walls.modulate = Color(255,255,0,1)
	
	if event.is_action_pressed("ui_cancel"):
		change_level = true
		get_tree().change_scene("res://Scenes/MainMenu.tscn")

func disableWalls():
	blue_walls.modulate = Color(0,0,255,0.1)
	red_walls.modulate = Color(255,0,0,0.1)
	yellow_walls.modulate = Color(255,255,0,0.1)
	
	changeLayerMask(blue_walls, 2)
	changeLayerMask(red_walls, 2)
	changeLayerMask(yellow_walls, 2)

func activeWall(wall):
	disableWalls()
	changeLayerMask(wall, 1)
	wall.visible = true

func changeLayerMask(wall, mask):
	var nodes = wall.get_children()
	for i in nodes:
		var sub_nodes = i.get_children()
		for j in sub_nodes:
			j.set_collision_mask(mask)

func _on_Item_item_collected():
	items = items -1
	var items_left = "Señal recibida - Items faltantes: " + String(items)
	#print(items_left)
	if(items <= 0):
		emit_signal("win_game")

#Programar el cambio de escena del juego
func _on_WinGate_end_level():
	change_level = true
	if(next_level <= 3):
		current_Time = get_node("/root/"+str(current_level)+"/Label").get_time()
		saveData()
		get_tree().change_scene("res://Scenes/Level"+str(next_level)+".tscn")
		print(current_Time)
	print("Juego terminado")

func set_Final_Time(time):
	current_Time = time
	var secs = fmod(current_Time, 60)
	var mins = fmod(current_Time, 60*60) / 60
	
	var time_passed = "%02d : %02d" % [mins, secs]
	current_Time = time
	
	print(current_Time)

func _on_GameZone_body_exited(body):
	if(not change_level):
		body.linear_velocity = Vector2.ZERO
		body.resetPosition()
	print("Un objeto salio del area")
