extends Node

@export var inventory_size = 24
@onready var grid = get_node("grid")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(inventory_size):
		var _slot = InventorySlot.new()
		_slot.init(ItemData.Type.MAIN, Vector2(32, 32))
		grid.add_child(_slot)
	add_item("long sword")
	add_item("small potion")

func add_item(item_name: String) -> void:
	var item = InventoryItem.new()
	item.init(Game.items[item_name])
	if item.data.stackable:
		for i in inventory_size:
			if grid.get_child(i).get_child_count() > 0:
				if grid.get_child(i).get_child(0).data == item.data:
					# update the counter
					grid.get_child(i).get_child(0).data.count += 1
					# if the label
					grid.get_child(i).get_child(0).get_child(0).set_text(str(grid.get_child(i).get_child(0).data.count))
					break
			else:
				grid.get_child(i).add_child(item)
				break
	else:
		for i in inventory_size:
			if grid.get_child(i).get_child_count() == 0:
				grid.get_child(i).add_child(item)
				break
	
