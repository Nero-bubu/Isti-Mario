extends CharacterBody2D

# Fizikai paraméterek
@export var gravity: float = 2400.0 # Gravitációs erő
@export var speed: float = 500.0 # Mozgási sebesség
@export var jump_force: float = 1000.0 # Ugrás ereje
var jump_count = 0  # Ugrások számolása
var frame_timer = 0.1
var animation_timer = 0.0
var dash_cooldown = 3.0  # 3 másodperces cooldown
var dash_duration = 0.1  # Dash időtartama
var dash_speed = 5000.0  # Dash sebessége
var last_dash_time = -dash_cooldown  # Kezdetben a dash elérhető
var is_dashing = false
var dash_timer = 0.0

func _physics_process(delta: float) -> void:	
	if not is_on_floor():  # Gravitáció alkalmazása
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # Nincs gravitáció, ha a karakter a talajon van

	if (Time.get_ticks_msec() / 1000.0) - last_dash_time >= dash_cooldown:  # Dash elérhetőségének kiíratása
		Global.dash_avalible.show()
		Global.dash_unavalible.hide()
	else:
		Global.dash_avalible.hide()
		Global.dash_unavalible.show()
	
	if Input.is_action_just_pressed("dash") and (Time.get_ticks_msec() / 1000.0) - last_dash_time >= dash_cooldown:  # Dash logika
		is_dashing = true
		dash_timer = dash_duration
		last_dash_time = Time.get_ticks_msec() / 1000.0
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		else:
			if Input.is_action_pressed("move_right"):
				velocity.x = dash_speed
			elif Input.is_action_pressed("move_left"):
				velocity.x = -dash_speed

	if not is_dashing:   # Jobbra és balra mozgás, ha nem dash-el
		if Input.is_action_pressed("sprint"):  # Futás
			speed = 1000  # Sebesség növelése ha nyomjuk a shiftet
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
		elif Input.is_action_pressed("move_left"):
			velocity.x = -speed
		else:
			velocity.x = 0

	if is_on_floor():  # Ugrás
		jump_count = 0
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_count == 1):  # Ugrás és double jump
		velocity.y = -jump_force  # Ugrás alkalmazása
		jump_count += 1  # Ugrások számolása

	
	move_and_slide()  # A sebesség alkalmazása a testre
	if position.y > 1000:  # Például ha a karakter 1000-nél mélyebbre esik
		position.x = Global.checkpoint  # Visszaállítjuk a kezdő pozícióra
		position.y = -600  # Checkpointok magasságának beállítása
		Global.hp = Global.hp - 1
	# Mozgás ellenőrzése
	if Input.is_action_pressed("move_left") and is_on_floor():  # Talajon 
		animation_timer += delta
		if animation_timer >= frame_timer * 2:  # Lassítva a frame váltást
			$Sprite2D.frame = 0 if $Sprite2D.frame == 1 else 1  # Váltás a 0 és 1 frame között
			animation_timer = 0.0
	elif Input.is_action_pressed("move_right") and is_on_floor():
		animation_timer += delta
		if animation_timer >= frame_timer * 2:  # Lassítva a frame váltást
			$Sprite2D.frame = 3 if $Sprite2D.frame == 4 else 4  # Váltás a 4 és 5 frame között
			animation_timer = 0.0
	else:
		$Sprite2D.frame = 2  # Alapértelmezett frame ha nincs mozgás

	if Input.is_action_pressed("move_left") and !is_on_floor():  # Levegőben balra
		$Sprite2D.frame = 1  # 1. frame-re váltás
	elif Input.is_action_pressed("move_right") and !is_on_floor():  # Levegőben jobbra
		$Sprite2D.frame = 3  # 3. frame-re váltás

	else:
		speed = 500  # Sebesség alapra állítása
