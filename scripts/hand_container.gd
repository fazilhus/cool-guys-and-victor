extends HBoxContainer
class_name HandUI

@export var hand_fan : Curve
@export var fan_hight : Curve
@export var card_rotation : Curve

const HAND_WIDTH = 160.0
const HAND_HIGHT = 24.0
const CARD_ROTATION = 10
const HAND_SIZE = 5

var highest_card_z

const CARD = preload("res://scenes/temp_card.tscn")

var deck : Deck

func fill_hand()->void:
	var new_hand = deck.draw_cards(HAND_SIZE)
	var i : int = 0
	for card in new_hand:
		add_child(card)
		card.z_index = i
		highest_card_z = i
		card.area_2d_mouse_entered.connect(highlight_card)
		i += 1

	# for _x in 5:
	# 	var card = CARD.instantiate()
	# 	add_child(card)
	# 	card.z_index = _x
	# 	highest_card_z = _x
	# 	card.area_2d_mouse_entered.connect(highlight_card)

func update_spread()->void:
	var hand = get_children()
	var hand_ratio = 0.5

	for card in hand:
		if hand.size()>1:
			hand_ratio = float(card.get_index())/float(hand.size()-1)

		var destination := get_global_transform()
		destination.origin.x += hand_fan.sample(hand_ratio)*HAND_WIDTH
		destination.origin += fan_hight.sample(hand_ratio)*HAND_HIGHT*Vector2.UP
		card.global_transform = destination
		card.position.x = destination.origin.x + get_viewport().get_visible_rect().size.x / 2
		card.position.y = destination.origin.y + get_viewport().get_visible_rect().size.y - 100
		#print(card_rotation.sample(hand_ratio))
		card.rotate(deg_to_rad(card_rotation.sample(hand_ratio)*(-CARD_ROTATION)))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#const card := preload("res://scenes/temp_card.")
	Main.turn_phase_start.connect(start_turn)
	Main.turn_phase_start.connect(end_turn)

	deck = Main.player_manager.player.get_deck()
	#fill_hand()
	update_spread()

func get_top_card():
	var space_state = get_world_2d().direct_space_state
	#var query = PhysicsRayQueryParameters2D.create(Vector2(0, 0), get_viewport().get_mouse_position(), 2)
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = 2
	var result = space_state.intersect_point(query)

	if result.size() > 0:
		var card = result[0].collider.get_parent()
		for area in result:
			if area.collider.get_parent().z_index > card.z_index:
				card = area.collider.get_parent()
		#print(result[0].collider)
		#print(result[0].collider.get_parent())
		#return result[0].collider.get_parent()
		return card
	return null

# Låt stå!!!!!!
# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	for card: Card in get_children():
# 		if card.is_hovered and !card.animated:
# 			var top = get_top_card()
# 			if card == top:
# 				card.should_highlight_itself()	
# 		elif card.is_hovered and card.animated:
# 			card.should_unhighlight_itself()
	

func _input(event):
	if event == InputEventMouseMotion:
		for card: Card in get_children():
			if card.is_hovered and !card.animated:
				var top = get_top_card()
				if card == top:
					card.should_highlight_itself()	
			elif card.is_hovered and card.animated:
				card.should_unhighlight_itself()

	if event == InputEventMouseButton and event.is_pressed() and event.button_mask == 1:
		var top_card = get_top_card()
		if top_card != null:
			top_card.is_dragged = true
			top_card.position = get_global_mouse_position()
			
	if event == InputEventMouseButton and event.is_released() and event.button_mask == 1:
		for card: Card in get_children():
			if card.is_dragged == true and card.playable:
				#do card shit
				card.queue_free()
				update_spread()
				
			

# func _unhandled_input(event: InputEvent) -> void:
# 	if event.is_pressed() and event.button_mask == 1:
# 		var card = CARD.instantiate()
# 		highest_card_z += 1
# 		card.z_index = highest_card_z
# 		add_child(card)
# 		update_spread()
# 	if event == InputEventMouseMotion:
# 		get_top_card()
		
func highlight_card() -> void:
	# for card: Card in get_children():
	# 	card.should_unhighlight_itself()
	# var card = get_top_card()
	# if card != null:
	# 	if !card.animated:
	# 		card.should_highlight_itself()
	pass

func discard_hand()->void:
	var current_hand = get_children()
	deck.discard(get_children())
	for card in current_hand:
		card.queue_free()


func start_turn()->void:
	fill_hand()
	update_spread()
	pass

func end_turn()->void:
	discard_hand()
	pass
