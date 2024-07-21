extends Node3D

var camroot_h: float = 0
var camroot_v: float = 0

var h_senstivity: float = 0.01
var v_senstivity: float = 0.01

var h_acceleration: float = 10.0
var v_acceleration: float = 10.0

@export var cam_v_max: int = 75
@export var cam_v_min: int = -55

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camroot_h += -event.relative.x * h_senstivity
		camroot_v += event.relative.y * v_senstivity

func _physics_process(delta: float) -> void:
	camroot_v = clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	get_node("CameraH").rotation.y = lerpf(get_node("CameraH").rotation.y, camroot_h, delta * h_acceleration)
	get_node("CameraH/CameraV").rotation.x = lerpf(
		get_node("CameraH/CameraV").rotation.x, camroot_v, delta * v_acceleration)
