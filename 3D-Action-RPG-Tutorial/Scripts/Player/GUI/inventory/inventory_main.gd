extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var _slot = InventorySlot.new()
	add_child(_slot)
