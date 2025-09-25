extends Node

@export var bullet_scene : PackedScene  # Scène du projectile
@export var pool_size : int = 10  # Taille du pool

var bullet_pool : Array = []
var available_bullets : Array = []

func _ready():
	# Créer le pool de projectiles
	for i in range(pool_size):
		var bullet = bullet_scene.instantiate()
		bullet.bullet_out_of_screen.connect(_on_bullet_out_of_screen)
		
		add_child(bullet)
		bullet.visible = false  # Masquer le projectile au début
		bullet_pool.append(bullet)
		available_bullets.append(bullet)

# Fonction pour récupérer un projectile du pool
func get_bullet() -> Node2D:
	if available_bullets.size() > 0:
		var bullet = available_bullets.pop_back()
		bullet.visible = true  # Rendre le projectile visible lorsqu'il est tiré
		return bullet
	else:
		return null  # Si aucun projectile n'est disponible, retourner null

# Réinitialiser le projectile lorsqu'il est hors de l'écran
func _on_bullet_out_of_screen(bullet):
	bullet.visible = false  # Masquer le projectile
	available_bullets.append(bullet)  # Réintégrer le projectile dans le pool
	bullet.position = Vector2(0,0)
