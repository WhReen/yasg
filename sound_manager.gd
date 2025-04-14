extends Node2D

@onready var sfx_player : AudioStreamPlayer
@onready var bgm_player : AudioStreamPlayer

func play_sfx(sfx: AudioStream, random = false):
	if sfx:
		sfx_player = AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_player.set_process_mode(1)
		
		sfx_player.stream = sfx
		sfx_player.bus = "SFX"
		
		if random:
			sfx_player.set_pitch_scale(randf_range(0.75,2))
		sfx_player.play()
		
		sfx_player.finished.connect(sfx_player.queue_free)
		
func play_bgm(bgm: AudioStreamMP3):
	if bgm:
		bgm.loop = true
		if !bgm_player:
			bgm_player = AudioStreamPlayer.new()
			add_child(bgm_player)
			bgm_player.set_process_mode(3)
		bgm_player.stream = bgm
		bgm_player.bus = "Music"
		bgm_player.play()
