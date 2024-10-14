extends CharacterBody3D

@export var gravity: float = 9.8
@export var jump_force: int = 9
@export var walk_speed: int = 3
@export var run_speed: int = 10

# animation node names
var idle_node_name: String = "Idle"
var walk_node_name: String = "Walk"
var run_node_name: String = "Run"
var jump_node_name: String = "Jump"
var attack1_node_name: String = "Attack1"
var death_node_name: String = "Death"

# State machine conditions
var is_attacking: bool = false
var is_walking: bool = false
var is_running: bool = false
var is_dying: bool = false

# physics values
var direction: Vector3
var horizontal_velocity: Vector3
var vertical_velocity: Vector3
var aim_turn: float
var movement: Vector3
var movement_speed: int
var angular_acceleration: int
var acceleration: int
var just_hit: bool

# health and damage values
var health: int = 5
var max_health: int = 5
var player_damage: int = 1

@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")
@onready var camrot_h = get_node("CameraRoot/CameraH")
@onready var player_mesh = get_node("Knight")

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015
	if event.is_action_pressed("aim"):
		direction = camrot_h.global_transform.basis.z;

func _physics_process(delta: float) -> void:
	var on_floor: bool = is_on_floor()
	if !is_dying:
		if !on_floor:
			vertical_velocity += Vector3.DOWN * gravity * 2 *delta
		else:
			#vertical_velocity += Vector3.DOWN * gravity / 10
			vertical_velocity = Vector3.ZERO
		
		attack1()
		if on_floor and Input.is_action_just_pressed("jump") and !is_attacking:
			vertical_velocity = Vector3.UP * jump_force
		angular_acceleration = 10
		movement_speed = 0
		acceleration = 15
		if (attack1_node_name in playback.get_current_node()):
			is_attacking = true
		else:
			is_attacking = false
			
		var h_rot = camrot_h.global_transform.basis.get_euler().y
		if (Input.is_action_pressed("forward") 
			|| Input.is_action_pressed("backward")
			|| Input.is_action_pressed("left")
			|| Input.is_action_pressed("right") ):
				direction = Vector3(
					Input.get_action_strength("left") - Input.get_action_strength("right"),
					0,
					Input.get_action_strength("forward") - Input.get_action_strength("backward")
				)
				direction = direction.rotated(Vector3.UP, h_rot).normalized()
				if Input.is_action_pressed("sprint") and is_walking:
					movement_speed = run_speed
					is_running = true
				else:
					movement_speed = walk_speed
					is_walking = true
		else:
			is_walking = false
			is_running = false
			
		if Input.is_action_pressed("aim"):
			player_mesh.rotation.y = lerp_angle(
				player_mesh.rotation.y, camrot_h.rotation.y, delta * angular_acceleration
			)
		else:
			player_mesh.rotation.y = lerp_angle(
				player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration
			)
			
		if is_attacking:
			horizontal_velocity = horizontal_velocity.lerp(
				direction.normalized() * 0.1, acceleration * delta
			)
		else:
			horizontal_velocity = horizontal_velocity.lerp(
				direction.normalized() * movement_speed, acceleration * delta
			)
		velocity.x = horizontal_velocity.x + vertical_velocity.x
		velocity.y = vertical_velocity.y
		velocity.z = horizontal_velocity.z + vertical_velocity.z
		move_and_slide()
	animation_tree["parameters/conditions/IsOnFloor"] = on_floor
	animation_tree["parameters/conditions/IsInAir"] = !on_floor
	animation_tree["parameters/conditions/IsWalking"] = is_walking
	animation_tree["parameters/conditions/IsNotWalking"] = !is_walking
	animation_tree["parameters/conditions/IsRunning"] = is_running
	animation_tree["parameters/conditions/IsNotRunning"] = !is_running
	animation_tree["parameters/conditions/IsDying"] = is_dying


func attack1():
	if (idle_node_name in playback.get_current_node() 
		or walk_node_name in playback.get_current_node()
		or run_node_name in playback.get_current_node()):
			if (Input.is_action_just_pressed("attack")):
				if !is_attacking:
					playback.travel(attack1_node_name)
			
func take_hit(damage: int):
	if !just_hit:
		just_hit = true
		get_node("just_hit_timer").start()
		health -= damage
		if health <= 0:
			is_dying = true
			playback.travel(death_node_name)
		
		#knockback
		var tween = create_tween()
		tween.tween_property(
			self, "global_position", global_position - direction * 0.5, 0.2)

func _on_damage_detector_body_entered(body:Node3D):
	if body.is_in_group("monster") and is_attacking:
		body.take_hit(player_damage)


func _on_animation_tree_animation_finished(anim_name:StringName):
	if "Death" in anim_name:
		self.queue_free()


func _on_just_hit_timer_timeout():
	just_hit = false
