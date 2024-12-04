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

func is_card_play_legal(card: CardData) -> bool:
	var pos = global_position
	for action in card.actions:
		match action:
			MovementData:
				if !is_movement_legal(action as MovementData, pos):
					return false
			_:
				pass
	return true

func is_movement_legal(data: MovementData, pos: Vector2) -> bool:
	var mod = Vector2i.ZERO
	for movement in data.shape:
		if !Main.map_manager.level.is_traversable_at(pos + mod):
			return false
		
		mod += movement
	return true