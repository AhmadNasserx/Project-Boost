extends RigidBody3D

@export_range(750, 3000) var Thrust: float = 1000.0
@export var torque_thrust: float = 100.0

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $rightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $leftBoosterParticles2


var is_transitioning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * Thrust)
		booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
			rocket_audio.stop()
			booster_particles.emitting = false
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0,0.0, torque_thrust * delta))
		right_booster_particles.emitting = true
	else:
		right_booster_particles.emitting = false
	if Input.is_action_pressed("rotate_right"):
		left_booster_particles.emitting = true
		apply_torque(Vector3(0.0,0.0, -torque_thrust * delta))
	else:
		left_booster_particles.emitting = false


func _on_body_entered(body: Node) -> void:
	if !is_transitioning:
		if body.is_in_group("Goal"):
			complete_level(body.file_path)
		if body.is_in_group("Hazard"):
			crash_sequence()


func crash_sequence() -> void:
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)


func complete_level(next_level_file: String) -> void:
	success_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
