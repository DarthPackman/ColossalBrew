extends AnimatedSprite2D

const SPEED = 1
var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction * SPEED * delta

