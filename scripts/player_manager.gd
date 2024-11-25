extends Node
class_name PlayerManager

@export var playable_character_packed : PackedScene

var player : PlayableCharacter

signal player_manager_ready

func _ready() -> void:
	player = playable_character_packed.instantiate()
	player_manager_ready.emit()

func initialize() -> void:
	breakpoint
	var game : GameManager = get_parent()
	var spawn = game.map_manager.get_spawn_point()
	add_child(player)
	player.global_position = spawn.global_position