extends CanvasLayer

const PHONEMAXSCALE = 1
const PHONEMINSCALE = 0.2
var phoneResizeTimer = null
var phoneResizeDirection = 1

var cluckerCooldownTimer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Phone.rect_scale = Vector2(0.2,0.2)
	pass # Replace with function body.
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HypeMeter/TextureProgress.value = HypeSystem.hype
	
	if phoneResizeTimer != null and !phoneResizeTimer.is_stopped():
		var scaleAmount = ((phoneResizeTimer.wait_time - phoneResizeTimer.time_left)/phoneResizeTimer.wait_time) * phoneResizeDirection * (PHONEMAXSCALE - PHONEMINSCALE)
		
		if(phoneResizeDirection < 0):
			$Phone.rect_scale = Vector2(PHONEMAXSCALE+scaleAmount, PHONEMAXSCALE+scaleAmount)
		if(phoneResizeDirection > 0):
			$Phone.rect_scale = Vector2(PHONEMINSCALE+scaleAmount, PHONEMINSCALE+scaleAmount)
	pass

func ShowText(text):
	$TextBox/RichTextLabel.bbcode_text = "[center]"+text+"[/center]"
	$TextBox.visible = true
	pass

func _on_LockScreen_button_up():
	$Phone/LockScreen.disabled = true
	$Phone/LockScreen.visible = false
	$Phone/LockButton/TextureButton.disabled = false
	
	phoneResizeTimer = Timer.new()
	phoneResizeTimer.wait_time = 0.2
	phoneResizeTimer.one_shot = true
	phoneResizeDirection = 1
	add_child(phoneResizeTimer)
	phoneResizeTimer.start()
	pass # Replace with function body.


func _on_TextureButton_button_up():
	$Phone/LockScreen.disabled = false
	$Phone/LockScreen.visible = true
	$Phone/LockButton/TextureButton.disabled = true
	
	phoneResizeTimer = Timer.new()
	phoneResizeTimer.wait_time = 0.2
	phoneResizeTimer.one_shot = true
	phoneResizeDirection = -1
	add_child(phoneResizeTimer)
	phoneResizeTimer.start()
	pass # Replace with function body.


func _on_TextIcon_button_up():
	$Phone/Screen/TextApp.visible = true
	$Phone/Screen/CluckerApp.visible = false
	$Phone/Screen/BluetoothSpeakerApp.visible = false
	pass # Replace with function body.


func _on_CluckerIcon_button_up():
	$Phone/Screen/TextApp.visible = false
	$Phone/Screen/CluckerApp.visible = true
	$Phone/Screen/BluetoothSpeakerApp.visible = false
	pass # Replace with function body.


func _on_BluetoothSpeakerIcon_button_up():
	$Phone/Screen/TextApp.visible = false
	$Phone/Screen/CluckerApp.visible = false
	$Phone/Screen/BluetoothSpeakerApp.visible = true
	pass # Replace with function body.


func _on_Home_button_up():
	$Phone/Screen/TextApp.visible = false
	$Phone/Screen/CluckerApp.visible = false
	$Phone/Screen/BluetoothSpeakerApp.visible = false
	pass # Replace with function body.


func _on_PostButton_button_up():
	var post = load("res://CluckPost.tscn").instance()
	post.get_node("ColorRect").color = Color(0.0,0.0,0.5,1.0)
	post.get_node("ColorRect/RichTextLabel").text = "Come to the party! #gethype"
	$Phone/Screen/CluckerApp/ScrollContainer/VBoxContainer.add_child(post)
	if cluckerCooldownTimer == null or cluckerCooldownTimer.is_stopped():
		cluckerCooldownTimer = Timer.new()
		cluckerCooldownTimer.wait_time = 20.0
		cluckerCooldownTimer.one_shot = true
		add_child(cluckerCooldownTimer)
		cluckerCooldownTimer.start()
		
		yield(get_tree().create_timer(1.0),"timeout")
		var response = load("res://CluckPost.tscn").instance()
		response.get_node("ColorRect/RichTextLabel").text = "on my way!"
		$Phone/Screen/CluckerApp/ScrollContainer/VBoxContainer.add_child(response)
		GuestSystem.SummonGuests()
	else:
		yield(get_tree().create_timer(3.0),"timeout")
		var response = load("res://CluckPost.tscn").instance()
		response.get_node("ColorRect/RichTextLabel").text = "lol stop spamming your party dude #mustbeboring"
		$Phone/Screen/CluckerApp/ScrollContainer/VBoxContainer.add_child(response)
	pass # Replace with function body.


