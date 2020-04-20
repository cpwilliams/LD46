extends Node

signal NewGuest

const guestScn = preload("res://Character.tscn")

enum ThoughtBubble {
	None,
	Blank,
	BadMusic,
	GoodMusic,
	MenCountGood,
	MenCountBad,
	WomenCountGood,
	WomenCountBad,
	RomanceGood,
	RomanceBad,
	Exit,
	CallFriend
}

enum MusicTypes{
	Club,
	Indie,
	Pop,
	Live,
	Instrumental,
	Loud
}

var playingMusic = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	playingMusic[MusicTypes.Club] = 0
	playingMusic[MusicTypes.Indie] = 0
	playingMusic[MusicTypes.Pop] = 0
	playingMusic[MusicTypes.Live] = 0
	playingMusic[MusicTypes.Instrumental] = 0
	playingMusic[MusicTypes.Loud] = 0
	
	HypeSystem.connect("UpdateMusicHype", self, "CalcMusicHype")
	HypeSystem.connect("UpdateRomanceHype", self, "ShowRomanceHype")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func AddGuest(guest):
	var newHype = 0
	var guestTotal = 0
	for guest in get_node("/root/LivingRoom/YSort/Guests").get_children():
		guestTotal += 1
		newHype += guest.GetHype()
	newHype /= guestTotal
	HypeSystem.UpdateHype(newHype)
	emit_signal("NewGuest", guest)

func CalcMusicHype():
	#effects of music apply every 5 seconds
	var newHype = 0
	var guestTotal = 0
	for guest in get_node("/root/LivingRoom/YSort/Guests").get_children():
		var musicThought = 0
		guestTotal += 1
		for musicType in MusicTypes.values():
			musicThought += guest.MusicTaste[musicType] * playingMusic[musicType] * HypeSystem.MUSICTICKTHRESH
		if musicThought <= 0:
			guest.ShowThought(ThoughtBubble.BadMusic)
		else:
			guest.ShowThought(ThoughtBubble.GoodMusic)
		guest.musicHype += musicThought
		guest.musicHype = clamp(guest.musicHype, -guest.musicThresh, guest.musicThresh)
		newHype += guest.GetHype()
	newHype /= guestTotal
	HypeSystem.UpdateHype(newHype)

func ShowRomanceHype():
	#hype from available romantic partners is constant, but the thought bubble shows every 13 seconds
	for guest in get_node("/root/LivingRoom/YSort/Guests").get_children():
			var romanceHype = guest.GetRomanceHype()
			var romanceMin = guest.genderPreference.x
			var romanceMax = guest.genderPreference.y
			var femWeight = 5-romanceMin
			var mascWeight = romanceMax-5
			
			if guest.lewd != 0:
				if romanceHype <= 0:
					if femWeight > mascWeight:
						guest.ShowThought(ThoughtBubble.WomenCountBad)
					elif mascWeight > femWeight:
							guest.ShowThought(ThoughtBubble.MenCountBad)
					else:
						guest.ShowThought(ThoughtBubble.RomanceBad)
				
				if romanceHype > 0:
					if femWeight > 0 and mascWeight > 0:
						guest.ShowThought(ThoughtBubble.RomanceGood)
					elif femWeight > mascWeight:
						guest.ShowThought(ThoughtBubble.WomenCountGood)
					elif mascWeight > femWeight:
							guest.ShowThought(ThoughtBubble.MenCountGood)
					else:
						guest.ShowThought(ThoughtBubble.RomanceGood)
	pass
	
func SummonGuests():
	var guestCount = 0
	if HypeSystem.hype < 40:
		guestCount = 1
	elif HypeSystem.hype < 60:
		guestCount = 2
	else:
		guestCount = 3
	guestCount = clamp(guestCount, 1, 10-get_node("/root/LivingRoom/YSort/Guests").get_child_count())
	var rando = RandomNumberGenerator.new()
	rando.randomize()
	for i in range(guestCount):
		var summonTimer = Timer.new()
		summonTimer.wait_time = rando.randi_range(2,10) * (i+1)
		summonTimer.one_shot = true
		summonTimer.connect("timeout", self, "CreateGuest")
		add_child(summonTimer)
		summonTimer.start()
	pass

func CreateGuest():
	var guest = guestScn.instance()
	guest.name = "Character"
	guest.baseHype = clamp(HypeSystem.hype, 30, 100)
	get_node("/root/LivingRoom/").NewGuest(guest)
	pass
