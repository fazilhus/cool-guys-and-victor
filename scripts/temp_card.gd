extends Node2D
class_name Card

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
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
	#var query = PhysicsRayQueryParameters2D.create(Vector2(0, 0), get_viewport().get_mouse_position(), 2)
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	print(query.collision_mask)
	query.collision_mask = 2
	var result = space_state.intersect_point(query)
	print(result)
	#print(result["collider"].get_parent())
	if result.size() > 0:
		#return result["collider"].get_parent()
		#print(result[0]["collider"])
		print(result[0].collider)
		return result[0].collider.get_parent()
	return null

func _on_area_2d_mouse_entered() -> void:
	#SignalBus.highligth_card.emit()
	# var card = get_top_card()
	# if card != null:
	# 	card.animation_player.play("card_highlight")
	#animation_player.play("card_highlight")
	print("entered")
	is_hovered = true
	area_2d_mouse_entered.emit()
	
	#pass # Replace with function body.

func should_highlight_itself() -> void:
	if is_hovered == true:
		if !animated:
			animation_player.play("card_highlight")
			animated = true

func should_unhighlight_itself() -> void:
	if sprite.position != Vector2.ZERO:
		if !is_hovered:
			animation_player.play("card_unhighlight")
			animated = false



func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
	playable = false
	should_unhighlight_itself()
