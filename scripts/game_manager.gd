extends Node
class_name GameManager

@onready var player_manager : PlayerManager = $PlayerManager
@onready var map_manager : MapManager = $MapManager

var is_player_manager_initialized : bool = false
var is_map_manager_initialized : bool = false

func _ready() -> void:
	player_manager.initialize()
