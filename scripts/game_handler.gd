extends Node

@export_range(1,10, 1) var sequence_lenght: int = 6

var sequence_: Array
var player_sequence_: Array
@export var sequence_text_: Label
@export var end_text_: Label
var regex = RegEx.new()
var scen
var scores: int =0
		
		
var scenarios: Dictionary

@export var c1: Node3D
@export var c2: Node3D
@export var c3: Node3D
@export var c4: Node3D
@export var c5: Node3D

@export var minigame_joystick_scene: PackedScene
@export var minigame_valve_scene: PackedScene

var db: SQLite

var trans_dict = {
	0 : "p-1",	1 : "p-2",	2 : "p-3",	3 : "p-4",	4 : "p-5",	
	5 : "p-6",	6 : "p-7",	7 : "p-8",	8 : "p-9",	9 : "p-10",
	10 : "sp+",	-10 : "sp-",
	11 : "fd-0",	12 : "fd-1",	13 : "fd-2",	14 : "fd-3",	15 : "fd-4",
	16 : "a-1",	17 : "a-2",	18 : "a-3",	19 : "a-4",	20 : "a-5",	21 : "a-6",
	22 : "a-7",	23 : "a-8",	24 : "a-9",	25 : "a-10",	26 : "a-11",	27 : "a-12",
	28 : "pi-a", 29 : "pi-c", 30 : "pi-d", 31 : "pi-e", 32 : "pi-f", 33 : "pi-g", 34 : "pi-h"
}

func _ready() -> void:
	player_sequence_.clear()
	#sequence_ = generate_sequence(sequence_lenght,0,10)
	scenarios = load_scenario_data()
	scen = get_random_scenario()
	sequence_text_.text = "Your score: " + str(scores) + "\tScenario: " + scen
	
func _process(delta: float) -> void:
	sequence_text_.text = "Your score: " + str(scores) + "\tScenario: " + scen
	
func load_scenario_data() -> Dictionary:
	var scenarios = {}
	
	db = SQLite.new()
	db.path = "res://db/gamedb.sqlite"
	db.open_db()
	
	# Query to get all records from the scenario table
	var query = "SELECT name, array FROM scenario"
	db.query(query)
	
	# Check for errors
	if db.error_message != "not an error":
		print("SQLite error: ", db.error_message)
		return scenarios
	
	# The results are stored in db.query_result
	var result = db.query_result
	
	# Process results
	for row in result:
		var name = row["name"]
		var array_json = row["array"]
		
		# Parse the JSON string back to an array
		var array = JSON.parse_string(array_json)
		
		# Add to scenarios dictionary
		if array != null:
			scenarios[name] = array
	
	print("Loaded " + str(scenarios.size()) + " scenarios from database")
	return scenarios
	
	
func get_random_scenario() -> String:
	
	# Get all the keys (scenario names)
	var scenario_keys = scenarios.keys()
	
	# Check if we have any scenarios
	if scenarios.size() == 0:
		print("Error: No scenarios found in database")
		return ""
	else:
	# Select a random key
		var random_index = randi() % scenario_keys.size()
		var selected_key = scenario_keys[random_index]
		
		# Get the array for the selected scenario
		sequence_ = scenarios[selected_key]
		return selected_key
	
	
#
#func generate_sequence(length: int, min_value: int, max_value: int) -> Array:
	#var sequence = []
	#randomize()
	#
	#for i in range(length):
		#var random_value = randi() % (max_value - min_value + 1) + min_value
		#sequence.append(random_value)
	#for i in range(sequence.size()):
		#if i == 10:
			#if randf() > 0.5:
				#sequence[i] *= -1
	#return sequence
	
func add_to_sequence(id:String) -> void:
	player_sequence_.append(id)
	var ok: bool = true
	for i in range(player_sequence_.size()):
		if sequence_[i] !=player_sequence_[i]:
			ok = false
			end()
	if ok :
		scores += 50
	if ok and player_sequence_.size() == sequence_.size():
		win()
	if sequence_[player_sequence_.size()] == "|":
		player_sequence_.append("|")
		win()
	regex.compile("^ld\\d+$")
	if player_sequence_.size() < sequence_.size() and sequence_[player_sequence_.size()] != null:
		var next_element = sequence_[player_sequence_.size()]
		# Ensure next_element is a string before using regex on it
		if typeof(next_element) == TYPE_STRING and regex.search(next_element):
			# It matches "ld" followed by a number
			player_sequence_.append(next_element)
			
			# Extract the number part
			if next_element.begins_with("ld") and next_element.substr(2).is_valid_int():
				var number = int(next_element.substr(2))
				
				# Set the corresponding variable to true
				match number:
					1:
						c1.on = true
					2:
						c2.on = true
					3:
						c3.on = true
					4:
						c4.on = true
					5:
						c5.on = true
				win()

func end() -> void:
	var end = get_node("end_game")
	end_text_.text = "You lose"
	end.visible = true
	turn_off_led()
	
func turn_off_led():
	c1.on = false
	c2.on = false
	c3.on = false
	c4.on = false
	c5.on = false

func win() -> void:
	scen = get_random_scenario()
	sequence_text_.text = "Your score: " + str(scores) + "\tScenario: " + scen
	player_sequence_.clear()
	var end = get_node("end_game")
	scores += 200
	end.visible = false
	turn_off_led()

func _on_button_clicked(id: int) -> void:
	add_to_sequence(translator(id))


func _on_reset_button_up() -> void:
	get_random_scenario()
	#sequence_text_.text = "Sequence is: " + str(sequence_)scenarios = load_scenario_data()
	scen = get_random_scenario()
	sequence_text_.text = "Your score: " + str(scores) + "\tScenario: " + scen
	player_sequence_.clear()
	var end = get_node("end_game")
	end.visible = false
	scores = 0
	
func translator(id: int) -> String:
	return trans_dict[id]

func _on_manual_button_up() -> void:
	var manual = %Book
	if manual.visible:
		manual.get_child(0).close()
	else:
		manual.visible = true

func start_joystick_minigame():
	# Instance the mini-game
	var minigame_instance = minigame_joystick_scene.instantiate()
	
	# Connect to the game_finished signal
	minigame_instance.game_finished.connect(process_minigame_result)
	
	# Add it to the scene
	get_tree().current_scene.add_child(minigame_instance)
	
	print("Mini-game started!")

func start_donut_minigame():
	var minigame_instance = minigame_valve_scene.instantiate()
	minigame_instance.game_finished.connect(_on_donut_minigame_finished)
	get_tree().current_scene.add_child(minigame_instance)
	print("Donut mini-game started!")

func _on_joystick_clicked_on_joystic() -> void:
	start_joystick_minigame()
	
func _on_donut_minigame_finished(id, score):
	process_minigame_result(id, score, "donut")

# Process the result from any mini-game
func process_minigame_result(id, score, minigame_type):
	if minigame_type == "donut":
		var feeb : String
		if score < 0:
			feeb = "vv" + str(score) + "-"
		else:
			feeb = "vv" + str(score) + "+"
	elif sequence_[player_sequence_.size()+1] == "js":
		scores += scores
		add_to_sequence("js")
		
	print("Mini-game completed! Type: " + minigame_type + ", ID: " + id + ", Score: " + str(score))
	


func _on_valve_clicked_on_valve() -> void:
	start_donut_minigame()


func _on_fuel_d_slider_released(position_id: int) -> void:
	print(position_id)
	add_to_sequence(translator(position_id))
