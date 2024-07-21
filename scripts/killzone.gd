extends Area2D

@onready var timer = $Timer
@export var dmg = 0
@export var insta_death = false
var restart = false


func _on_body_entered(body):
	if not insta_death:
		restart = body.take_damage(dmg)
		if restart:
			Engine.time_scale = 0.5
			timer.start()
	else:
		timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
