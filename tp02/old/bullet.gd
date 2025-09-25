extends Node2D

var speed = 750

# Signal émis lorsque le bullet est hors de l'écran
signal bullet_out_of_screen

func _physics_process(delta):
	# Déplacement du projectile
	position += transform.x * speed * delta

	# Si le projectile est hors de l'écran, émettre le signal
	if is_out_of_screen():
		emit_signal("bullet_out_of_screen")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("boids"):
		body.queue_free()
	queue_free()

func is_out_of_screen() -> bool:
	var screen_rect = get_viewport_rect()
	return position.x < 0 or position.x > screen_rect.size.x or position.y < 0 or position.y > screen_rect.size.y
