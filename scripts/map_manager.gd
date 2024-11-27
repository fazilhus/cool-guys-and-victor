extends Node
class_name MapManager

@export var level_packed : PackedScene

var level : Level

func _ready() -> void:
	level = level_packed.instantiate()
	add_child(level)

func get_spawn_point() -> Node2D:
	if level != null:
		return level.get_spawn_point()
	
	return null
