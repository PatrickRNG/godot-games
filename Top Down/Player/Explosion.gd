extends AnimatedSprite

func _ready():
	playing = true	

func _on_Explosion_animation_finished():
	queue_free()
