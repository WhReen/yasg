extends Resource
class_name Pickups

@export var title : String
@export var icon : Texture2D
@export var rescale : Vector2
@export_multiline var description : String
@export var sound : AudioStream
@export var pitchRandom : bool
@export var weight : float

var player_reference : CharacterBody2D

func _ready():
	icon.scale = rescale

func activate():
	SoundManager.play_sfx(sound, pitchRandom)
