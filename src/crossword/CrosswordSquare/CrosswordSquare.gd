class_name CrosswordSquare
extends LineEdit

# Private
var _square_width: int = 2
var _rect_color: Color = Color.BLACK
var _crossword_grid: CrosswordGrid

enum Decorators {
	NONE,
	CIRCLE,
}

# Public
var filled: bool = false
var square_number: int = -1
var grid_position: Vector2i
var is_clicked: bool = false
var decorator: Decorators = Decorators.NONE
var letter_data: String = ""


func _ready() -> void:
	self.text_changed.connect(_handle_text_changed)
	self.gui_input.connect(_on_gui_input)
	SignalBus.square_clicked.connect(_on_square_clicked)
	
func _draw() -> void:
	var rect: Rect2 = Rect2(Vector2.ZERO, self.size)
	
	# the width argument has no effect if the rect is filled.
	if filled:
		draw_rect(rect, _rect_color, filled)
	else:
		draw_rect(rect, _rect_color, filled, _square_width)
	
	if decorator == Decorators.CIRCLE:
		draw_circle(self.size * 0.5, 20.0, _rect_color, false, 2.0)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SignalBus.emit_square_clicked(self)
		set_clicked_state(true)


func _on_square_clicked(square: CrosswordSquare) -> void:
	if square.grid_position != self.grid_position:
		set_clicked_state(false)


func set_clicked_state(clicked_state: bool) -> void:
	is_clicked = clicked_state
	if clicked_state == true:
		_rect_color = Color.BLUE
		_square_width = 4
	else:
		_rect_color = Color.BLACK
		_square_width = 2
	queue_redraw()


func set_filled_state(filled_state: bool) -> void:
	filled = filled_state
	if filled:
		%SquareNumber.text = ""
		square_number = -1

	if filled:
		text = ""
	
	# Links the filled state of the symmetrical square.
	var sym_square: CrosswordSquare = _crossword_grid.get_square_by_grid_position(Vector2i((_crossword_grid.grid_size.x - 1) - grid_position.x, (_crossword_grid.grid_size.y - 1) - grid_position.y))
	if sym_square.filled != filled_state:
		sym_square.set_filled_state(filled_state)	

	# This eventually triggers the square numbers to recalculate
	# at the crossword grid level.
	SignalBus.emit_square_filled(self)
	queue_redraw()

func set_decorator(d: Decorators) -> void:
	decorator = d
	queue_redraw()


func _set_text(new_text: String) -> void:
	text = new_text.to_upper()


func _handle_text_changed(new_text: String) -> void:	
	letter_data = new_text.to_upper()
	if new_text.length() >= 3:
		add_theme_font_size_override("font_size", 13)
	else:
		add_theme_font_size_override("font_size", 15)

func set_number(number: int) -> void:
	square_number = number	
	%SquareNumber.text = str(square_number)
