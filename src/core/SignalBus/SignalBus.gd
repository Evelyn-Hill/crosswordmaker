extends Node

signal square_clicked(square: CrosswordSquare)
func emit_square_clicked(square: CrosswordSquare):
	square_clicked.emit(square)

signal save_requested
func emit_save_requested():
	save_requested.emit()

signal square_filled(square: CrosswordSquare)
func emit_square_filled(square: CrosswordSquare) -> void:
	square_filled.emit(square)
