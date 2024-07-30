extends Node2D

@onready var pause_menu = $"Player/Camera2D/Pause Menu"
var paused = false

func _ready():
	if SngCheckpoints.startPoint:
		$Player.global_position = SngCheckpoints.global_position
		#STARTPOINT MUST BE MANUALLY CLEARED WHEN EXITING LEVEL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
