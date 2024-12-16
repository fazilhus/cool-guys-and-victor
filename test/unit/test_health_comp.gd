extends GutTest

@onready var comp = preload("res://scripts/health_component.gd") # Update the path

var comp_d

func before_each():
	#comp_d = double(comp).new()
	comp_d = comp.new()
	
func after_each():
	comp_d.queue_free()

func test_health_comp_init():
	var data = StatData.new()
	data.minimum = 0
	data.maximum = 10
	data.current = 10
	comp_d.init(data)
	assert_eq(comp_d.minimum, 0.0)
	assert_eq(comp_d.maximum, 10.0)
	assert_eq(comp_d.current, 10.0)

func test_health_comp_take_damage_non_lethal():
	var data = StatData.new()
	data.minimum = 0
	data.maximum = 10
	data.current = 10
	
	comp_d.init(data)
	
	watch_signals(comp_d)
	comp_d.take_damage(5)
	
	assert_has_signal(comp_d, 'damage_taken')
	assert_has_signal(comp_d, 'health_reached_min')
	assert_signal_emitted(comp_d, 'damage_taken')
	assert_signal_not_emitted(comp_d, 'health_reached_min')

func test_health_comp_take_damage_lethal():
	var data = StatData.new()
	data.minimum = 0
	data.maximum = 10
	data.current = 10
	
	comp_d.init(data)
	
	watch_signals(comp_d)
	comp_d.take_damage(15)
	
	assert_has_signal(comp_d, 'damage_taken')
	assert_has_signal(comp_d, 'health_reached_min')
	assert_signal_emitted(comp_d, 'damage_taken')
	assert_signal_emitted(comp_d, 'health_reached_min')
