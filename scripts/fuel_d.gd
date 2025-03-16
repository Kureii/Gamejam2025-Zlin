extends Node3D

signal slider_released(position_id: int)

@export var id: int = 11
@export var drag_speed: float = 1.0
@export var drag_limit: float = 0.425  # Maximum distance the handle can move in either direction
@export var step_size: float = 1.0      # Adjust based on your model spacing

# References to the nodes
@onready var drag_area: Node3D = $fd_base/fd/DragArea3Da
# The actual movable element - update this to match your scene structure
@onready var handle: Node3D = $fd_base/fd

var is_dragging: bool = false
var add_id: int = 0
var camera: Camera3D
var initial_mouse_pos: Vector2
var initial_handle_pos: Vector3
var screen_plane: Plane

func _ready() -> void:
	# Find the camera in the scene
	camera = get_viewport().get_camera_3d()
	
	# Check if we have valid references
	if !handle:
		push_error("Could not find the handle node. Please update the path in the script.")
		set_process(false)
		return

func _process(delta: float) -> void:
	if is_dragging:
		handle_drag()

func _on_drag_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag(event.position)
			elif is_dragging:
				end_drag()
				
func _input(event: InputEvent) -> void:
	# This handles the case where the mouse is released outside the DragArea3D
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and is_dragging:
			end_drag()

func start_drag(mouse_position: Vector2) -> void:
	is_dragging = true
	initial_mouse_pos = mouse_position
	initial_handle_pos = handle.position  # Store the handle's position, not the parent
	
	# Create a plane for the drag operation
	var camera_position = camera.global_position
	var handle_position = handle.global_position
	var camera_forward = -camera.global_transform.basis.z
	
	# Create a plane that's parallel to the camera but at the object's depth
	var plane_normal = camera_forward
	screen_plane = Plane(plane_normal, plane_normal.dot(handle_position))

func handle_drag() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Project mouse position onto the 3D plane
	var from = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)
	
	var intersection = screen_plane.intersects_ray(from, dir)
	
	if intersection:
		# Calculate local position relative to parent
		var global_target = intersection
		var local_target = to_local(global_target)
		
		# Only modify the X position, keeping Y and Z unchanged
		var new_handle_pos = handle.position
		
		# Calculate starting X position (when drag_limit is 0)
		var base_x = initial_handle_pos.x
		
		# Clamp movement within the defined limit on both sides
		new_handle_pos.x = clamp(local_target.x, base_x - drag_limit, base_x + drag_limit)
		handle.position = new_handle_pos
		
		# Check which area we're in based on handle position
		update_current_area()

func end_drag() -> void:
	is_dragging = false
	
	# Snap to nearest step based on the initial position
	var base_x = initial_handle_pos.x
	var current_x = handle.position.x
	var relative_pos = current_x - base_x
	
	# Calculate the nearest step
	var steps = round(relative_pos / step_size)
	var new_pos = handle.position
	new_pos.x = base_x + (steps * step_size)
	handle.position = new_pos
	
	# Update area and emit signal
	update_current_area()
	emit_signal("slider_released", add_id+id)

func update_current_area() -> void:
	# Determine which area we're in based on handle position
	var base_x = initial_handle_pos.x
	var current_x = handle.position.x
	
	# Calculate how far along the slider we are (from -1.0 to 1.0)
	var normalized_pos = 0.0
	if drag_limit > 0:
		normalized_pos = (current_x - base_x) / drag_limit
	
	# Convert to 0-100 range
	var position_percentage = (normalized_pos + 1.0) * 50
	
	# Assign appropriate area ID based on position
	if position_percentage <= 12.5:
		print("add 0")
		add_id = 0
	elif position_percentage <= 37.5:
		add_id = 1
	elif position_percentage <= 62.5:
		add_id = 2
	elif position_percentage <= 87.5:
		add_id = 3
	else:
		add_id = 4
