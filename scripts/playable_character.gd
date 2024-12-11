extends Character
class_name PlayableCharacter

@onready var deck : Deck = %Deck
@onready var hand : Node2D = %HandUI
@onready var move_button_container : Node2D = %MoveButtonContainer
const MOVEBUTTON = preload("res://scenes/move_button.tscn")

signal turn_phase_player_ended

signal card_played(data: CardData)

func _ready() -> void:
	super()
	Main.battle_started.connect(on_battle_started)
	Main.battle_ended.connect(on_battle_ended)

	Main.turn_phase_start.connect(on_turn_phase_start)
	Main.turn_phase_player.connect(on_turn_phase_player_start)
	Main.turn_phase_enemy.connect(on_turn_phase_enemy)
	Main.turn_phase_enemy.connect(on_turn_phase_enemy)

	for child in hand.get_children():
		if child is HandUI:
			child.deck = deck


func on_battle_started() -> void:
	pass

func on_battle_ended() -> void:
	pass

func on_turn_phase_start() -> void:
	char_data.ap_data.current = char_data.ap_data.maximum

func on_turn_phase_player_start() -> void:
	var hand_ui: HandUI = hand.get_child(0)
	hand_ui.start_turn()
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
	move_button_container.global_position = global_position
	
	var movements = calc_movement(move)
	for i in movements.size():
		var new_pos = Vector2i.ZERO
		for movement in movements[i].step:
			new_pos += movement

	
		if is_movement_legal(movements[i], global_position / 16):
			var move_button = MOVEBUTTON.instantiate()
			move_button_container.add_child(move_button)
			move_button.global_position = global_position + Vector2(16 * new_pos)
			move_button.move.connect(move_character)
			move_button.movedata = movements[i]

func get_deck():
	return deck

func calc_movement(base_move : MovementData):
	var end_points : Array[MovementData]

	var dirs = [Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)]

	for dir in dirs:
		var move : MovementData = MovementData.new()
		for data in base_move.step:
			move.step.push_back(data * dir)
		end_points.push_back(move)
			

	#breakpoint
	return end_points
	
func move_character(movedata : MovementData) -> void:
	var tween = create_tween()
	var new_pos = Vector2i.ZERO
	for movement in movedata.step:
		new_pos += 16*movement
		tween.tween_property(self, "position", self.position + Vector2(new_pos), 0.4)
	for button in move_button_container.get_children():
		button.queue_free()
	print("hehe i moved")