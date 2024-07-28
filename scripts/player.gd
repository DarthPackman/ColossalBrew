extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -275.0
const ROLL_VELOCITY = 250.0
@onready var magic_ball = preload("res://scenes/magicSpell.tscn")
@onready var timer = $Camera2D/Timer
@onready var stomp_sound = $Camera2D/StompSound

@export var health = 5
@export var attack_damage = 10
@onready var sword_swing = $SwordSwing
@onready var walk_sound = $WalkSound
@onready var hud_health = $Camera2D/MarginContainer/Label

@onready var audio_stream_player_2d = $"../AudioStreamPlayer2D"
@onready var jump_sound = $JumpSound
@onready var roll_sound = $RollSound

@onready var attack_area_left = $AnimatedSprite2D/AttackArea2
@onready var attack_area_right = $AnimatedSprite2D/AttackArea
@onready var attack_box_1 = $AnimatedSprite2D/AttackArea/AttackBox
@onready var attack_box_2 = $AnimatedSprite2D/AttackArea2/AttackBox2
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D  

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dodging = false
var dodge_timer = 0.25  # Duration of the dodge roll
var dodge_time_left = 0.0
var is_moving = false
var walk_timer = 0.18

var is_attacking = false
var is_melee = false
var is_magic = false
var attack_time_left = 0.0
var attack_time = 0.25

var invincible = false
var invincible_duration = 0.5
var invincible_time_left = 0.0
var controls_enabled = true

var currentAttackArea = attack_area_right

func _ready():
	attack_box_1.set_deferred("disabled", true)
	attack_box_2.set_deferred("disabled", true)
	hud_health.text = str(health)

func _physics_process(delta):
	# Handle dodge roll timing
	if is_dodging:
		dodge_time_left -= delta
		if dodge_time_left <= 0:
			is_dodging = false
			set_collision_layer_value(1, true)

	if is_attacking:
		attack_time_left -= delta
		if attack_time_left <= 0:
			is_attacking = false
			is_magic = false
			attack_box_1.set_deferred("disabled", true)
			attack_box_2.set_deferred("disabled", true)

	if invincible:
		invincible_time_left -= delta
		if invincible_time_left <= 0:
			invincible = false
			animated_sprite.modulate = Color(1, 1, 1, 1)  # Reset sprite color
			set_collision_layer_value(1, true)

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dodging and controls_enabled:
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Handle attack
	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_dodging and controls_enabled:
		is_attacking = true
		is_melee = true
		attack_time_left = attack_time
		if currentAttackArea == attack_area_left:
			attack_box_1.set_deferred("disabled", false)
		else:
			attack_box_2.set_deferred("disabled", false)
		animated_sprite.play("BackSwing")
		sword_swing.play()
		
		
	if Input.is_action_just_pressed("magicAttack") and not is_dodging and controls_enabled:
		is_magic = true
		is_attacking = true
		attack_time_left = attack_time
		animated_sprite.play("Magic")
		var magic = magic_ball.instantiate()
		get_tree().current_scene.add_child(magic)
		audio_stream_player_2d.play()
		if animated_sprite.flip_h:
			magic.global_position = global_position - Vector2(3, 10)  # Adjust the offset as needed
			magic.set_direction(Vector2.LEFT)
		else:
			magic.global_position = global_position + Vector2(3, -10)  # Adjust the offset as needed
			magic.set_direction(Vector2.RIGHT)

	# Handle Dodge Roll
	if Input.is_action_just_pressed("dodge") and is_on_floor() and not is_dodging and controls_enabled:
		is_dodging = true
		dodge_time_left = dodge_timer
		animated_sprite.play("Dodge")
		roll_sound.play()
		# Disable collision with enemies but not with the map
		set_collision_layer_value(1, false)

		if animated_sprite.flip_h:
			velocity.x = -ROLL_VELOCITY
		else:
			velocity.x = ROLL_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")

	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
		currentAttackArea = attack_area_right
	elif direction < 0:
		animated_sprite.flip_h = true
		currentAttackArea = attack_area_left

	# Only change the animation if not dodging
	if not is_dodging and not is_attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("Run")
				walk_timer -= delta
				if walk_timer <= 0:
					walk_sound.play()
					walk_timer = 0.18
				
		else:
			animated_sprite.play("Jump")
			

	# Handle movement if not dodging
	if not is_dodging and controls_enabled:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func getDamage():
	return attack_damage

func take_damage(dmg):
	collision_layer = 1
	invincible = true
	invincible_time_left = invincible_duration
	animated_sprite.modulate = Color(1, 1, 1, 0.5)
	health -= dmg
	hud_health.text = str(health)
	animated_sprite.play("Wimper")

	if health <= 0:
		animated_sprite.play("Death")
		controls_enabled = false  # Disable player controls on death
		velocity = Vector2.ZERO  # Stop player movement
		return true
	else:
		return false
		
