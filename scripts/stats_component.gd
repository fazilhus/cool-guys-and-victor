extends Node
class_name stats_component

@export var health: int = 0

signal damage_taken
signal health_reached_zero

func take_damage(dmg: int) -> void:
	health -= dmg
	damage_taken.emit()
	if health < 0:
		health = 0
		health_reached_zero.emit()