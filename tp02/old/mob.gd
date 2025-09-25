extends CharacterBody2D

@export var speed: float = 100.0  # Speed of the toaster


func _ready():
	# Set the initial velocity to move from right to left
	velocity.x = -speed
	velocity.y = speed * 0.4
	$AnimatedSprite2D.play()

func _physics_process(delta):
	# Move the toaster
	move_and_slide()
	
	# Flip the sprite based on the direction of movement
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true  # Flip the sprite horizontally when moving right
	else:
		$AnimatedSprite2D.flip_h = false  # Default when moving left

func get_size() -> Vector2 :
	return Vector2.ZERO
	
