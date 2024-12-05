extends Character
class_name PlayableCharacter

@onready var deck : Deck = %Deck
@onready var hand : Node2D = %HandUI

signal turn_phase_player_ended

signal card_played(data: CardData)

func _ready() -> void:
	Main.battle_started.connect(on_battle_started)
	Main.battle_ended.connect(on_battle_ended)

	Main.turn_phase_start.connect(on_turn_phase_start)
	Main.turn_phase_player.connect(on_turn_phase_player_start)
	Main.turn_phase_enemy.connect(on_turn_phase_enemy)
	Main.turn_phase_enemy.connect(on_turn_phase_enemy)

func on_battle_started() -> void:
	pass

func on_battle_ended() -> void:
	pass

func on_turn_phase_start() -> void:
	#deck.draw_cards()
	char_data.ap_data.current = char_data.ap_data.maximum

func on_turn_phase_player_start() -> void:
	pass

func end_turn_phase_player() -> void:
	turn_phase_player_ended.emit()

func on_turn_phase_enemy() -> void:
	pass

func on_turn_phase_end() -> void:
	pass

func try_play_card(card: CardData) -> bool:
	if card.cost > char_data.ap_data.current:
		return false
	
	if !is_card_play_legal(card):
		return false
	
	char_data.ap_data.current -= card.cost
	play_card(card)
	card_played.emit(card)
	return true

func play_card(card: CardData) -> void:
	for action in card.actions:
		var move: MovementData = action
		if move:
			move_player(move)
		else:
			continue

func move_player(move: MovementData) -> void:
	var new_pos = Vector2i.ZERO
	for movement in move.step:
		new_pos += movement
	
	global_position.x += 16 * new_pos.x
	global_position.y += 16 * new_pos.y

func get_deck():
	return deck
