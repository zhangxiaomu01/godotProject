extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var speed: float = 1.0
@onready var state_controller = get_node("StateMachine")
@export var player: CharacterBody3D
var direction: Vector3
var awakening: bool = false
var attacking: bool = false
var dying: bool = false
var just_hit: bool = false

var health: int = 4
var damage: int = 2

func _ready():
	state_controller.change_state("Idle")
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if player:
		direction = (player.global_transform.origin - self.global_transform.origin).normalized()

	move_and_slide()


func _on_chase_player_detection_body_entered(body):
	if body.is_in_group("player") and !dying:
		state_controller.change_state("Run")
		


func _on_chase_player_detection_body_exited(body):
	if body.is_in_group("player") and !dying:
		state_controller.change_state("Idle")


func _on_attack_player_detection_body_entered(body):
	if body.is_in_group("player") and !dying:
		state_controller.change_state("Attack")


func _on_attack_player_detection_body_exited(body):
	if body.is_in_group("player") and !dying:
		state_controller.change_state("Run")


func _on_animation_tree_animation_finished(anim_name):
	if "Awaken" in anim_name:
		awakening = false
	elif "Attack" in anim_name:
		if (player in get_node("attack_player_detection").get_overlapping_bodies() and !dying):
			state_controller.change_state("Attack")
	elif "Death" in anim_name:
		die()

func die():
	self.queue_free()
