extends CharacterBody2D

@export var max_speed = 500
@export var accel = 1250      # how fast it ramps up
@export var friction = 500   # higher = stops quicker

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

func get_input(delta):

	var input_dir = 0
	if Input.is_action_pressed("left"):
		input_dir -= 1
	if Input.is_action_pressed("right"):
		input_dir += 1

	# horizontal acceleration
	if input_dir != 0:
		velocity.x += input_dir * accel * delta
	else:
		# apply friction when no key is pressed
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# clamp to max speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = 0  # keep vertical speed at 0

	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	get_input(delta)
	move_and_slide()

func shoot():
	var b = bullet_scene.instantiate()
	get_parent().add_child(b)
	b.global_transform = $Muzzle.global_transform
