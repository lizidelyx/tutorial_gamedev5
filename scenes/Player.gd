extends CharacterBody2D

@export var walk_speed = 200
@export var crouch_speed = 100
@export var gravity = 200.0
@export var jump_speed = -300
@export var push_force = 500.0  # Kekuatan dorongan terhadap box
@onready var sprite = $AnimatedSprite2D
@onready var sfx_walk = $sfx_walk

var push = false
var jumps_left = 2
var is_crouching = false

func _physics_process(delta):
	velocity.y += delta * gravity

	if is_on_floor():
		jumps_left = 2

	if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
		velocity.y = jump_speed
		jumps_left -= 1

	if Input.is_action_pressed("ui_down"):
		is_crouching = true
		sprite.play("crouch")
	else:
		is_crouching = false

	var move_direction = 0

	if Input.is_action_pressed("ui_left"):
		move_direction = -1
		sprite.flip_h = true
		if not is_crouching:
			sprite.play("walk")
			if not sfx_walk.playing:  # **Cegah suara bertumpuk**
				sfx_walk.play()

	elif Input.is_action_pressed("ui_right"):
		move_direction = 1
		sprite.flip_h = false
		if not is_crouching:
			sprite.play("walk")
			if not sfx_walk.playing:  # **Cegah suara bertumpuk**
				sfx_walk.play()
			
	else:
		if not is_crouching:
			sprite.play("idle")
		sfx_walk.stop()  # **Hentikan suara langkah saat karakter diam**

	# **Tambahan:** Jika tidak berada di lantai, animasi "jump" akan dimainkan
	if not is_on_floor():
		sprite.play("jump")
		sfx_walk.stop()

	velocity.x = move_direction * (crouch_speed if is_crouching else walk_speed)

	move_and_slide()
