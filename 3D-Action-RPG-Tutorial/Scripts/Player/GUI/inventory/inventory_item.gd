class_name InventoryItem extends TextureRect

@export var data: ItemData

func _ready():
	if data:
		expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture = data.item_texture
		tooltip_text = "Name: %s \n %s \n Stats: %s Damage, %s Health, %s Defense" % [data.item_name,data.description, data.item_damage, data.item_health, data.item_defense]
		if data.stackable:
			var label = Label.new()
			label.text = str(data.count)
			label.position = Vector2(24,16)
			add_child(label)

func init(d: ItemData) -> void:
	data = d

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(make_drag_preview(at_position))
	return self

func make_drag_preview(at_position: Vector2) -> Control:
	var t := TextureRect.new()
	t.texture = self.texture
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.set_custom_minimum_size(self.get_size())
	t.modulate.a = 0.5
	t.position = Vector2(-at_position)
	var c := Control.new()
	c.add_child(t)
	return c
