extends RigidBody3D

@export_range(750, 3000) var Thrust: float = 1000.0
@export var torque_thrust: float = 200.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * Thrust)
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0,0.0, torque_thrust * delta))
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0,0.0, -torque_thrust * delta))


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Goal"):
		pass
	if body.is_in_group("Hazard"):
		pass
