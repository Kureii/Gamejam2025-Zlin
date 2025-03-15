extends Node3D

@export var movement_speed: float = 1
@export var return_speed: float = 0.3
@export var packa_: MeshInstance3D
var is_dragging: bool = false
var dragging_object: bool = false
var is_returning: bool = false
var signal_emited: bool = false

signal paka_pushed(pose: int)

func _ready():
	if has_node("Area3D"):
		$Area3D.input_event.connect(_on_area_input_event)
		$Area3D.mouse_exited.connect(_on_area_mouse_exited)


func _on_area_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging_object = event.pressed

func _on_area_mouse_exited():
	if is_dragging:
		is_dragging = false
		is_returning = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed
		if !is_dragging:
			dragging_object = false
	
	elif event is InputEventMouseMotion and is_dragging and dragging_object:
		var motion = event.relative  
		
		transform.origin.z += -motion.y * movement_speed * 0.001
		packa_.rotation = Vector3(position.z * PI,0,0 )

func _process(delta):
	if is_returning and not is_dragging:
		var current_z = transform.origin.z
		
		if abs(current_z) < 0.01:
			transform.origin.z = 0.0
			is_returning = false
		else:
			if signal_emited == false:
				var dir 
				if position.z < 0:
					dir = -1 
				else:
					dir = 1
				emit_signal("paka_pushed", dir)
				signal_emited = true
			transform.origin.z = move_toward(current_z, 0.0, return_speed * delta)
			packa_.rotation = Vector3(position.z * PI,0,0 )
	if signal_emited and not is_returning and not is_dragging: signal_emited = false
