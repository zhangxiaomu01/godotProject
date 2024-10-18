extends CanvasLayer

func _ready():
	get_node("container").hide()

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused =!get_tree().paused
		get_node("container").visible = get_tree().paused
		match get_tree().paused:
			true:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			false:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_inventory_button_pressed():
	get_node("container/VBoxContainer/inventory_button").disabled = true
	get_node("container/VBoxContainer/profile_button").disabled = false
	get_node("container/inventory").show()
	get_node("container/profile").hide()

func _on_profile_button_pressed():
	get_node("container/VBoxContainer/inventory_button").disabled = false
	get_node("container/VBoxContainer/profile_button").disabled = true
	get_node("container/inventory").hide()
	get_node("container/profile").show()
