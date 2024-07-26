extends AnimatedSprite2D

@export var speed = 200.0
var direction = Vector2.ZERO
var soundTimer = 2

func _ready():
	play("magicStart")
	
func _process(delta):
	position += direction * speed * delta

func set_direction(dir):
	direction = dir
	if direction.x < 0:
		flip_h = true
	else:
		flip_h = false

func _on_area_2d_area_entered(area):
	if (area.get_name() == "hurtbox" and area.is_in_group("Enemy")) or area.get_collision_layer() < 5:
		speed = 0
		play("castExplosion")
   


func _on_animation_finished():

	queue_free()
