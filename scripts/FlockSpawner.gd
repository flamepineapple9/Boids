extends Node2D

var boidLoad = preload("res://Scenes/Boid.tscn")

var boids: int = 250
var start: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("start"):
		for i in range(boids):
			var boidInstance = boidLoad.instantiate()
			boidInstance.position.x = randi_range(0,get_viewport_rect().size.x)
			boidInstance.position.y = randi_range(0,get_viewport_rect().size.y)
			boidInstance.rotation_degrees = randf_range(-360,360)
			get_parent().add_child(boidInstance)
			GlobalVars.curBoids += 1


#Deletes boids if they spawn in the obstacle, then spawns another to replace it 
func _on_square_area_entered(area):
	GlobalVars.curBoids -= 1
	var boidInstance = boidLoad.instantiate()
	boidInstance.position.x = randi_range(0,get_viewport_rect().size.x)
	boidInstance.position.y = randi_range(0,get_viewport_rect().size.y)
	boidInstance.rotation_degrees = randf_range(-360,360)
	get_parent().add_child(boidInstance)
	GlobalVars.curBoids += 1
	area.queue_free()
