extends Camera2D

@export var randomStrength = 30.0
@export var shakeFade = 5.0
var rng = RandomNumberGenerator.new()
var shake_strength = 0.0
@onready var stomp_sound = $StompSound
@onready var timer = $Timer

func apply_shake():
	shake_strength = randomStrength

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		offset = random_offset()
		

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _on_timer_timeout():
	stomp_sound.play()
	apply_shake()
	
