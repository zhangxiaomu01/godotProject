extends Node

var AIController

# Called when the node enters the scene tree for the first time.
func _ready():
	AIController = get_parent().get_parent()
