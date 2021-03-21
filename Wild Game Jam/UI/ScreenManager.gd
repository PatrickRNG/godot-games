extends CanvasLayer

func quit_game():
	get_tree().quit()

func play_sound(audioPlayer: AudioStreamPlayer):
	audioPlayer.playing = true
