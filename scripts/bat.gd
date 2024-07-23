extends Node2D

const SPEED = 50
var direction = 1



@export var health = 10  # Initial health of the enemy
var is_dead = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast_right = $"Raycast Right"
@onready var raycast_left = $"Raycast Left"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if raycast_right.is_colliding() and not raycast_right.get_collision_mask_value(1):
		animated_sprite.flip_h = true
		direction = -1
	if raycast_left.is_colliding() and not raycast_right.get_collision_mask_value(1):
		animated_sprite.flip_h = false
		direction = 1
	position.x += direction * SPEED * delta
	
func take_damage(dmg):
	if is_dead:
		return

	health -= dmg
	print("Bat got hurt")
	

	if health <= 0:
		die()

func die():
	is_dead = true
	animated_sprite.play("Death")  # Play a death animation
	queue_free()  # Remove the enemy from the scene after the animation


func _on_hurtbox_area_entered(area):
	if area.is_in_group("Sword"):
		take_damage(5)
