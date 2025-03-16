extends MarginContainer

func _on_book_visibility_changed() -> void:
	var book = %Book
	var container = $MarginContainer/HBoxContainer
	container.visible = book.visible
