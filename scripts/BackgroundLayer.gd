extends ParallaxLayer

@export var BACKGROUND_SPEED = -15
var moving = true
var stop_time_left = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ! moving:
		stop_time_left -= delta
		if stop_time_left <= 0:
			moving = true
	else:
		self.motion_offset.x += BACKGROUND_SPEED * delta
	


func _on_timer_timeout():
	moving = false
	stop_time_left = 1
