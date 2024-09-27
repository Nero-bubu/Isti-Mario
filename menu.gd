extends Control

@onready 
var settings = $SettingsPanel
var pressCount := 0
var original_text = Global.original_text
@onready var resolution_dropdown = $SettingsPanel/SettingsContainer/VBoxContainer/Resolution
@onready var fullscreen_checkbox = $SettingsPanel/SettingsContainer/VBoxContainer/Fullscreen # Feltételezve, hogy a checkbox így van elnevezve
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuOptions/QuitButton.focus_mode = Control.FOCUS_ALL
	$SettingsPanel/SettingsContainer/VBoxContainer/Volume.focus_mode = Control.FOCUS_ALL
	$SettingsPanel/SettingsContainer/VBoxContainer/Fullscreen.focus_mode = Control.FOCUS_ALL
	$MenuOptions/StartButton.focus_mode = Control.FOCUS_ALL
	$MenuOptions/StartButton.grab_focus()
	settings.hide()
	_update_ui_from_globals()
	
	# Ellenőrizzük a jelenlegi ablak módot
	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen_checkbox.button_pressed = true  # Ha teljes képernyős, pipáld be a checkboxot
		resolution_dropdown.disabled = true  # Letiltjuk a felbontásválasztót

func _update_ui_from_globals() -> void:
	$SettingsPanel/SettingsContainer/VBoxContainer/Volume.value = Global.volume
	AudioServer.set_bus_volume_db(0, Global.volume)
	$SettingsPanel/SettingsContainer/VBoxContainer/Mute.button_pressed = Global.is_muted
	$SettingsPanel/SettingsContainer/VBoxContainer/Resolution.selected = Global.resolution_index

func _on_start_button_pressed() -> void: # Start gomb
	get_tree().change_scene_to_file("res://Levels/LevelSelection.tscn")

func _on_settings_button_pressed() -> void: # Beállítások gomb
	settings.show()
	$MenuOptions/QuitButton.focus_neighbor_bottom = $SettingsPanel/SettingsContainer/VBoxContainer/Volume.get_path()
	$MenuOptions/StartButton.focus_neighbor_top = $SettingsPanel/SettingsContainer/VBoxContainer/Fullscreen.get_path()
	
	pressCount += 1
	if pressCount == 2:
		settings.hide()
		pressCount = 0
		$MenuOptions/QuitButton.focus_neighbor_bottom = $MenuOptions/StartButton.get_path()
		$MenuOptions/StartButton.focus_neighbor_top = $MenuOptions/QuitButton.get_path()

func _on_quit_button_pressed() -> void: # Kilépés gomb
	get_tree().quit()

func _on_volume_value_changed(value: float) -> void: # Hangerő csúszka
	Global.volume = value
	AudioServer.set_bus_volume_db(0,value)

func _on_mute_toggled(toggled_on: bool) -> void: # Némítás gomb
	AudioServer.set_bus_mute(0, toggled_on)
	Global.is_muted = toggled_on

func _on_resolution_item_selected(index: int) -> void: # Felbontás választó
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			Global.resolution_index = 0
			Global.original_text = "1920x1080"
			original_text = "1920x1080"
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			Global.resolution_index = 1
			Global.original_text = "1280x720"
			original_text = "1280x720"
		2:
			DisplayServer.window_set_size(Vector2i(800, 600))
			Global.resolution_index = 2
			Global.original_text = "800x600"
			original_text = "800x600"
	
func _on_fullscreen_toggled(toggled_on: bool) -> void: # Fullscreen gomb, felbontás letiltása
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) # Teljes képernyős mód
		resolution_dropdown.disabled = true  # Letiltja a "Resolution" gombot
		resolution_dropdown.text = "Fullscreen" # A szöveget "Fullscreen"-re állítja
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)   # Ablakos mód
		resolution_dropdown.disabled = false # Engedélyezi a "Resolution" gombot
		resolution_dropdown.text = original_text# Visszaállítja az eredeti szöveget
