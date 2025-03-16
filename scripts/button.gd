extends Node3D

signal paka_clicked(id: int)

var scenario_: int
@export var id_: int = 0
	
func _on_get_scenario(scenario:int) -> void:
	scenario_ = scenario

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("paka_clicked", id_)
		var anim = get_node("AnimationPlayer")
		anim.play("button_anim")
