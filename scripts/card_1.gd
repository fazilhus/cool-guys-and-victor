extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#not correct?: Make class card or attach script to each card instance godot

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Left mouse button was pressed!")
		#The pattern of the card can be placed in 4 directions, show the resulting possible moves:
		#Find character coordinates (backend), show result of all possible patterns (from the clicked card), card patterns from that player coordinate: 
		#highlight those grids in the UI (first delete earlier highlighted grids), and do not move into walls 
		#map manager script: click on one of the highlighted UI grids to move there or attack there.
		# Replace with function body.
