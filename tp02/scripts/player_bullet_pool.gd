extends CharacterBody2D

@export var bullet_pool_scene : PackedScene  # Référence au gestionnaire de pool
@export var max_speed = 500
@export var accel = 1250      # how fast it ramps up
@export var friction = 500   # higher = stops quicker

var bullet_pool : Node

var shoot_interval = 1.0 / 5.0  # 5 balles par seconde
var time_since_last_shot = 1.0

func _ready() -> void:
	bullet_pool = bullet_pool_scene.instantiate()
	get_parent().call_deferred("add_child", bullet_pool)

func get_input(delta):

	var input_dir = 0
	if Input.is_action_pressed("left"):
		input_dir -= 1
	if Input.is_action_pressed("right"):
		input_dir += 1
	if Input.is_action_just_pressed("shoot") and time_since_last_shot >= shoot_interval:
		shoot()
		time_since_last_shot = 0.0

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
	time_since_last_shot += delta
	move_and_slide()
	wrap_around_screen()
	position.y = 1989.53

func shoot():
	var bullet = bullet_pool.get_bullet()  # Récupérer un projectile du BulletPool
	if bullet:
		bullet.global_transform = $Muzzle.global_transform  # Positionner le projectile au niveau du Muzzle
		bullet.visible = true  # Rendre le projectile visible

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("boids"):
		get_parent().game_over()

func wrap_around_screen():
	if position.x > get_viewport_rect().size.x:
		position.x = 0
	elif position.x < 0:
		position.x = get_viewport_rect().size.x
