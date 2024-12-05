extends Node2D
class_name Level

@onready var spawn_point : Node2D = %SpawnPoint

#level has tile array? tile class has coordinates? walkable or unwalkable tiles. 

func get_spawn_point() -> Node2D:
	if spawn_point != null:
		return spawn_point
	
	print("[ERROR] spawn point is missing in level ", name)
	return null
