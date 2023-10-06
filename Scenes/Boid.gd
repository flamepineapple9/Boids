extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# 
func _physics_process(delta):
	if $Vision.get_overlapping_areas().size() > 0:
		$Vision.get_overlapping_areas()[0].hide()
