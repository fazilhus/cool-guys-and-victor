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
	pass
	
func should_load_level() -> void:
	map_manager.load_level()
	
	player_manager.initialize()
	player_manager.player.turn_phase_player_ended.connect(end_turn_phase_player)
	on_battle_start()

# should be connected to MapManager
func on_battle_start() -> void:
	battle_started.emit()
	process_turn_phase_start()

func on_batlle_end() -> void:
	battle_ended.emit()
	current_turn_phase = Enum.TurnPhase.None

func process_turn_phase_start() -> void:
	if current_turn_phase != Enum.TurnPhase.None && current_turn_phase != Enum.TurnPhase.End:
		print(
			"[ERROR] trying to start turn phase START out of order: ",
			Util.turn_phase_to_str(current_turn_phase))
		return
	
	current_turn_phase = Enum.TurnPhase.Start
	turn_phase_start.emit()
	# wait for start of the turn to be processed
	start_turn_phase_player()

func start_turn_phase_player() -> void:
	if current_turn_phase != Enum.TurnPhase.Start:
		print(
			"[ERROR] trying to start turn phase Player out of order: ",
			Util.turn_phase_to_str(current_turn_phase))
		return

	#Fill card hand from deck

	current_turn_phase = Enum.TurnPhase.Player
	turn_phase_player.emit()

func end_turn_phase_player() -> void:
	if current_turn_phase != Enum.TurnPhase.Player:
		print(
			"[ERROR] trying to end turn phase Player out of order: ",
			Util.turn_phase_to_str(current_turn_phase))
		return
	
	#Discard unused card

	start_turn_phase_enemy()

func start_turn_phase_enemy() -> void:
	if current_turn_phase != Enum.TurnPhase.Player:
		print(
			"[ERROR] trying to start turn phase Enemy out of order: ",
			Util.turn_phase_to_str(current_turn_phase))
		return

	current_turn_phase = Enum.TurnPhase.Enemy
	turn_phase_enemy.emit()

func end_turn_phase_enemy() -> void:
	if current_turn_phase != Enum.TurnPhase.Enemy:
		print(
			"[ERROR] trying to end turn phase Enemy out of order: ",
			Util.turn_phase_to_str(current_turn_phase))
		return

	process_turn_phase_end()

func process_turn_phase_end() -> void:
	if current_turn_phase != Enum.TurnPhase.Enemy:
		print(
			"[ERROR] trying to start turn phase End out of order: ",
			Util.turn_phase_to_str(current_turn_phase))
		return

	current_turn_phase = Enum.TurnPhase.End
	turn_phase_end.emit()
	# wait for end of the turn to be processed
	process_turn_phase_start()
