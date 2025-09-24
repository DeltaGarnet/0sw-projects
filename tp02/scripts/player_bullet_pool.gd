extends CharacterBody2D

@export var speed = 200
@export var bullet_pool_scene : PackedScene  # Référence au gestionnaire de pool
var bullet_pool : Node

var shoot_interval = 1.0 / 5.0  # 5 balles par seconde
var time_since_last_shot = 0.0

func _ready() -> void:
	bullet_pool = bullet_pool_scene.instantiate()
	get_parent().add_child(bullet_pool)

func get_input(delta):
	look_at(get_global_mouse_position())
	
	var dir = Input.get_axis("back", "forward")
	velocity = transform.x * dir * speed
	
	if Input.is_action_just_pressed("shoot") and time_since_last_shot >= shoot_interval:
		shoot()
		time_since_last_shot = 0.0

func _physics_process(delta):
	time_since_last_shot += delta
	get_input(delta)
	move_and_slide()

func shoot():
	var bullet = bullet_pool.get_bullet()  # Récupérer un projectile du BulletPool
	if bullet:
		bullet.global_transform = $Muzzle.global_transform  # Positionner le projectile au niveau du Muzzle
		bullet.visible = true  # Rendre le projectile visible
