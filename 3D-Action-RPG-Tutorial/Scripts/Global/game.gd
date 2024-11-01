extends Node

var items: Dictionary = {
	"long sword": preload("res://Scenes/player/GUI/inventory/long_sword.tres"),
	"iron sword": preload("res://Scenes/player/GUI/inventory/iron_sword.tres"),
	"small potion": preload("res://Scenes/player/GUI/inventory/small_potion.tres")
}

var gold: int = 100
var player_health: int  = 5
var player_health_max: int = 5
var right_hand_equipped: ItemData
var body_equipped: ItemData

var player_damage: int = 0
var player_defense: int = 0

var current_exp: int = 0
var exp_to_next_level: int = 100

var player_level: int = 1

var shopping : bool = false

func heal_player(health: int) -> void:
	pass
