extends Node
class_name GameManager

@onready var player_manager : PlayerManager = $PlayerManager
@onready var map_manager : MapManager = $MapManager

signal battle_started
signal battle_ended

signal turn_phase_start
signal turn_phase_player
signal turn_phase_enemy
signal turn_phase_end

var is_player_manager_initialized : bool = false
var is_map_manager_initialized : bool = false

var current_turn_phase : Enum.TurnPhase = Enum.TurnPhase.None

func _ready() -> void:
	player_manager.initialize()

# should be connected to MapManager
func on_battle_start() -> void:
	battle_started.emit()

func on_batlle_end() -> void:
	battle_ended.emit()
	current_turn_phase = Enum.TurnPhase.None

func process_turn_phase_start() -> void:
	current_turn_phase = Enum.TurnPhase.Start
	turn_phase_start.emit()
	# wait for start of the turn to be processed
	start_turn_phase_player()

func start_turn_phase_player() -> void:
	current_turn_phase = Enum.TurnPhase.Player
	turn_phase_player.emit()

func end_turn_phase_player() -> void:
	start_turn_phase_enemy()

func start_turn_phase_enemy() -> void:
	current_turn_phase = Enum.TurnPhase.Enemy
	turn_phase_enemy.emit()

func end_turn_phase_enemy() -> void:
	pass

func process_turn_phase_end() -> void:
	current_turn_phase = Enum.TurnPhase.End
	turn_phase_end.emit()
	# wait for end of the turn to be processed
	process_turn_phase_start()