extends Control

@onready var animation_player = $AnimationPlayer
var play = preload('res://scenes/lvl_turtle_1.tscn')

func _ready():
	animation_player.play("fade_in")

func _on_play_pressed():
	animation_player.play("fade_out")

func _on_credits_pressed():
	get_tree().change_scene_to_file('res://scenes/credits.tscn')


func _on_exit_pressed():
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "fade_out"):
		get_tree().change_scene_to_packed(play)
