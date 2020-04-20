extends KinematicBody2D

signal hit

export (int) var speed
var screensize
var collidedObject

func _ready():
	screensize = get_viewport_rect().size
	
	pass

func _process(delta):
	$HUD/Panel/RichTextLabel.text = str(floor($Timer.time_left))
	
	if Input.is_action_just_pressed("action"):
		if(collidedObject != null and !$HUD/TextBox.visible):
			$HUD.ShowText(collidedObject.GetConvo())
		elif $HUD/TextBox.visible:
			$HUD/TextBox.visible = false
	pass

func _physics_process(delta):
	if !$HUD/TextBox.visible:
		var velocity = Vector2()
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$Body/AnimationPlayer.play("walk")
			if velocity.x < 0.0:
				$Body.scale.x = -1
			else:
				$Body.scale.x = 1
		else:
			$Body/AnimationPlayer.play("Idle")
			
		
		var collision = move_and_collide(velocity * delta)
	#	position += velocity * delta
		position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
		position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)
		
#		if velocity.length() > 0:
#			var animName = ""
#			if velocity.y > 0:
#				animName = "down"
#			if velocity.y < 0:
#				animName = "up"
#			if velocity.x > 0:
#				animName += "right"
#			if velocity.x < 0:
#				animName += "left"
#			$AnimatedSprite.animation = animName
	pass


func _on_Area2D_body_entered(body):
	if(body.is_in_group("characters")):
		collidedObject = body
	pass # replace with function body


func _on_Area2D_body_exited(body):
	collidedObject = null
	pass # replace with function body


func _on_Timer_timeout():
	get_tree().paused = true
	$HUD.showscore()
	pass # Replace with function body.
