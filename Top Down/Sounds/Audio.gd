extends Node2D

onready var audio_stream = $AudioStreamPlayer

func play_audio(audio: String, volume: float = 1, pitch_scale: float = 1) -> void:
	var stream = load(audio)
	audio_stream.set_stream(stream)
	audio_stream.volume_db = volume
	audio_stream.pitch_scale = pitch_scale
	audio_stream.play()
