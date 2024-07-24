extends AnimatedSprite2D

@export var speed = 200.0
var direction = Vector2.ZERO

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
