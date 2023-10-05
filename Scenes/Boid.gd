extends Area3D

var test = "test"

var vel: Vector3 = Vector3(1,0,0)
var speed: int = 10


func _ready():
	pass


#get_overlapping_areas()
func _physics_process(delta):
	position += vel * speed * delta
	pass
