extends Control

var current_square: CrosswordSquare

func _ready() -> void:
	SignalBus.square_clicked.connect(_handle_square_clicked)
	
	%BlockedToggleButton.toggled.connect(_handle_blocked_toggled)
	%DecoratorOption.item_selected.connect(_handle_decorator_set)
	pass # Replace with function body.
	
func _handle_square_clicked(square: CrosswordSquare) -> void:
	current_square = square
	%GridPositionValue.text = str(square.grid_position)
	%SquareNumberValue.text = str(square.square_number)
	%BlockedToggleButton.button_pressed = square.filled
	
	%DecoratorOption.selected = current_square.decorator



func _handle_blocked_toggled(state: bool) -> void:
	if current_square: current_square.set_filled_state(state)
 
func _handle_decorator_set(index: int) -> void:
	if !current_square: return
	
	if index == 0: current_square.set_decorator(CrosswordSquare.Decorators.NONE)

	if index == 1: current_square.set_decorator(CrosswordSquare.Decorators.CIRCLE)
