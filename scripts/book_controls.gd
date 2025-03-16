extends MarginContainer

func _on_book_visibility_changed() -> void:
	var book = %Book
	visible = book.visible
