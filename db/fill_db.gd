extends Node2D

var database: SQLite

func _init() -> void:
	database = SQLite.new()
	database.path = "res://db/gamedb.sqlite"
	database.open_db()
	var name = "move_left"
	var array=  ["p-10", "fd-1", "pi-c", "pi-d", "pi-g", "pi-h", "ld1", "js"]
	#var array=  ["p-10", "fd-3", "pi-c", "pi-c", "pi-c", "pi-d", "ld2", "js"]
	#var array=  ["p-3", "p-1", "p-2", "ld3", "fd-4", "sp+"]
	#var array=  ["p-3", "p-6", "p-8", "ld4", "fd-0", "sp-"]
	#var array=  ["a-3", "|", "pa-a", "pi-b", "pi-c", "pi-a", "a-2", "ld5", "vv3+"]
	#var array=  ["a-3", "fd-4", "vv4+", "ld1", "js"]
	var array_json = JSON.stringify(array)
	var insert_query = """
	INSERT INTO scenario (name, array)
	VALUES (?, ?)
	"""
	database.query_with_bindings(insert_query, [name, array_json])
