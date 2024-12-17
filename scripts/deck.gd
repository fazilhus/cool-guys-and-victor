extends Control
class_name Deck
#track discard pile, track draw pile, if draw pile is zero, sort discard pile and that is a new draw pile
@onready var to_be_drawn : Node = %ToBeDrawn
@onready var discarded : Node = %Discarded

signal deck_is_empty

func _ready() -> void:
	var path = "res://scenes/cardFolder/"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while dir:
		var file_name = dir.get_next()
		if file_name == "":
			break
		if '.tscn.remap' in file_name:
			file_name = file_name.trim_suffix('.remap')
		var card_pkd = load(path + file_name)
		var card = card_pkd.instantiate()
		discarded.add_child(card)
		card.hide()
	dir.list_dir_end()
	shuffle_and_rebuild_deck()
	
func discard(to_be_discarded: Array[Node]) -> void:
	for card in to_be_discarded:
		discarded.add_child(card)

func shuffle_and_rebuild_deck():
	if discarded.get_children().size() == 0:
		emit_signal("deck_is_empty") #you lose?

	var new_deck = discarded.get_children()
	new_deck.shuffle()

	for card in new_deck:
		card.reparent(to_be_drawn)
	
func initialize_deck()->void:
	#generate cards to "discarded"
	#call shuffle_and_rebuild_deck()
	pass 

func draw_cards(amount : int) -> Array[Card]:
	var deck: Array[Card] = []

	var i = 0
	while i < amount and i < to_be_drawn.get_child_count():
		deck.append(to_be_drawn.get_child(i))
		# to_be_drawn.get_child(i).queue_free()
		i += 1

	return deck


func _on_play_card_area_area_exited(area:Area2D) -> void:
	var card = area.get_parent()
	card.playable = false
	# Replace with function body.

func _on_play_card_area_area_entered(area:Area2D) -> void:
	var card = area.get_parent()
	card.playable = true
	# Replace with function body.

	
