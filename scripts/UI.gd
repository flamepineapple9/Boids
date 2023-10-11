extends VBoxContainer

#arbitrary large number
var spike: int = 165
var startBuffer = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("start"):
		startBuffer = false
	if Engine.get_frames_per_second() < spike && !startBuffer:
		spike = Engine.get_frames_per_second()
	$FPS.text = "Cur. FPS: " + str(Engine.get_frames_per_second()) + "  FPS low: " + str(spike)
	$Boids.text = "Boids: " + str(GlobalVars.curBoids)
