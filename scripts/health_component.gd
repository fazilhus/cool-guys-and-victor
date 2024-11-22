extends Node
class_name StatsComponent

var current : float
var _min : float
var _max : float

signal damage_taken
signal health_reached_min

func init(health_stat: StatData):
	current = health_stat.current
	_min = health_stat._min
	_max = health_stat._max

func take_damage(dmg: int) -> void:
	current -= dmg
	damage_taken.emit()
	if current < _min:
		current = _min
		health_reached_min.emit()