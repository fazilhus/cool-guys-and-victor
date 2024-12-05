extends Node
class_name MapManager

@export var menu_packed : PackedScene
@export var level_packed : PackedScene

#some coordinate var?


var menu = null
var level : Level = null

func _ready() -> void:
	menu = menu_packed.instantiate()
	add_child(menu)
	
func load_level() -> void:
	menu.queue_free()
	level = level_packed.instantiate()
	add_child(level)

func get_spawn_point() -> Node2D:
	if level != null:
		return level.get_spawn_point()
	
	return null
