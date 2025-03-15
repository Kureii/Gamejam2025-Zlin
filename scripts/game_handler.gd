extends Node

@export_range(1,10) var sequence_lenght: int

var sequence_: Array
var player_sequence_: Array
@export var sequence_text_: Label
@export var end_text_: Label


func _ready() -> void:
	player_sequence_.clear()
	sequence_ = generate_sequence(6,0,5)
	sequence_text_.text = "Sequence is: " + str(sequence_)

func generate_sequence(length: int, min_value: int, max_value: int) -> Array:
	var sequence = []
	randomize()
	
	for i in range(length):
		var random_value = randi() % (max_value - min_value + 1) + min_value
		sequence.append(random_value)
	
	return sequence
	
func add_to_sequence(id:int) -> void:
	player_sequence_.append(id)
	var ok: bool = true
	for i in range(player_sequence_.size()):
		if sequence_[i] !=player_sequence_[i]:
			ok = false
			end()
	if ok and player_sequence_.size() == sequence_.size():
		win()

func end() -> void:
	var end = get_node("end_game")
	end_text_.text = "You lose"
	end.visible = true

func win() -> void:
	var end = get_node("end_game")
	end_text_.text = "You win"
	end.visible = true

func _on_packa_a_clicked(id: int) -> void:
	add_to_sequence(id)


func _on_reset_button_up() -> void:
	sequence_ = generate_sequence(6,0,5)
	sequence_text_.text = "Sequence is: " + str(sequence_)
	player_sequence_.clear()
	var end = get_node("end_game")
	end.visible = false
