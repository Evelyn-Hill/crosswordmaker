extends Node

signal square_clicked(square: CrosswordSquare)
func emit_square_clicked(square: CrosswordSquare):
	square_clicked.emit(square)

signal save_requested
func emit_save_requested():
	save_requested.emit()
