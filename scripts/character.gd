extends Node2D
class_name Character

@export var char_data : CharacterData

@onready var health_comp = %HealthComp

signal character_health_reached_min

func _ready() -> void:
	health_comp.init(char_data.health_data)
	health_comp.health_reached_min.connect(on_health_reached_min())

func take_damage(dmg: int) -> void:
	health_comp.take_damage(dmg)

func on_health_reached_min():
	character_health_reached_min.emit()