extends Node2D

var database: SQLite

func _init() -> void:
	database = SQLite.new()
	database.path = "res://db/gamedb.sqlite"
	database.open_db()
	var name = "move_forward"
	var array=  ["p-3", "p-1", "p-2", "fd-4", "sp+"]
	var array_json = JSON.stringify(array)
	var insert_query = """
	INSERT INTO scenario (name, array)
	VALUES (?, ?)
	"""
	database.query_with_bindings(insert_query, [name, array_json])
