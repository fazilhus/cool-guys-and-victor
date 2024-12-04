extends Node
class_name PlayerManager

@export var playable_character_packed : PackedScene

var player : PlayableCharacter

func _ready() -> void:
	player = playable_character_packed.instantiate()

func initialize() -> void:
	var game : GameManager = get_parent()
	var spawn = game.map_manager.get_spawn_point()
	add_child(player)
	player.global_position = spawn.global_position

func get_deck() -> Deck:
	return null
