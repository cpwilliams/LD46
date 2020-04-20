extends Node

signal UpdateMusicHype
signal UpdateRomanceHype
const debugmode = false
const MUSICTICKTHRESH = 5
const ROMANCETHRESH = 13
var musicTicks = 0
var romanceTicks = 0

var hype = 20
var avgGuestHype = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	musicTicks += delta
	if musicTicks >= MUSICTICKTHRESH:
		musicTicks = 0
		emit_signal("UpdateMusicHype")
	
	romanceTicks += delta
	if romanceTicks >= ROMANCETHRESH:
		romanceTicks = 0
		emit_signal("UpdateRomanceHype")
	pass

func UpdateHype(val):
	avgGuestHype = val
	var maxPartyHype = get_node("/root/LivingRoom/YSort/Guests").get_child_count() * 10
	hype = (val/100) * maxPartyHype
