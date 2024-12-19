extends GutTest

var temp_card_scene = load("res://scenes/temp_card.tscn")
var card

func before_each():
	card = temp_card_scene.instantiate()

func after_each():
	card.queue_free()

func test_on_area_2d_mouse_entered():

	assert_eq(card.is_hovered, false)

	watch_signals(card)
	card._on_area_2d_mouse_entered()

	assert_has_signal(card, 'area_2d_mouse_entered')
	assert_signal_emitted(card, "area_2d_mouse_entered")

	assert_eq(card.is_hovered, true)	


func test_on_area_2d_mouse_exited():

	watch_signals(card)
	card._on_area_2d_mouse_exited()

	assert_eq(card.playable, false)
	assert_eq(card.is_hovered, false)