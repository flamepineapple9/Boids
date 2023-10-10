extends Area2D

var startScale = .6
var vel: Vector2 = Vector2(0,0)
var speed: int = 100 * startScale

# Called when the node enters the scene tree for the first time.
func _ready():
	vel = Vector2.RIGHT.rotated(rotation)
	scale = Vector2(startScale, startScale)


# Vel just keeps getting added to and keeps getting bigger,so as simulation continues, new changes have less and less effect as they proportionally
# affect the vel.normalized() calculation more and more
func _physics_process(delta):
	
	#just visual as far as im aware, points boids in direction theyre moving
	rotation = vel.angle()
	
	#add all rule terms to vel, it will be normalized later to not increase the speed of boids
	vel += avoidance() + velocityMatch() + positionMatch()
	vel = vel.normalized()
	position += vel * speed * delta
	
	screenWrap()

#this one def works LMFAO no it does NOT. goes to fucking infinity if the /85 isnt there 
#maybe normalizing velocity every frame before adding it to position fixed things, because vel will not go to infinity and beyond
func velocityMatch():
	var c = Vector2.ZERO
	
	var localBoids = $Vision.get_overlapping_areas()
	if localBoids.size() > 0:
		var avgVel: Vector2 = Vector2(0,0)
		for i in localBoids.size():
			avgVel += localBoids[i].vel
		c = avgVel/localBoids.size()/85
	
	return c

#might need to change direction_to as it normalizes the vector. thats bad (apparently)
func positionMatch():
	var c = Vector2.ZERO
	
	var localBoids = $Vision.get_overlapping_areas()
	if localBoids.size() > 0:
		var avgPos: Vector2 = Vector2.ZERO
		for i in localBoids.size():
			avgPos += localBoids[i].position
		avgPos /= localBoids.size()
		c = position.direction_to(avgPos)
	
	return c

#currently unused
func proximity():
	var c = Vector2.ZERO
	
	if $Vision.has_overlapping_areas():
		var closeBoidObj = null
		
		#arbitrary large number
		var closeBoid = Vector2(1000000,1000000)
		var localBoids = $Vision.get_overlapping_areas()
		for i in localBoids.size():
			if position.distance_to(localBoids[i].position) < position.distance_to(closeBoid):
				closeBoid = localBoids[i].position
				closeBoidObj = localBoids[i]
		if position.distance_to(closeBoid) < 75 * startScale:
			c -= closeBoidObj.position - position
	
	return c.normalized()/2

func avoidance():
	
	if $Vision.has_overlapping_areas():
		var localBoids = $Vision.get_overlapping_areas()
		var closeBoids = []
		
		#pushes ALL close boids to new array, closeBoids
		for i in localBoids.size():
			if position.distance_to(localBoids[i].position) < 75 * startScale:
				closeBoids.push_front(localBoids[i])
		
		
		var avgDist = Vector2.ZERO
		for n in closeBoids.size():
			#This equation is not doing what I want it to be doing
			#Need to return average distance away, negative
			avgDist +=  position - closeBoids[n].position
			
		return avgDist
	return Vector2.ZERO

#replace with boundary(), should be pretty simple (clueless)
func screenWrap():
	if position.x < 0:
		position.x = get_viewport_rect().size.x
	if position.x > get_viewport_rect().size.x:
		position.x = 0
	if position.y < 0:
		position.y = get_viewport_rect().size.y
	if position.y > get_viewport_rect().size.y:
		position.y = 0
