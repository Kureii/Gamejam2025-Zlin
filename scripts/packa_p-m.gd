extends Node3D

@export var id: int = 0
var arrow_: MeshInstance3D
var dragging_collider
var mouse_position_
var do_drag: bool = false
var drag_support_: MeshInstance3D

func _ready() -> void:
	arrow_ = $base/arrow
		
	

func _on_area_3d_mouse_entered() -> void:
	arrow_.visible = true


func _on_area_3d_mouse_exited() -> void:
	arrow_.visible = false


func _on_drag_support_paka_pushed(pose: int) -> void:
	print("direction: ", pose)
