extends Node2D
class_name Character

@onready var stats_comp = %Stats

signal character_health_reached_zero

func _ready() -> void:
	stats_comp.health_reached_zero.connect(on_health_reached_zero())

func take_damage(dmg: int) -> void:
	stats_comp.take_damage(dmg)

func on_health_reached_zero():
	character_health_reached_zero.emit()