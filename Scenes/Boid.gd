extends Area2D

var startScale = .6
var vel: Vector2 = Vector2(0,0)
var speed: int = 600 * startScale

# Called when the node enters the scene tree for the first time.
func _ready():
	vel = Vector2.RIGHT.rotated(rotation)
	scale = Vector2(startScale, startScale)


# 
func _physics_process(delta):
	
	#just visual as far as im aware, points boids in direction theyre moving
	rotation = vel.angle()
	
	#add all rule terms to vel, it will be normalized later to not increase the speed of boids
	vel += velocityMatch() + positionMatch() + proximity()
	
	position += vel.normalized() * speed * delta
	
	screenWrap()

#this one def works
func velocityMatch():
	var c = Vector2.ZERO
	
	var localBoids = $Vision.get_overlapping_areas()
	if localBoids.size() > 0:
		var avgVel: Vector2 = Vector2(0,0)
		for i in localBoids.size():
			avgVel += localBoids[i].vel
		c = avgVel/localBoids.size()/85
	
	return c

#pretty sure this one works
func positionMatch():
	var c = Vector2.ZERO
	
	var localBoids = $Vision.get_overlapping_areas()
	if(localBoids.size() > 0):
		var avgPos: Vector2 = Vector2(0,0)
		for i in localBoids.size():
			avgPos += localBoids[i].position
		avgPos /= localBoids.size()
		c = position.direction_to(avgPos)/25
	
	return c

#probably will have to handle all close boids, not just the closest one. Remove boids from localBoids if they are not considered close, then use both close boids in calculation
# return c -= position - closeBoidObj.position
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
