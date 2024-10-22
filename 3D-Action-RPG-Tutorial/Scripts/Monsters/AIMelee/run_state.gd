extends Node

var AIController: CharacterBody3D
var run: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	AIController = get_parent().get_parent()
	if AIController.attacking:
		await AIController.get_node("AnimationTree").animation_finished
		AIController.attacking = false
	else:
		run = false
		AIController.get_node("AnimationTree").get("parameters/playback").travel("Awaken")
		AIController.awakening = true
		await AIController.get_node("AnimationTree").animation_finished
	run = true
	AIController.awakening = false
	AIController.get_node("AnimationTree").get("parameters/playback").travel("Run")

func _physics_process(delta):
	if AIController and run:
		AIController.velocity.x = AIController.direction.x * AIController.speed
		AIController.velocity.z = AIController.direction.z * AIController.speed
		AIController.look_at(AIController.global_transform.origin + AIController.direction, Vector3(0, 1, 0))
