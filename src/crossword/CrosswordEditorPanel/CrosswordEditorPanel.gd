extends Control

var current_square: CrosswordSquare
@onready var _crossword_grid = get_parent().get_node_or_null("CrosswordGrid")

func _ready() -> void:
	assert(_crossword_grid != null, "Could not find crossword grid!")

	SignalBus.square_clicked.connect(_handle_square_clicked)	
	%BlockedToggleButton.toggled.connect(_handle_blocked_toggled)
	%DecoratorOption.item_selected.connect(_handle_decorator_set)
	%SaveButton.pressed.connect(_handle_save_button_pressed)

	%SizeSpinBox.value_changed.connect(_handle_size_spin_box_value_changed)
	%SizeSpinBox.value = _crossword_grid.grid_size.x
	%SizeSpinBox.min_value = _crossword_grid.MIN_GRID_SIZE
	%SizeSpinBox.max_value = _crossword_grid.MAX_GRID_SIZE
	
func _handle_square_clicked(square: CrosswordSquare) -> void:
	current_square = square
	%GridPositionValue.text = str(square.grid_position)
	%SquareNumberValue.text = str(square.square_number)
	%BlockedToggleButton.button_pressed = square.filled	
	%DecoratorOption.selected = current_square.decorator


func _handle_size_spin_box_value_changed(value: float) -> void:
	_crossword_grid.try_set_grid_size(value)
	pass

func _handle_blocked_toggled(state: bool) -> void:
	if current_square: current_square.set_filled_state(state)
 
func _handle_decorator_set(index: int) -> void:
	if !current_square: return
	
	if index == 0: current_square.set_decorator(CrosswordSquare.Decorators.NONE)

	if index == 1: current_square.set_decorator(CrosswordSquare.Decorators.CIRCLE)


func _handle_save_button_pressed() -> void:
	SignalBus.emit_save_requested()
