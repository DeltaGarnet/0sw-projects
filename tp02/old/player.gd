extends CharacterBody2D

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@export var max_speed = 500
@export var accel = 1250      # how fast it ramps up
@export var friction = 500   # higher = stops quicker


func get_input(delta):

	var input_dir = 0
	if Input.is_action_pressed("left"):
		input_dir -= 1
	if Input.is_action_pressed("right"):
		input_dir += 1
	if Input.is_action_pressed("shoot"):
		shoot()

	# horizontal acceleration
	if input_dir != 0:
		velocity.x += input_dir * accel * delta
	else:
		# apply friction when no key is pressed
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# clamp to max speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = 0  # keep vertical speed at 0


func _physics_process(delta):
	if delta:
		get_input(delta)
	move_and_slide()
	wrap_around_screen()
	position.y = 1989.53

func shoot():
	var b = bullet_scene.instantiate()
	get_parent().add_child(b)
	b.global_transform = $Muzzle.global_transform


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("boids"):
		get_parent().game_over()

func wrap_around_screen():
	if position.x > get_viewport_rect().size.x:
		position.x = 0
	elif position.x < 0:
		position.x = get_viewport_rect().size.x
