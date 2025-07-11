class_name CrosswordGrid
extends Control

const CROSSWORD_SQUARE: PackedScene = preload("res://src/crossword/CrosswordSquare/CrosswordSquare.tscn")

@export var grid_size: Vector2i = Vector2(10, 10)

var squares: Dictionary[Vector2i, CrosswordSquare]

func _ready() -> void:
	render_crossword()

func render_crossword() -> void: 
	var square_number = 0
	for y in range(0, grid_size.y):
		for x in range(0, grid_size.x):
			square_number += 1
			var square: CrosswordSquare = CROSSWORD_SQUARE.instantiate() as CrosswordSquare
			square.square_number = square_number
			square.grid_position = Vector2i(x, y)
			square._crossword_grid = self
			self.add_child(square)
			square.position.y = square.size.y * y
			square.position.x = square.size.x * x
			squares[square.grid_position] = square

func get_square_by_grid_position(grid_position: Vector2i) -> CrosswordSquare:
	return squares[grid_position]
