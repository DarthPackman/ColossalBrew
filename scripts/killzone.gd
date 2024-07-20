extends Area2D

@onready var killzone = $"."
@onready var timer = $Timer
var dmg = 1
var restart = false


func _on_body_entered(body):
	restart = body.take_damage(dmg)
	if restart:
		Engine.time_scale = 0.5
		timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