func _on_Textbox_button_up():
	$TextBox.visible = false
	pass # Replace with function body.


func _on_SkinTone_value_changed(value):
	$Customization/Body/Head.modulate.v = value
	pass # Replace with function body.


func _on_HairPrev_button_up():
	if $Customization/Body/Hair.frame == 0:
		$Customization/Body/Hair.frame = 9
	else:
		$Customization/Body/Hair.frame -= 1
	pass # Replace with function body.


func _on_HairNext_button_up():
	if $Customization/Body/Hair.frame == 9:
		$Customization/Body/Hair.frame = 0
	else:
		$Customization/Body/Hair.frame += 1
	pass # Replace with function body.


func _on_BodyNext_button_up():
	$Customization/Body/Shirt.frame = !$Customization/Body/Shirt.frame
	pass # Replace with function body.


func _on_BodyPrev_button_up():
	$Customization/Body/Shirt.frame = !$Customization/Body/Shirt.frame
	pass # Replace with function body.


func _on_HairR_value_changed(value):
	$Customization/Body/Hair.modulate.r = value
	pass # Replace with function body.


func _on_HairG_value_changed(value):
	$Customization/Body/Hair.modulate.g = value
	pass # Replace with function body.


func _on_HairB_value_changed(value):
	$Customization/Body/Hair.modulate.b = value
	pass # Replace with function body.


func _on_ShirtR_value_changed(value):
	$Customization/Body/Shirt.modulate.r = value
	pass # Replace with function body.


func _on_ShirtG_value_changed(value):
	$Customization/Body/Shirt.modulate.g = value
	pass # Replace with function body.


func _on_ShirtB_value_changed(value):
	$Customization/Body/Shirt.modulate.b = value
	pass # Replace with function body.


func _on_PantsR_value_changed(value):
	$Customization/Body/Pants.modulate.r = value
	pass # Replace with function body.


func _on_PantsG_value_changed(value):
	$Customization/Body/Pants.modulate.g = value
	pass # Replace with function body.


func _on_PantsB_value_changed(value):
	$Customization/Body/Pants.modulate.b = value
	pass # Replace with function body.


func _on_DoneButton_pressed():
	var playerBody = get_node("/root/LivingRoom/YSort/Player/Body")

	playerBody.get_node("Head").modulate.v = $Customization/Body/Head.modulate.v
	playerBody.get_node("Hair").frame = $Customization/Body/Hair.frame


	playerBody.get_node("Shirt").frame = $Customization/Body/Shirt.frame
	playerBody.get_node("Hair").modulate = $Customization/Body/Hair.modulate

	playerBody.get_node("Shirt").modulate = $Customization/Body/Shirt.modulate
	
	playerBody.get_node("Pants").modulate = $Customization/Body/Pants.modulate
	
	get_tree().paused = false
	$Customization.visible = false
	pass # Replace with function body.


func _on_RandoButton_pressed():
	var rando = RandomNumberGenerator.new()
	rando.randomize()
	$Customization/Body/Head.modulate.v = rando.randf()
	$Customization/Body/Hair.frame = rando.randi_range(0,9)
	$Customization/Body/Shirt.frame = rando.randi_range(0,1)
	$Customization/Body/Hair.modulate = Color(rando.randf(), rando.randf(), rando.randf(), 1.0)
	$Customization/Body/Shirt.modulate = Color(rando.randf(), rando.randf(), rando.randf(), 1.0)
	$Customization/Body/Pants.modulate = Color(rando.randf(), rando.randf(), rando.randf(), 1.0)
	
	$Customization/SkinTone.value = $Customization/Body/Head.modulate.v
	$Customization/HairR.value = $Customization/Body/Hair.modulate.r
	$Customization/HairG.value = $Customization/Body/Hair.modulate.g
	$Customization/HairB.value = $Customization/Body/Hair.modulate.b
	$Customization/ShirtR.value = $Customization/Body/Shirt.modulate.r
	$Customization/ShirtG.value = $Customization/Body/Shirt.modulate.g
	$Customization/ShirtB.value = $Customization/Body/Shirt.modulate.b
	$Customization/PantsR.value = $Customization/Body/Pants.modulate.r
	$Customization/PantsG.value = $Customization/Body/Pants.modulate.g
	$Customization/PantsB.value = $Customization/Body/Pants.modulate.b
	pass # Replace with function body.


