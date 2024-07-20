extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -275.0
const ROLL_VELOCITY = 250.0  

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D  

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dodging = false
var dodge_timer = 0.2  # Duration of the dodge roll
var dodge_time_left = 0.0

func _physics_process(delta):
	# Handle dodge roll timing
	if is_dodging:
		dodge_time_left -= delta
		if dodge_time_left <= 0:
			is_dodging = false
			collision_layer = 1 | 2
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dodging:
		velocity.y = JUMP_VELOCITY
	
	# Handle Dodge Roll
	if Input.is_action_just_pressed("dodge") and is_on_floor() and not is_dodging:
		is_dodging = true
		dodge_time_left = dodge_timer
		animated_sprite.play("Dodge")
		# Disable collision with enemies but not with the map
		collision_layer = 1
		
		if animated_sprite.flip_h:
			velocity.x = -ROLL_VELOCITY
		else:
			velocity.x = ROLL_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# Get input direction of -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Only change the animation if not dodging
	if not is_dodging:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("Run")
		else:
			animated_sprite.play("Jump")
	
	# Handle movement if not dodging
	if not is_dodging:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
