extends Area2D

var startScale = .4
var vel: Vector2 = Vector2.ZERO
var speed: int = 1000 * startScale

# Called when the node enters the scene tree for the first time.
func _ready():
	vel = Vector2.RIGHT.rotated(rotation)
	scale = Vector2(startScale, startScale)
	
	$Sprite.color = Color8(0,200,randi_range(75,255))


func _physics_process(delta):
	var localBoids = $Vision.get_overlapping_areas()
	
	#just visual as far as im aware, points boids in direction theyre moving
	rotation = vel.angle()
	
	#add all rule terms to vel, it will be normalized later to not increase the speed of boids
	vel +=  velocityMatch(localBoids) + positionMatch(localBoids) + avoidance(localBoids) + boundary()
	vel = vel.normalized()
	position += vel * speed * delta


func velocityMatch(localBoids):
	var c: Vector2 = Vector2.ZERO
	
	if localBoids.size() > 0:
		var avgVel: Vector2 = Vector2(0,0)
		for i in localBoids.size():
			avgVel += localBoids[i].vel
		c = avgVel/localBoids.size()/14
	
	return c

#might need to change direction_to as it normalizes the vector. thats bad (apparently)
func positionMatch(localBoids):
	var c: Vector2 = Vector2.ZERO
	
	if localBoids.size() > 0:
		var avgPos: Vector2 = Vector2.ZERO
		for i in localBoids.size():
			avgPos += localBoids[i].position
		avgPos /= localBoids.size()
		c = position.direction_to(avgPos)/65
	
	return c

func avoidance(localBoids):
	if localBoids.size() > 0:
		var closeBoids = []
		
		#pushes ALL close boids to new array, closeBoids
		#tiny optimization, pushing to front of array is a slower operation than pushing to back. doesnt really matter because closeBoids is a pretty small array.
		for i in localBoids.size():
			if position.distance_to(localBoids[i].position) < 100 * startScale:
				closeBoids.push_back(localBoids[i])
		
		
		var avgDist = Vector2.ZERO
		for n in closeBoids.size():
			avgDist +=  position - closeBoids[n].position
			
		return avgDist.normalized()/6
	return Vector2.ZERO

func boundary():
	var c: Vector2 = Vector2.ZERO
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
