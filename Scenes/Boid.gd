extends Area2D

var vel: Vector2 = Vector2(0,0)
var speed: int = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	vel = Vector2.RIGHT.rotated(rotation)


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
	var localBoids = $Vision.get_overlapping_areas()
	if localBoids.size() > 0:
		var avgVel: Vector2 = Vector2(0,0)
		for i in localBoids.size():
			avgVel += localBoids[i].vel
		return (avgVel/localBoids.size())/85
	else:
		return Vector2(0,0)

#pretty sure this one works
func positionMatch():
	var localBoids = $Vision.get_overlapping_areas()
	if(localBoids.size() > 0):
		var avgPos: Vector2 = Vector2(0,0)
		for i in localBoids.size():
			avgPos += localBoids[i].position
		avgPos /= localBoids.size()
		return(position.direction_to(avgPos))/25
	else:
		return Vector2.ZERO

#probably will have to handle all close boids, not just the closest one. Remove boids from localBoids if they are not considered close, then use both close boids in calculation
# return c -= position - closeBoidObj.position
func proximity():
	if $Vision.has_overlapping_areas():
		var closeBoidObj = null
		
		#arbitrary large number
		var closeBoid = Vector2(1000000,1000000)
		var localBoids = $Vision.get_overlapping_areas()
		for i in localBoids.size():
			if position.distance_to(localBoids[i].position) < position.distance_to(closeBoid):
				closeBoid = localBoids[i].position
				closeBoidObj = localBoids[i]
		if position.distance_to(closeBoid) < 90:
			return (position - closeBoidObj.position).normalized()
		else:
			return Vector2.ZERO
	else:
		return Vector2.ZERO

func screenWrap():
	if position.x < 0:
		position.x = get_viewport_rect().size.x
	if position.x > get_viewport_rect().size.x:
		position.x = 0
	if position.y < 0:
		position.y = get_viewport_rect().size.y
	if position.y > get_viewport_rect().size.y:
		position.y = 0
