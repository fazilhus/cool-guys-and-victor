extends Node2D
class_name MoveButton

var movedata := MovementData.new()

signal move(movedata : MovementData)

func _on_button_button_down() -> void:
	move.emit(movedata)
