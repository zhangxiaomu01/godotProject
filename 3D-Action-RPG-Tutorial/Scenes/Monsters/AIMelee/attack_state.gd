extends Node

var AIController

# Called when the node enters the scene tree for the first time.
func _ready():
	AIController = get_parent().get_parent()
	if AIController.awakening:
		await AIController.get_node("AnimationTree").animation_finished
	AIController.attacking = true
	
	AIController.get_node("AnimationTree").get("parameters/playback").travel("Attack")
	AIController.look_at(AIController.global_transform.origin + AIController.direction, Vector3(0, 1, 0))

func _physics_process(delta):
	if AIController:
		AIController.velocity.x = 0
		AIController.velocity.z = 0
