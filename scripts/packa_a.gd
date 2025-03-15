extends Node3D

signal packa_a_clicked(id: int)

var scenario_: int
@export var id_: int = 0

func _ready() -> void:
	var area = $base/packa_a/Area3D
	area.packa_a_area_clicked.connect(_on_packa_a_area_clicked)

func _on_packa_a_area_clicked() -> void:
	print("send id: ", id_)
	emit_signal("packa_a_clicked ", id_)
	
func _on_get_scenario(scenario:int) -> void:
	scenario_ = scenario
	
