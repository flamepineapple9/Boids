extends Node2D

var boidLoad = preload("res://Scenes/Boid.tscn")
var random = RandomNumberGenerator.new()

var boidCount: int = 0
var boidMax: int = 100

var start: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("start"):
		start = true
	
	if start:
		if boidCount < boidMax:
			var boidInstance = boidLoad.instantiate()
			boidInstance.position.x = randi_range(0,get_viewport_rect().size.x)
			boidInstance.position.y = randi_range(0,get_viewport_rect().size.y)
			boidInstance.rotation_degrees = randf_range(-360,360)
			get_parent().add_child(boidInstance)
			boidCount += 1
