extends CharacterBody2D

# Fizikai paraméterek
@export var gravity: float = 1400.0 # Gravitációs erő
@export var speed: float = 500.0 # Mozgási sebesség
@export var jump_force: float = 1000.0 # Ugrás ereje
var jump_count = 0

func _physics_process(delta: float) -> void:
	# Gravitáció alkalmazása
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # Nincs gravitáció, ha a karakter a talajon van

	# Jobbra és balra mozgás
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
	else:
		velocity.x = 0

	# Ugrás
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_count < 2): 
		velocity.y = -jump_force
		jump_count = jump_count+1
	if jump_count == 2 and is_on_floor():
		jump_count = 0
	
	# A sebesség alkalmazása a testre
	move_and_slide()
	if position.y > 1000:  # Például ha a karakter 1000-nél mélyebbre esik
		position.x = Global.checkpoint  # Visszaállítjuk a kezdő pozícióra
		position.y = 10
