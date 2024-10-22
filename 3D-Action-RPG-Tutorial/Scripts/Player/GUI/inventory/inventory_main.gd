extends Node

@export var inventory_size = 24
@onready var grid = get_node("grid")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(inventory_size):
		var _slot = InventorySlot.new()
		_slot.init(ItemData.Type.MAIN, Vector2(32, 32))
		grid.add_child(_slot)
