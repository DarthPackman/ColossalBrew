extends Node2D

const SPEED = 50
var direction = 1

@onready var animated_sprite = $AnimatedSprite2D

@onready var raycast_right = $"Raycast Right"
@onready var raycast_left = $"Raycast Left"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if raycast_right.is_colliding():
		animated_sprite.flip_h = true
		direction = -1
	if raycast_left.is_colliding():
		animated_sprite.flip_h = false
		direction = 1
	position.x += direction * SPEED * delta
