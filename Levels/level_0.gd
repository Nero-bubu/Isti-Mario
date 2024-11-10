extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()  # PauseMenu elrejtése
	Engine.time_scale = 1  # Játék sebességének beállítása
	Global.checkpoint = 50  # Kezdőpont beállítása
	Global.dash_avalible = $CanvasLayer/Hud/Dash_Avalible # Dash elérhetősége
	Global.dash_unavalible = $CanvasLayer/Hud/Dash_Unavalible # Dash elérhetősége
	Global.hp = 3
	Global.hud = $CanvasLayer/Hud
	$CanvasLayer/Hud.hide()
	pauseMenu()
	pause_menu.hide()
var original_text = ""  # ResolutionDropdown szöveg backup
@onready var pause_menu = $CanvasLayer/PauseMenu
var paused = false

func _process(delta: float) -> void:  # Folyamatosan figyelt változások
	if Input.is_action_just_pressed("pause"):  # PauseMenu aktiválása
		pauseMenu()
	if $CharacterBody2D.position.x > 1000:  # Új checkpoint beállítása
		Global.checkpoint = 1000
	if Global.hp < 3:
		$CanvasLayer/Hud/Hp_2.hide()
	if Global.hp < 2:
		$CanvasLayer/Hud/Hp_1.hide()
	if Global.hp < 1:
		$CanvasLayer/Hud/Hp_0.hide()
func pauseMenu(): #Pause menü
		if paused:
			pause_menu.hide()
			Engine.time_scale = 1
			Global.hud.show()
		else:
			pause_menu.show()
			Engine.time_scale = 0
			Global.hud.hide()
		paused = !paused
