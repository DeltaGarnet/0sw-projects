extends Node2D

@export_range(3, 500, 2) var num_boids : int = 50  # Nombre cible de boids
#@export var debugging : bool = false :
	#set(value):
		#debugging = value
		#set_debug()

@export var enable_separation : bool = false :
	set(value) :
		enable_separation = value
		update_forces()
		
@export var enable_alignment : bool = false  :
	set(value) :
		enable_alignment = value
		update_forces()		
		
@export var enable_cohesion : bool = false  :
	set(value) :
		enable_cohesion = value
		update_forces()

@onready var boid_scene = preload("res://scenes/boid.tscn")
var mob_scene : PackedScene = preload("res://scenes/mob.tscn")

# Called when the node enters the scene tree for the first time.www
func _ready() -> void:
	randomize()  # Initialisation aléatoire
	adjust_boids()  # Ajuste le nombre de boids initialement
	#set_debug()
	update_forces()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_management()
		# Appel d'ajustement pour synchroniser le nombre de boids si le champ change
	if num_boids != get_children().filter(func(n): return n is Boid).size():
		adjust_boids()
	
func input_management():
	if (Input.is_action_just_pressed("spawn")):
		spawn_mob()
	if (Input.is_action_just_pressed("quit")):
		get_tree().quit()
	## ALT + D pour basculer le mode débogage
	#if (Input.is_action_just_pressed("toggle_debug")):
		#debugging = !debugging
		

func spawn_mob():
	var mob = mob_scene.instantiate()
	
	var mob_sprite = mob.get_node("AnimatedSprite2D") as AnimatedSprite2D
	var mob_width = 64
	
	var direction = randf_range(-1, 1)
	
	var screen_size = get_viewport_rect().size
	var screen_offset = get_viewport().get_visible_rect()
	var random_x = 0.0
	var random_y = 0.0
	
	if direction > 0:
		random_x = -mob_width + screen_offset.position.x
		random_y = randf_range(0, screen_size.y / 2)
		mob.velocity.x = abs(mob.velocity.x)
	else :
		random_x = screen_size.x + mob_width + screen_offset.position.x
		random_y = randf_range(0, screen_size.y / 2)
		mob.velocity.x = -abs(mob.velocity.x)
	
	mob.position = Vector2(random_x, random_y)
	add_child(mob)
	
func update_forces() -> void :
	var current_boids = get_children().filter(func(n): return n is Boid)
	
	for boid in current_boids:
		boid.has_cohesion = enable_cohesion
		boid.has_alignment = enable_alignment
		boid.has_separation = enable_separation
		
func adjust_boids():
	var current_boids = get_children().filter(func(n): return n is Boid)
	var current_count = current_boids.size()

	if current_count < num_boids:
		# Ajouter des boids manquants
		add_boids(num_boids - current_count)
	elif current_count > num_boids:
		# Retirer des boids en excès
		remove_boids(current_count - num_boids)

# Ajouter les boids manquants
func add_boids(count: int):
	for i in range(count):
		var boid_instance = boid_scene.instantiate()
		boid_instance.position = Vector2(randf_range(0.0, get_viewport_rect().size.x), randf_range(0.0, get_viewport_rect().size.y))
		add_child(boid_instance)

# Retirer aléatoirement les boids en excès
func remove_boids(count: int):
	var current_boids = get_children().filter(func(n): return n is Boid)
	for i in range(count):
		var random_boid = current_boids[randi_range(0, current_boids.size() - 1)]
		current_boids.erase(random_boid)
		random_boid.queue_free()

#func set_debug():
	#if not is_node_ready() : return
	#
	#var current_boids = get_children().filter(func(n): return n is Boid)
	#
	#for i in range(num_boids):
		#if (i != 0) :
			#current_boids[i].set_debug(debugging)
			#current_boids[i].is_chosen = false
		#else :
			#current_boids[0].is_chosen = debugging
