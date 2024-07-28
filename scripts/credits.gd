extends Control

@onready var animation_player = $AnimationPlayer

var menu = preload('res://scenes/menu.tscn')

func _ready():
	animation_player.play("fade_in")

func _on_back_pressed():
	animation_player.play("fade_out")
	
func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "fade_out"):
		get_tree().change_scene_to_packed(menu)
