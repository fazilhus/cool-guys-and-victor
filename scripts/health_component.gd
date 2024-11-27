extends Node
class_name StatsComponent

var current : float
var minimum : float
var maximum : float

signal damage_taken
signal health_reached_min

func init(health_stat: StatData):
	current = health_stat.current
	minimum = health_stat.minimum
	maximum = health_stat.maximum

func take_damage(dmg: int) -> void:
	current -= dmg
	damage_taken.emit()
	if current < minimum:
		current = minimum
		health_reached_min.emit()