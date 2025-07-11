extends Node

signal square_clicked(square: CrosswordSquare)
func emit_square_clicked(square: CrosswordSquare):
	square_clicked.emit(square)
