extends KinematicBody2D

var baseHype = 50

var musicThresh = 25 #maximum amount music can affect hype
var musicHype = 0 #amount music is affecting personal hype

var boredomThresh = 20
var thoughtTimer = null
var gender = 7 #0-10
var genderPreference = Vector2(7,10)

var lewd = 5 #higher = more likely to be seeking romantic partners
var MusicTaste = {}

var bailTimer = null
var leaving = false

var goodMoodMod = 0
var badMoodMod = 0
var hostInteractionMod = 0
var hostInteractionTimer = null

var moveMe = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	if !HypeSystem.debugmode:
		$Panel.visible = false
	var rando = RandomNumberGenerator.new()
	rando.randomize()
	add_to_group("characters")
	#amount music affects hype
	musicThresh = rando.randi_range(25,40)
	#random music taste
	for musicType in GuestSystem.MusicTypes.values():
		MusicTaste[musicType] = rando.randf_range(-1.0,1.0)
	
	#gender scale 0 = max feminine, 10 = max masculine
	var genderScale = 0
	if(rando.randf() < 0.1):
		genderScale = rando.randi_range(0,1)
	else:
		 genderScale = rando.randi_range(2,5)
	if rando.randf() < 0.5:
		genderScale *= -1
	gender = 5 + genderScale
	if gender >= 5:
		$Body/Shirt.frame = 0
		if rando.randf() < 0.3:
			$Body/Hair.frame = rando.randi_range(0,9)
		else:
			$Body/Hair.frame = rando.randi_range(0,4)
	else:
		$Body/Shirt.frame = 1
		if rando.randf() < 0.3:
			$Body/Hair.frame = rando.randi_range(0,9)
		else:
			$Body/Hair.frame = rando.randi_range(5,9)
	
	#gender attraction preferences
	var sexuality = rando.randf()
	if sexuality < 0.1:#bi
		var femScale = 0.0
		var mascScale = 0.0
		if rando.randf() > 0.5:#pan
			genderPreference = Vector2(0,10)
		else:#"I'm straight, but..."
			if gender <= 3:#women
				genderPreference = Vector2(2,10)
			elif gender >= 7:#men
				genderPreference = Vector2(0,8)
			else:
				genderPreference = Vector2(rando.randi_range(0,3), rando.randi_range(7,10))
	elif sexuality < 0.3: #gay
		if gender > 5:#masc
			genderPreference = Vector2(rando.randi_range(0,2)+5, 10)
		else: #fem
			genderPreference = Vector2(0, 5-rando.randi_range(0,2))
	else:#straight
		if gender > 5:#masc
			genderPreference = Vector2(0, 5-rando.randi_range(0,2))
		else: #fem
			genderPreference = Vector2(rando.randi_range(0,2)+5, 10)
	lewd = rando.randi_range(0,5)
	
	var romanceMin = genderPreference.x
	var romanceMax = genderPreference.y
	var femWeight = 5-romanceMin
	var mascWeight = romanceMax-5
	
	$Body/Hair.modulate = Color(rando.randf(),rando.randf(),rando.randf(),1.0)
	$Body/Shirt.modulate = Color(rando.randf(),rando.randf(),rando.randf(),1.0)
	$Body/Pants.modulate = Color(rando.randf(),rando.randf(),rando.randf(),1.0)
	$Body/Head.modulate.v = rando.randf()
	
	GuestSystem.AddGuest(self)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if leaving:
		var bailVector = position.direction_to(get_node("/root/LivingRoom/ExitArea").position).normalized()
		move_and_collide(bailVector * 150 * delta)
		$Body/AnimationPlayer.play("walk")
	else:
		move_and_collide(moveMe.normalized() * 100 * delta)
		if moveMe == Vector2():
			$Body/AnimationPlayer.play("Idle")
		else:
			$Body/AnimationPlayer.play("walk")
			if moveMe.x < 0.0:
				$Body.scale.x = -1
			else:
				$Body.scale.x = 1
	var myHype = GetHype()
	if HypeSystem.debugmode:
		$Panel/ItemList.clear()
		$Panel/ItemList.add_item(name)
		$Panel/ItemList.add_item("Hype: " + str(GetHype()))
		$Panel/ItemList.add_item("Gender: " + str(gender))
		$Panel/ItemList.add_item("Preference: " + str(genderPreference))
		$Panel/ItemList.add_item("Romance Hype: " + str(GetRomanceHype()))
		$Panel/ItemList.add_item("Lewd: " + str(lewd))
		$Panel/ItemList.add_item("Music Thresh: " + str(musicThresh))
		$Panel/ItemList.add_item("Mood Mod: " + str(goodMoodMod))
		$Panel/ItemList.add_item("Mood Mod: " + str(badMoodMod))
		$Panel/ItemList.add_item("Host Mod: " + str(hostInteractionMod))
		$Panel/ItemList.add_item(str(myHype))
	
	if myHype < 20:
		$MoodParticles.anim_offset = 0.0
		$MoodParticles.emitting = true
		if bailTimer == null and !leaving:
			collision_layer = 2
			collision_mask = 0
			bailTimer = Timer.new()
			bailTimer.wait_time = 5
			bailTimer.one_shot = true
			bailTimer.connect("timeout", self, "Leave")
			add_child(bailTimer)
			bailTimer.start()
	elif myHype < 40:
		$MoodParticles.anim_offset = 0.25
		$MoodParticles.emitting = true
		
		bailTimer = null 
		leaving = false
		collision_layer = 1
		collision_mask = 1
	elif myHype < 60:
		$MoodParticles.emitting = false
		
		bailTimer = null 
		leaving = false
		collision_layer = 1
		collision_mask = 1
	elif myHype < 80:
		$MoodParticles.anim_offset = 0.5
		$MoodParticles.emitting = true
		
		bailTimer = null 
		leaving = false
		collision_layer = 1
		collision_mask = 1
	else:
		$MoodParticles.anim_offset = 0.75
		$MoodParticles.emitting = true
		
		bailTimer = null 
		leaving = false
		collision_layer = 1
		collision_mask = 1
	
	for body in $MoodModArea.get_overlapping_bodies():
		ApplyMod(body)
	pass

