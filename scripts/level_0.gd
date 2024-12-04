extends Node2D
class_name Level

@onready var spawn_point : Node2D = %SpawnPoint

@onready var base_layer : TileMapLayer = %BaseLayer

func get_spawn_point() -> Node2D:
	if spawn_point != null:
		return spawn_point
	
	print("[ERROR] spawn point is missing in level ", name)
	return null

func is_traversable_at(pos: Vector2i) -> bool:
	var data = base_layer.get_cell_tile_data(pos)
	return data.get_custom_data("Traversible")
