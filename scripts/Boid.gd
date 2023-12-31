extends Area2D

var startScale: float = .25
var vel: Vector2 = Vector2.ZERO
var speed: int = 600 * startScale
var localBoids: Array = []

var c: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	vel = Vector2.RIGHT.rotated(rotation)
	scale = Vector2(startScale, startScale)
	
	$Sprite.color = Color8(0,180,randi_range(75,255))


func _physics_process(delta):
	localBoids = $Vision.get_overlapping_areas()
	#just visual as far as im aware, points boids in direction theyre moving
	rotation = vel.angle()
	
	#add all rule terms to vel, it will be normalized later to not increase the speed of boids
	vel +=  velocityMatch(localBoids) + positionMatch(localBoids) + avoidance(localBoids) + boundary() + mouseAvoid() + obstacle()
	vel = vel.normalized()
	position += vel * speed * delta
	


func velocityMatch(localBoids):
	c = Vector2.ZERO
	
	if localBoids.size() > 0:
		var avgVel: Vector2 = Vector2(0,0)
		for i in localBoids.size():
			avgVel += localBoids[i].vel
		c = avgVel/localBoids.size()/14
	
	return c

func positionMatch(localBoids):
	c = Vector2.ZERO
	
	if localBoids.size() > 0:
		var avgPos: Vector2 = Vector2.ZERO
		for i in localBoids.size():
			avgPos += localBoids[i].position
		avgPos /= localBoids.size()
		c = position.direction_to(avgPos)/65
	
	return c

func avoidance(localBoids):
	c = Vector2.ZERO
	if localBoids.size() > 0:
		var avgDist: Vector2 = Vector2.ZERO
		
		for i in localBoids.size():
			if position.distance_to(localBoids[i].position) < 75 * startScale:
				avgDist +=  position - localBoids[i].position
		
		c = 2*avgDist.normalized()/5
	
	return c

func boundary():
	c = Vector2.ZERO
	var steeringForce: int = 1
	var margin: int = 100
	
	if position.x < margin:
		c.x += steeringForce 
	if position.y < margin:
		c.y += steeringForce
	if position.x > get_viewport_rect().size.x - margin:
		c.x += -steeringForce
	if position.y > get_viewport_rect().size.y - margin:
		c.y += -steeringForce
	
	return c/10

func mouseAvoid():
	c = Vector2.ZERO

	var mousePos: Vector2 = get_viewport().get_mouse_position()
	if position.distance_to(mousePos) < 150:
		c = (position - mousePos).normalized()

	return c/5

func obstacle():
	c = Vector2.ZERO
	
	var castAngle = ($Rays/RayCast2.target_position - $Rays/RayCast2.position).angle()
	
	if $Rays/RayCast.is_colliding():
		c += ($Rays/RayCast.position - $Rays/RayCast.target_position).rotated(rotation)
	elif $Rays/RayCast2.is_colliding():
		c += ($Rays/RayCast2.position - $Rays/RayCast2.target_position).rotated(rotation)
	elif $Rays/RayCast3.is_colliding():
		c += ($Rays/RayCast3.position - $Rays/RayCast3.target_position).rotated(rotation)
	elif $Rays/RayCast4.is_colliding():
		c += ($Rays/RayCast4.position - $Rays/RayCast4.target_position).rotated(rotation)
	
	return c/200
