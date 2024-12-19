extends Control

signal switch_to_level

func _ready() -> void:
	switch_to_level.connect(Main.should_load_level)

func _on_play_pressed() -> void:
	switch_to_level.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
