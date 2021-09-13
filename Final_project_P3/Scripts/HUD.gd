extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bar #Barra
var circle #Circulo
var lives #Vidas
var level #Level

# Called when the node enters the scene tree for the first time.
func _ready():
	bar = get_node("./Bar")
	circle = get_node("./Circle")
	lives = get_node("./Lives")
	level = get_node("./Level")
	
	
	print(bar)
	print(circle)
	print(lives)
	print(level.text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
