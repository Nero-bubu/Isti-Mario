extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()
	Engine.time_scale = 1

var original_text = ""
@onready var pause_menu = $CanvasLayer/PauseMenu
var paused = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
func pauseMenu(): #Pause menü
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused
