extends Node
class_name GameManager

@onready var player_manager : PlayerManager = $PlayerManager
@onready var map_manager : MapManager = $MapManager

var is_player_manager_initialized : bool = false
var is_map_manager_initialized : bool = false

func _ready() -> void:
	# map_manager.ready.connect(on_map_manager_ready)
	pass


func on_map_manager_ready() -> void:
	is_map_manager_initialized = true

func on_player_manager_ready() -> void:
	if is_map_manager_initialized:
		player_manager.initialize()
