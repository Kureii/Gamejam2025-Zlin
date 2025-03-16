extends Node

@export_range(1,10, 1) var sequence_lenght: int = 6

var sequence_: Array
var player_sequence_: Array
@export var sequence_text_: Label
@export var end_text_: Label


@export var c1: Node3D
@export var c2: Node3D
@export var c3: Node3D
@export var c4: Node3D
@export var c5: Node3D

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
	sequence_ = generate_sequence(sequence_lenght,0,10)
	sequence_text_.text = "Sequence is: " + str(sequence_)

func generate_sequence(length: int, min_value: int, max_value: int) -> Array:
	var sequence = []
	randomize()
	
	for i in range(length):
		var random_value = randi() % (max_value - min_value + 1) + min_value
		sequence.append(random_value)
	for i in range(sequence.size()):
		if i == 10:
			if randf() > 0.5:
				sequence[i] *= -1
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

func _on_button_clicked(id: int) -> void:
	print(id)
	add_to_sequence(id)


func _on_reset_button_up() -> void:
	sequence_ = generate_sequence(6,0,5)
	sequence_text_.text = "Sequence is: " + str(sequence_)
	player_sequence_.clear()
	var end = get_node("end_game")
	end.visible = false
	
func translator(id: int) -> String:
	return trans_dict[id]
	


func _on_manual_button_up() -> void:
	var manual = %Book
	if manual.visible:
		manual.get_child(0).close()
	else:
		manual.visible = true
