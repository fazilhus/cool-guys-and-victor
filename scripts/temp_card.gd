extends Node2D
class_name Card

@onready var area : Area2D = $Area2D
@export var data : CardData

var is_hovered : bool = false
var is_dragged : bool = false
var animated : bool = false
var playable : bool = false
var hand_position : Vector2
var card_rotation : float = 0
# Called when the node enters the scene tree for the first time.

signal area_2d_mouse_entered

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#get_top_card()
	pass

func get_top_card():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = 2
	var result = space_state.intersect_point(query)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func _on_area_2d_mouse_entered() -> void:
	is_hovered = true
	area_2d_mouse_entered.emit()
	
func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
	playable = false
