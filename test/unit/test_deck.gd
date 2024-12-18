extends GutTest

var deck_scene = load("res://scenes/deck.tscn")
var deck
const CARD = preload("res://scenes/temp_card.tscn")
var to_be_discarded

func before_each():
	deck = deck_scene.instantiate()
	add_child(deck)

func after_each():
	deck.queue_free()
	# if to_be_discarded != null:
	# 	for card in to_be_discarded:
	# 		card.queue_free()

func create_cards(number_of_cards : int)-> Array[Card]:
	var array_of_cards : Array[Card]
	for i in number_of_cards:
		var card = CARD.instantiate()
		array_of_cards.push_back(card)

	return array_of_cards


func test_discard():
	var nr_card : int = 3
	#var discarded = deck.get_child(3)
	#deck.discarded = discarded
	to_be_discarded = create_cards(nr_card)
	assert_eq(to_be_discarded.size(), nr_card)

	assert_eq(deck.discarded.get_child_count(), 0)
	deck.discard(to_be_discarded)
	assert_eq(deck.discarded.get_child_count() , nr_card)


func test_shuffle_and_rebuild_deck():
	watch_signals(deck)

	deck.shuffle_and_rebuild_deck()
	assert_signal_emitted(deck, "deck_is_empty")

	assert_eq(deck.to_be_drawn.get_child_count(), 5)
	assert_eq(deck.discarded.get_child_count(), 0)

	
	

func test_draw_cards():
	var cards_to_draw = 3
	assert_eq(deck.to_be_drawn.get_child_count(), 5)

	var returned_cards = deck.draw_cards(cards_to_draw)
	assert_eq(returned_cards.size(),cards_to_draw)
	after_each()
	before_each()
	assert_eq(deck.to_be_drawn.get_child_count(), 5)
	returned_cards = deck.draw_cards(6)
	assert_eq(returned_cards.size(),5)



func test_on_play_card_area_area_exited():
	var card = CARD.instantiate()
	add_child(card)
	assert_eq(card.playable, false)
	deck._on_play_card_area_area_exited(card.area)
	assert_eq(card.playable, false)
	card.queue_free()


func test_on_play_card_area_area_entered():
	var card = CARD.instantiate()
	add_child(card)
	assert_eq(card.playable, false)
	deck._on_play_card_area_area_entered(card.area)
	assert_eq(card.playable, true)
	card.queue_free()
	

	
