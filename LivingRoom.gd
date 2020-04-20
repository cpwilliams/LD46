extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$YSort/Player/Camera2D.limit_left = 0
	$YSort/Player/Camera2D.limit_top = 0
	$YSort/Player/Camera2D.limit_right = 1500
	$YSort/Player/Camera2D.limit_bottom = 600
	
	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func NewGuest(guest):
	guest.position = $ExitArea.position + Vector2(75,0)
	guest.moveMe = Vector2(1, rand_range(-1.0,1.0))
	$YSort/Guests.add_child(guest)
	pass

func _on_ExitArea_body_entered(body):
	if body.is_in_group("characters") and body.leaving:
		body.queue_free()
	pass # Replace with function body.
