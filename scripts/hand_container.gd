extends HBoxContainer
class_name HandUI

@export var hand_fan : Curve
@export var fan_hight : Curve
@export var card_rotation : Curve

const HAND_WIDTH = 130.0
const HAND_HIGHT = 24.0
const CARD_ROTATION = 10
const HAND_SIZE = 5

var highest_card_z

const CARD = preload("res://scenes/temp_card.tscn")


var deck : Deck
var is_card_draged : bool = false

func fill_hand()->void:
	var new_hand = deck.draw_cards(HAND_SIZE)
	var i : int = 0
	for card in new_hand:
		card.reparent(self)
		card.z_index = i
		highest_card_z = i
		card.area_2d_mouse_entered.connect(highlight_card)
		card.visible = true
		i += 1

func update_spread()->void:
	var hand = get_children()
	var hand_ratio = 0

	for card in hand:
		match hand.size():
			1:
				hand_ratio = 0.5
			2:
				hand_ratio += 0.3
			_:
				hand_ratio = float(card.get_index())/float(hand.size()-1)

		var destination := get_global_transform()
		destination.origin.x += hand_fan.sample(hand_ratio)*HAND_WIDTH
		destination.origin += fan_hight.sample(hand_ratio)*HAND_HIGHT*Vector2.UP
		card.global_transform = destination
		card.global_position.x = destination.origin.x + get_viewport().get_visible_rect().size.x / 2
		card.global_position.y = destination.origin.y + get_viewport().get_visible_rect().size.y -50
		card.rotate(deg_to_rad(card_rotation.sample(hand_ratio)*(-CARD_ROTATION)))
		card.hand_position = card.position
		card.card_rotation = card.rotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck = Main.player_manager.player.get_deck()
	Main.player_manager.player.turn_phase_player_ended.connect(end_turn)

	update_spread()

	

func get_top_card():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = 2
	var result = space_state.intersect_point(query)

	if result.size() > 0:
		var card = result[0].collider.get_parent()
		if card is not Card:
			return null
		for area in result:
			if area.collider.get_parent().z_index > card.z_index:
				card = area.collider.get_parent()
		return card
	return null

# Låt stå!!!!!!
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_card_draged == true:
		for card: Card in get_children():
			if card.is_dragged == true:
				card.global_position = get_global_mouse_position()	
	

func _input(event):
	if event is InputEventMouseMotion:
		for card: Card in get_children():
			if card.is_hovered and !card.animated:
				var top = get_top_card()
				if card == top:
					card.should_highlight_itself()	
			elif card.is_hovered and card.animated:
				card.should_unhighlight_itself()

	if event is InputEventMouseButton and event.is_pressed() and event.button_mask == 1:
		var top_card = get_top_card()
		if top_card != null and top_card is Card:
			top_card.is_dragged = true
			is_card_draged = true
			top_card.rotation = 0
			
	if event is InputEventMouseButton and event.is_released() and event.button_mask == 0:
		is_card_draged = false
		for card: Card in get_children():
			if card.is_dragged == true and card.playable:
				if Main.player_manager.player.try_play_card(card.data):
					remove_child(card)
					update_spread()
					continue
			if card.is_dragged == true:
				var tween = create_tween()
				tween.set_parallel(true)
				tween.tween_property(card, "position", card.hand_position, 0.4)
				tween.tween_property(card, "rotation", card.card_rotation, 0.5)

			card.is_dragged = false
		
func highlight_card() -> void:
	pass

func discard_hand()->void:
	var current_hand = get_children()
	deck.discard(get_children())
	for card in current_hand:
		card.queue_free()


func start_turn()->void:
	fill_hand()
	update_spread()

func end_turn()->void:
	discard_hand()
