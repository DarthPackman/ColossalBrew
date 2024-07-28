extends Control

@onready var main = $"../../../"
var menu = preload('res://scenes/menu.tscn')

func _on_resume_pressed():
	main.pauseMenu()

func _on_menu_pressed():
	get_tree().change_scene_to_packed(menu)

func _on_quit_pressed():
	get_tree().quit()
