extends KinematicBody2D

enum {
	MOVE,
	ATTACK
}

enum {
	TIER1,
	TIER2
}

var state = MOVE
var velocity = Vector2.ZERO
var can_fire = true

onready var hurtbox = $Hurtbox
onready var turn_axis = $TurnAxis
onready var bullet_point = $TurnAxis/BulletPoint
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var audio_stream = $AudioStreamPlayer
onready var current_color = modulate
onready var stats = PlayerStats

export var speed = 80
export(int, "TIER 1", "TIER 2") var weapon_tier = TIER1 setget set_weapon_tier

var spell
var is_shooting = false

func _ready():
	Global.player = self
	PlayerStats.connect("no_health", self, "queue_free")
	get_player_stats()

func _process(delta):
	if Input.is_action_pressed("fire"):
		if can_fire:
			fire_projectile(delta)
			is_shooting = true
			animation_player.play("Attack")
	else:
		is_shooting = false


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

func move_state(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Player moving
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
		if !is_shooting:
			animation_player.play("Walk")
	# Player not moving
	else:
		velocity = Vector2.ZERO
		if !is_shooting:
			animation_player.play("Idle")
	velocity = move_and_slide(velocity)

func create_angle_spread(projectiles_quantity: int, angle_multiplier: int) -> Array:
	var projectiles_angles = [0]
	for i in range(1, projectiles_quantity * 2):
		var num = (float(i) / 10) * angle_multiplier
		projectiles_angles.append(num)
		projectiles_angles.append(num * -1)
	return projectiles_angles

func fire_projectile(_delta) -> void:
#	Create angles array for the spell spread
	for i in range(stats.projectiles):
		var spell_instance = spell.instance()
		var direction = sign(get_global_mouse_position().x - sprite.global_position.x)
		var projectiles_angles = create_angle_spread(stats.projectiles, spell_instance.projectile_angle)
		var angle = get_angle_to(get_global_mouse_position())
		sprite.flip_h = direction < 0
		angle += projectiles_angles[i]
		spell_instance.position = bullet_point.global_position
		spell_instance.rotation = angle
		get_tree().get_root().add_child(spell_instance)
	turn_axis.rotation = get_angle_to(get_global_mouse_position())
	bullet_point.position = Vector2(5, 0)
	$Audio.play_audio("res://Sounds/Player/shoot.wav", -10)
	can_fire = false
#	Wait some time before able to fire, (receive timeout signal after completion)
	yield(get_tree().create_timer(stats.fire_rate), "timeout")
	can_fire = true

func get_player_stats() -> void:
	spell = load("res://Spells/Spell_" + str(weapon_tier + 1) + ".tscn")
	var spell_instance = spell.instance()
	stats.damage = spell_instance.damage
	stats.fire_rate = spell_instance.fire_rate
	stats.pierce = spell_instance.pierce
	stats.projectiles = spell_instance.projectile

# Set new spell tier after it has been changed
func set_weapon_tier(value: int) -> void:
	weapon_tier = value
	get_player_stats()

func _on_Hurtbox_area_entered(area):
	if !hurtbox.invincible:
		PlayerStats.health -= area.get_parent().damage
		hurtbox.start_invincibility(0.5)
		modulate = Color(100, 100, 100)
		$Audio.play_audio("res://Sounds/Player/hit.wav", -10)
		yield(get_tree().create_timer(0.1), "timeout")
		modulate = current_color
