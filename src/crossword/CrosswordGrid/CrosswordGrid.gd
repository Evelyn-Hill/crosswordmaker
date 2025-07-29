class_name CrosswordGrid
extends Control

const CROSSWORD_SQUARE: PackedScene = preload("res://src/crossword/CrosswordSquare/CrosswordSquare.tscn")
const MIN_GRID_SIZE: int = 10
const MAX_GRID_SIZE: int = 25

@export var grid_size: Vector2i = Vector2(10, 10)

var squares: Dictionary[Vector2i, CrosswordSquare]

func _ready() -> void:
	render_crossword()
	SignalBus.save_requested.connect(generate_crossword_json)
	SignalBus.square_filled.connect(on_square_filled)

func render_crossword() -> void:
	
	if self.get_child_count() != 0:
		for child in get_children():
			child.queue_free()

		squares.clear()


	for y in range(0, grid_size.y):
		for x in range(0, grid_size.x):
			var square: CrosswordSquare = CROSSWORD_SQUARE.instantiate() as CrosswordSquare
			square.grid_position = Vector2i(x, y)
			square._crossword_grid = self
			self.add_child(square)
			square.position.y = square.size.y * y
			square.position.x = square.size.x * x
			squares[square.grid_position] = square


	calculate_square_numbers()

func calculate_square_numbers() -> void:
	if squares.is_empty(): return
	
	var number: int = 1

	for square in squares:
		if squares[square].filled:
			continue
		
		squares[square].set_number(number)
		number += 1

func try_set_grid_size(new_size: int) -> bool:
	if new_size < MIN_GRID_SIZE or new_size > MAX_GRID_SIZE:
		return false
	
	grid_size = Vector2i(new_size, new_size)
	render_crossword()
	return true

func on_square_filled(_square: CrosswordSquare) -> void:
	calculate_square_numbers()

func generate_crossword_json() -> String:
	var data = {}
	data["grid_size"] = str(grid_size)

	var square_data = {}
	var blocked_data = []
	var decorator_data = {}

	for square in squares:
		square_data[str(square)] = squares[square].letter_data

		if squares[square].filled:
			blocked_data.append(square)

		if squares[square].decorator != CrosswordSquare.Decorators.NONE:
			decorator_data[square] = str(squares[square].decorator)

	
	data["square_data"] = square_data
	data["blocked_data"] = blocked_data
	data["decorator_data"] = decorator_data
	
	print(JSON.stringify(data))

	return JSON.stringify(data)	

func get_square_by_grid_position(grid_position: Vector2i) -> CrosswordSquare:
	return squares[grid_position]
