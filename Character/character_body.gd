extends CharacterBody2D

# Fizikai paraméterek
@export var gravity: float = 1400.0 # Gravitációs erő
@export var speed: float = 500.0 # Mozgási sebesség
@export var jump_force: float = 1000.0 # Ugrás ereje
var jump_count = 0
var frame_timer = 0.1
var animation_timer = 0.0

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
	if   is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_count == 1): 
		velocity.y = -jump_force
		jump_count = jump_count+1

	
	# A sebesség alkalmazása a testre
	move_and_slide()
	if position.y > 1000:  # Például ha a karakter 1000-nél mélyebbre esik
		position.x = Global.checkpoint  # Visszaállítjuk a kezdő pozícióra
		position.y = 10
# Mozgás ellenőrzése
	if Input.is_action_pressed("move_left"):
		animation_timer += delta
		if animation_timer >= frame_timer * 2:  # Lassítva a frame váltást
			$Sprite2D.frame = 0 if $Sprite2D.frame == 1 else 1  # Váltás a 0 és 1 frame között
			animation_timer = 0.0
	elif Input.is_action_pressed("move_right"):
		animation_timer += delta
		if animation_timer >= frame_timer * 2:  # Lassítva a frame váltást
			$Sprite2D.frame = 3 if $Sprite2D.frame == 4 else 4  # Váltás a 4 és 5 frame között
			animation_timer = 0.0
	else:
		$Sprite2D.frame = 2  # Alapértelmezett frame ha nincs mozgás
