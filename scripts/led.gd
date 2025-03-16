extends Node3D

@export var intensity: float = 1:
	set(value):
		set_energy(value)
@export var on: bool = false:
	set(value):
		on_off(value)

func _ready() -> void:
	on_off(on)

func on_off(value: bool):
	var light = $OmniLight3D
	if value:
		light.light_energy = intensity
		light.light_indirect_energy = intensity
	else:
		light.light_energy = 0

func set_energy(value: float):
	var light = $OmniLight3D
	light.light_energy = intensity
	light.light_indirect_energy = intensity
