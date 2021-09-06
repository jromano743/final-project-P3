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

func _on_Area2D_body_exited(body):
	if(not change_level):
		body.linear_velocity = Vector2.ZERO
		body.resetPosition()
	print("Un objeto salio del area")

func _on_Item_item_collected():
	items = items -1
	var items_left = "Señal recibida - Items faltantes: " + String(items)
	print(items_left)
	if(items <= 0):
		emit_signal("win_game")

#Programar el cambio de escena del juego
func _on_WinGate_end_level():
	change_level = true
	if(next_level <= 3):
		get_tree().change_scene("res://Scenes/Level"+str(next_level)+".tscn")
	print("Juego terminado")

func set_Final_Time(time):
	current_Time = time
	var secs = fmod(current_Time, 60)
	var mins = fmod(current_Time, 60*60) / 60
	
	var time_passed = "%02d : %02d" % [mins, secs]
	current_Time = time
	
	print(current_Time)
