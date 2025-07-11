extends Control

var current_square: CrosswordSquare

func _ready() -> void:
	SignalBus.square_clicked.connect(_handle_square_clicked)
	
	%BlockedToggleButton.toggled.connect(_handle_blocked_toggled)
	pass # Replace with function body.
	
func _handle_square_clicked(square: CrosswordSquare) -> void:
	current_square = square
	%GridPositionValue.text = str(square.grid_position)
	%SquareNumberValue.text = str(square.square_number)
	%BlockedToggleButton.button_pressed = square.filled

func _handle_blocked_toggled(state: bool) -> void:
	current_square.set_filled_state(state)
