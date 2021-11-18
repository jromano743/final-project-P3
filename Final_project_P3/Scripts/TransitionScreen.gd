extends CanvasLayer

signal finish_fade_out
signal finish_fade_in

var is_change_level: bool = false

func transition():
	fade(false);

func _ready():
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
	if is_change_level and anim_name == "fade_in":
		emit_signal("finish_fade_out")
		print("Señal emitida desde le transition")
