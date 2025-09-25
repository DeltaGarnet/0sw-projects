extends CharacterBody2D

@export var speed = 200
@export var bullet_scene : PackedScene
var shoot_interval = 1.0 / 5.0  # 5 balles par seconde
var time_since_last_shot = 0.0  # Chronomètre pour le tir

func get_input(delta):
	# Tourner le joueur vers la souris
	look_at(get_global_mouse_position())

	# Gestion du mouvement avec les touches avant/arrière
	var dir = Input.get_axis("back", "forward")
	velocity = transform.x * dir * speed

	# Vérifier si l'intervalle de tir est respecté
	if Input.is_action_just_pressed("shoot") :
		if (time_since_last_shot >= shoot_interval) :
			shoot()
			time_since_last_shot = 0.0  # Réinitialiser le chronomètre après le tir

func _physics_process(delta):
	time_since_last_shot += delta  # Accumuler le temps écoulé entre les tirs
	get_input(delta)
	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()  # Instancier la scène de projectile
	get_parent().add_child(bullet)  # Ajouter le projectile à la même scène que le joueur
	bullet.global_transform = $Muzzle.global_transform  # Positionner le projectile au niveau du Muzzle
