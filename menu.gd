extends Control

@onready 
var settings = $SettingsContainer
var pressCount := 0
var original_text = ""
@onready var resolution_dropdown = $SettingsContainer/VBoxContainer/Resolution

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuOptions/StartButton.grab_focus()
	settings.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void: #Start gomb
	get_tree().change_scene_to_file("res://Levels/Level0.tscn")


func _on_settings_button_pressed() -> void: #Beállítások gomb
	settings.show()
	pressCount += 1
	if pressCount == 2:
		settings.hide()
		pressCount = 0

	
func _on_quit_button_pressed() -> void: #Kilépés gomb
	get_tree().quit()


func _on_volume_value_changed(value: float) -> void: #Hangerő csúszka
	AudioServer.set_bus_volume_db(0,value)


func _on_mute_toggled(toggled_on: bool) -> void: #Némítás gomb
	AudioServer.set_bus_mute(0, toggled_on)


func _on_resolution_item_selected(index: int) -> void: #Felbontás választó
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1280,720))
		2:
			DisplayServer.window_set_size(Vector2i(800,600))
	
func _on_fullscreen_toggled(toggled_on: bool) -> void: #Fullscreen gomb, felbontás letiltása
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) # Teljes képernyős mód
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)   # Ablakos mód
	if toggled_on:
		original_text = resolution_dropdown.text
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		resolution_dropdown.disabled = true  # Letiltja a "Resolution" gombot
		resolution_dropdown.text = "Fullscreen" # A szöveget "Fullscreen"-re állítja
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		resolution_dropdown.disabled = false # Engedélyezi a "Resolution" gombot
		resolution_dropdown.text = original_text # Visszaállítja az eredeti szöveget