func _on_Button_toggled(button_pressed):
	if button_pressed:
		get_node("/root/LivingRoom/Radio").stream = load("res://Arts/Clubbing in the Club Tonight.ogg")
		get_node("/root/LivingRoom/Radio").play()
		$Phone/Screen/BluetoothSpeakerApp/Button2.pressed = false
		$Phone/Screen/BluetoothSpeakerApp/Button3.pressed = false
		$Phone/Screen/BluetoothSpeakerApp/Button4.pressed = false
		
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Club] = 1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Indie] = -1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Pop] = 0.5
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Live] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Instrumental] = 1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = ($Phone/Screen/BluetoothSpeakerApp/HSlider.value*2)/100-1.0
	else:
		get_node("/root/LivingRoom/Radio").stop()
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Club] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Indie] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Pop] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Live] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Instrumental] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = 0
	pass # Replace with function body.


func _on_Button2_toggled(button_pressed):
	if button_pressed:
		get_node("/root/LivingRoom/Radio").stream = load("res://Arts/Bubbles and Rainbows.ogg")
		get_node("/root/LivingRoom/Radio").play()
		$Phone/Screen/BluetoothSpeakerApp/Button.pressed = false
		$Phone/Screen/BluetoothSpeakerApp/Button3.pressed = false
		$Phone/Screen/BluetoothSpeakerApp/Button4.pressed = false
		
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Club] = 0.5
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Indie] = -1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Pop] = 1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Live] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Instrumental] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = ($Phone/Screen/BluetoothSpeakerApp/HSlider.value*2)/100-1.0
	else:
		get_node("/root/LivingRoom/Radio").stop()
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Club] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Indie] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Pop] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Live] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Instrumental] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = 0
	pass # Replace with function body.


func _on_Button3_toggled(button_pressed):
	if button_pressed:
		get_node("/root/LivingRoom/Radio").stream = load("res://Arts/That Coffee Shop You Never Heard Of.ogg")
		get_node("/root/LivingRoom/Radio").play()
		$Phone/Screen/BluetoothSpeakerApp/Button2.pressed = false
		$Phone/Screen/BluetoothSpeakerApp/Button.pressed = false
		$Phone/Screen/BluetoothSpeakerApp/Button4.pressed = false
		
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Club] = -1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Indie] = 1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Pop] = -1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Live] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Instrumental] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = ($Phone/Screen/BluetoothSpeakerApp/HSlider.value*2)/100-1.0
	else:
		get_node("/root/LivingRoom/Radio").stop()
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Club] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Indie] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Pop] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Live] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Instrumental] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = 0
	pass # Replace with function body.


func _on_Button4_toggled(button_pressed):
	if button_pressed:
		get_node("/root/LivingRoom/Radio").stream = load("res://Arts/Cigarettes at Dawn(Instrumental).ogg")
		get_node("/root/LivingRoom/Radio").play()
		$Phone/Screen/BluetoothSpeakerApp/Button2.pressed = false
		$Phone/Screen/BluetoothSpeakerApp/Button3.pressed = false
		$Phone/Screen/BluetoothSpeakerApp/Button.pressed = false
		
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Club] = -1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Indie] = 1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Pop] = -1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Live] = 1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Instrumental] = 1
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = ($Phone/Screen/BluetoothSpeakerApp/HSlider.value*2)/100-1.0
	else:
		get_node("/root/LivingRoom/Radio").stop()
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Club] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Indie] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Pop] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Live] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Instrumental] = 0
		GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = 0
	pass # Replace with function body.


func _on_HSlider_value_changed(value):
	GuestSystem.playingMusic[GuestSystem.MusicTypes.Loud] = ($Phone/Screen/BluetoothSpeakerApp/HSlider.value*2)/100-1.0
	get_node("/root/LivingRoom/Radio").volume_db = -80 + (65 * $Phone/Screen/BluetoothSpeakerApp/HSlider.value/100)
	pass # Replace with function body.

func showscore():
	$Score.visible = true
	$Score/RichTextLabel2.text = "Final Score: " + str(HypeSystem.hype)
