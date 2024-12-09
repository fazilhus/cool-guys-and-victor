extends Character
class_name PlayableCharacter

@onready var deck : Deck = %Deck
@onready var hand : Node2D = %HandUI
const MOVEBUTTON = preload("res://scenes/move_button.tscn")

signal turn_phase_player_ended

signal card_played(data: CardData)

func _ready() -> void:
	Main.battle_started.connect(on_battle_started)
	Main.battle_ended.connect(on_battle_ended)

	Main.turn_phase_start.connect(on_turn_phase_start)
	Main.turn_phase_player.connect(on_turn_phase_player_start)
	Main.turn_phase_enemy.connect(on_turn_phase_enemy)
	Main.turn_phase_enemy.connect(on_turn_phase_enemy)

	var move := MovementData.new()
	move.step.push_back(Vector2i(1,0))
	move.step.push_back(Vector2i(1,0))
	move.step.push_back(Vector2i(1,0))
	move.step.push_back(Vector2i(0,1))

	move_player(move)

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
	var new_pos2 = Vector2i.ZERO
	var new_pos3 = Vector2i.ZERO
	var new_pos4 = Vector2i.ZERO
	var movements = calc_movement(move)

	for movement in movements[0].step:
		new_pos += movement
	
	for movement in movements[1].step:
		new_pos2 += movement

	for movement in movements[2].step:
		new_pos3 += movement
	
	for movement in movements[3].step:
		new_pos4 += movement
	# for movement in move.step:
	# 	new_pos += movement

	var move_button = MOVEBUTTON.instantiate()
	add_child(move_button)
	move_button.global_position = global_position + Vector2(16*new_pos)

	var move_button2 = MOVEBUTTON.instantiate()
	add_child(move_button2)
	move_button2.global_position = global_position + Vector2(16*new_pos2)

	var move_button3 = MOVEBUTTON.instantiate()
	add_child(move_button3)
	move_button3.global_position = global_position + Vector2(16*new_pos3)

	var move_button4 = MOVEBUTTON.instantiate()
	add_child(move_button4)
	move_button4.global_position = global_position + Vector2(16*new_pos4)
	
	# global_position.x += 16 * new_pos.x
	# global_position.y += 16 * new_pos.y

func get_deck():
	return deck

func calc_movement(base_move : MovementData):
	var end_points : Array[MovementData]
	var m2 := MovementData.new()
	var m3 := MovementData.new()
	var m4 := MovementData.new()

	for data in base_move.step:
		m2.step.push_back(data)
		m3.step.push_back(Vector2i(data.y, data.x))

	var i = 0
	for data in m2.step:
		data.x *= -1
		data.y *= -1
		m2.step[i] = data

		m4.step.push_back(Vector2i(data.y, data.x))
		i +=1

	end_points.push_back(base_move)
	end_points.push_back(m2)
	end_points.push_back(m3)
	end_points.push_back(m4)
	#breakpoint
	return end_points
	