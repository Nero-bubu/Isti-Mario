extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuContainer/VBoxContainer/MarginContainer/MenuButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://menu.tscn")


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_first_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level0.tscn")


func _on_second_level_button_pressed() -> void:
	pass # Replace with function body.


func _on_third_level_button_pressed() -> void:
	pass # Replace with function body.


func _on_fourth_level_button_pressed() -> void:
	pass # Replace with function body.
