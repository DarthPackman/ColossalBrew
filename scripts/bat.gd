extends Node2D

const SPEED = 50
var direction = 1



@export var health = 10  # Initial health of the enemy
var is_dead = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast_right = $"Raycast Right"
@onready var raycast_left = $"Raycast Left"
@onready var collision_shape_2d = $hurtbox/CollisionShape2D

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
		is_dead = true
		collision_shape_2d.set_deferred("disabled", true)
		animated_sprite.play("Death")
		

func die():
	queue_free()  # Remove the enemy from the scene after the animation


func _on_hurtbox_area_entered(area):
	if area.is_in_group("Sword"):
		take_damage(5)


func _on_animated_sprite_2d_animation_finished():
	die()
