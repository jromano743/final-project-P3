extends CanvasLayer

signal finish_fade_out
signal finish_fade_in

var is_change_level: bool = false
var current_name

func transition():
	fade(false);

func _ready():
	current_name = get_tree().get_current_scene().get_name()
	transition()

func fade(fade_in: bool):
	if fade_in:
		$AnimationPlayer.play("fade_in")
	else:
		$AnimationPlayer.play("fade_out")


func _on_GameManager_end_level():
	is_change_level = true
	fade(true)


func _on_AnimationPlayer_animation_finished(anim_name):
	#Transition End
	if is_change_level and anim_name == "fade_in":
		emit_signal("finish_fade_out")
		print("Señal emitida desde le transition")
	#Transition End and deleted
	if anim_name == "fade_out" and current_name == "GameWin" or current_name == "GameOver":
		print("Señal emitida desde le transition, escena liberada")
		queue_free()
