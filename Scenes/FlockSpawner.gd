extends Node3D

var boidLoad = preload("res://Scenes/Boid.tscn")
var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
#	spawnFlock()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawnFlock():
	var boidInstance = boidLoad.instantiate()
	get_parent().add_child(boidInstance)
