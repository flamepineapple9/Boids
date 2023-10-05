extends Area3D

var test = "test"

var vel: Vector3d() = Vector3d(1,1,1)
var speed: int = 100


func _ready():
	pass


#I cant look at docs but there is a method you can call that returns a list of all overlapping
#areas,call that on the vision box and it will return all local boids.
func _physics_process(delta):
	position += vel * speed * delta


func _on_vision_area_entered(area):
	print(area.test)