func GetHype():
	return baseHype + GetRomanceHype() + musicHype + goodMoodMod - badMoodMod + hostInteractionMod
	pass

func GetRomanceHype():
	var personalHype = 0
	var guestTotal = 0
	var attractedToTotal = 0
	for guest in get_node("/root/LivingRoom/YSort/Guests").get_children():
		if guest != self:
			guestTotal += 1.0
			if guest.gender <= genderPreference.y and guest.gender >= genderPreference.x:
				attractedToTotal += 1.0
	if guestTotal < 2:
		return lewd/2 * -1
	return ((attractedToTotal/guestTotal) - 0.5) * lewd

func ShowThought(thought, override = false):
	if leaving:
		$ThoughtBubble.frame = GuestSystem.ThoughtBubble.Exit
	elif $ThoughtBubble.frame == GuestSystem.ThoughtBubble.None or override:
		$ThoughtBubble.frame = thought
	thoughtTimer = Timer.new()
	thoughtTimer.wait_time = 2
	thoughtTimer.one_shot = true
	thoughtTimer.connect("timeout", self, "EraseThought")
	add_child(thoughtTimer)
	thoughtTimer.start()
	pass

func EraseThought():
	$ThoughtBubble.frame = GuestSystem.ThoughtBubble.None

func Leave():
	ShowThought(GuestSystem.ThoughtBubble.Exit)
	leaving = true
	pass

func ApplyMod(body):
	if body == self or !body.is_in_group("characters"):
		return
	var myHype = GetHype()
	if myHype < 20:
		body.badMoodMod = 10
	elif myHype >= 80:
		body.goodMoodMod = 20
	else:
		body.badMoodMod = 0
		body.goodMoodMod = 0

func GetRandomMusicOpinion():
	var rando = RandomNumberGenerator.new()
	rando.randomize()
	var type = ""
	var randomNumber = rando.randi_range(1, GuestSystem.MusicTypes.size()) - 1
	var opinion = MusicTaste[randomNumber]
	match randomNumber:
		GuestSystem.MusicTypes.Club:
			type = "club music."
		GuestSystem.MusicTypes.Indie:
			type = "indie music."
		GuestSystem.MusicTypes.Live:
			type = "live music."
		GuestSystem.MusicTypes.Loud:
			type = "loud music."
		GuestSystem.MusicTypes.Instrumental:
			type = "instrumental music."
		GuestSystem.MusicTypes.Pop:
			type = "pop music."
		_:
			type = "ERROR music. " + str(randomNumber)
	var opinionText = ""
	if opinion < -0.5:
		opinionText = "I hate "
	elif opinion <=0:
		opinionText = "I don't really like "
	elif opinion < 0.5:
		opinionText = "I prefer "
	else:
		opinionText = "I love "
		
	return opinionText + type
	pass

func GetConvo():
	var text = ""
	if hostInteractionTimer != null and !hostInteractionTimer.is_stopped():
		text = "Didn't you JUST talk to me? "
		hostInteractionMod -= 2
	else:
		hostInteractionMod += 5
		
	var myHype = GetHype()
	if myHype < 20:
		text += "This party is horrible. " + GetRandomMusicOpinion()
	elif myHype < 40:
		text += "This party is pretty boring. " + GetRandomMusicOpinion()
	elif myHype < 60:
		text += "This party is alright. " + GetRandomMusicOpinion()
	elif myHype < 80:
		text += "Great party! " + GetRandomMusicOpinion()
	else:
		text += "This party rocks! " + GetRandomMusicOpinion()
		
	hostInteractionTimer = Timer.new()
	hostInteractionTimer.wait_time = 5.0
	hostInteractionTimer.one_shot = true
	add_child(hostInteractionTimer)
	hostInteractionTimer.start()
	
	return text

func _on_MoveTimer_timeout():
	randomize()
	if randf() < 0.75:
		moveMe = Vector2()
	else:
		moveMe = Vector2(rand_range(-1.0,1.0), rand_range(-1.0,1.0))
	pass # Replace with function body.


func _on_BaseHypeTimer_timeout():
	var myHype = GetHype()
	if myHype < 40:
		baseHype -= 1
	elif myHype >= 60 and myHype < 80:
		baseHype += 1
	pass # Replace with function body.


func _on_CallFriendTimer_timeout():
	if GetHype() >= 70:
		ShowThought(GuestSystem.ThoughtBubble.CallFriend, true)
		GuestSystem.SummonGuests()
	pass # Replace with function body.
