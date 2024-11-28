extends Control
class_name Deck
#track discard pile, track draw pile, if draw pile is zero, sort discard pile and that is a new draw pile
@onready var to_be_drawn : Node = %ToBeDrawn
@onready var discarded : Node = %Discarded

signal deck_is_empty

func _ready() -> void:
	pass # Replace with function body.

func discard(to_be_discarded: Array[Node]) -> void:
	for card in to_be_discarded:
		discarded.add_child(card)

func shuffle_and_rebuild_deck():
	if discarded.get_children().size() == 0:
		emit_signal("deck_is_empty") #you lose?

	var new_deck = discarded.get_children()
	new_deck.shuffle()

	for card in new_deck:
		to_be_drawn.add_child(card)
	
func initialize_deck()->void:
	#generate cards to "discarded"
	#call shuffle_and_rebuild_deck()
	pass 

func draw_cards(amount : int) -> Array[Card]:
	var deck = to_be_drawn.get_children()

	if amount > deck.size():
		return deck

	var drawn : Array[Card]
	for _x in amount:
		drawn.append(deck[0])
		to_be_drawn.get_child(0).queue_free()

	return drawn

























# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Left mouse button was pressed!")
