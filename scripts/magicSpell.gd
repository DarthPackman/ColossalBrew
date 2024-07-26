extends AnimatedSprite2D

@onready var raycast = $Area2D/Raycast

@export var speed = 200.0
var direction = Vector2.ZERO
var soundTimer = 2
var doneExplosion = true
@onready var explosion_sound = $explosionSound

func _ready():
	play("magicStart")
	
func _process(delta):
	position += direction * speed * delta
	if raycast.is_colliding():
		speed = 0
		play("castExplosion")
		explosion_sound.play()
		raycast.enabled = false
		

func set_direction(dir):
	direction = dir
	if direction.x < 0:
		flip_h = true
	else:
		flip_h = false

func _on_area_2d_area_entered(area):
	if (area.get_name() == "hurtbox" and area.is_in_group("Enemy")):
		speed = 0
		play("castExplosion")
		explosion_sound.play()
   


func _on_animation_finished():
		queue_free()
		
