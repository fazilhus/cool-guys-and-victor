extends Character
class_name PlayableCharacter

#@onready var deck : Deck = %Deck

signal turn_phase_player_ended



#var currPos=[7,15] #movement is: we click on card, we click on highlighted square to move there 
#How to move to the grid we click at if it is highlighted too? 
#Begin with card script: get player coordinates: wrong: begin with map manager, represent coordinates? 
#https://pastebin.com/kimj4g0x
#var last_position = Vector2() # last idle position
#var tile_size = 64 # size in pixels of tiles on the grid
#https://github.com/sventomasek/Godot-Grid-Based-Movement
#https://www.nightquestgames.com/adding-collision-to-tilemaps-in-godot-4/#:~:text=How%20To%20Easily%20Add%20Collision%20to%20Your%20Tilemap,of%20the%20Colliding%20Character%20%28s%29%20...%20More%20items


func _ready() -> void:
	#position=position.snapped(Vector2(tile_size, tile_size))
	
	Main.battle_started.connect(on_battle_started)
	Main.battle_ended.connect(on_battle_ended)

	Main.turn_phase_start.connect(on_turn_phase_start)
	Main.turn_phase_player.connect(on_turn_phase_player_start)
	Main.turn_phase_enemy.connect(on_turn_phase_enemy)
	Main.turn_phase_enemy.connect(on_turn_phase_enemy)

func on_battle_started() -> void:
	pass

func on_battle_ended() -> void:
	pass

func on_turn_phase_start() -> void:
	#deck.draw_cards()
	char_data.ap_data.current = char_data.ap_data.maximum

func on_turn_phase_player_start() -> void:
	pass

func end_turn_phase_player() -> void:
	turn_phase_player_ended.emit()

func on_turn_phase_enemy() -> void:
	pass

func on_turn_phase_end() -> void:
	pass

#func try_play_card(card : Card) -> void:
func try_play_card(_card) -> void:
	#if card.cost <= char_data.ap_data.current:
		#char_data.ap_data.current -= card.cost
		#on_card_played.emit(card)
	#else:
		#do smth
	pass
