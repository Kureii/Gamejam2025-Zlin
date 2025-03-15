extends Area3D

signal packa_a_area_clicked()

func _init() -> void:
	input_ray_pickable = true

func _ready() -> void:
	input_event.connect(_on_input_event)
	
func _on_input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("packa_a_area_clicked")
		var anim = get_node("../Packa_a_AnimationPlayer")
		anim.play("packa_a_anim")

	
