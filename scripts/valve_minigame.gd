extends Node2D

signal game_finished(id, score)

@export var player_id: String = "player1"

var donut
var is_dragging = false
var drag_start_position = Vector2.ZERO
var drag_current_position = Vector2.ZERO
var initial_angle = 0.0
var current_angle = 0.0
var total_rotations = 0.0
var last_angle = 0.0
var has_started_drag = false

func _ready():
	# Get reference to the donut sprite
	donut = $DonutSprite
	
	# Set up the Area2D for interaction
	var area = $DonutSprite/Area2D
	area.mouse_entered.connect(_on_donut_mouse_entered)
	area.mouse_exited.connect(_on_donut_mouse_exited)

func _process(delta):
	if is_dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		has_started_drag = true
		
		# Update current mouse position
		drag_current_position = get_global_mouse_position()
		
		# Calculate angle to donut center
		var donut_center = donut.global_position
		var angle_to_mouse = atan2(
			drag_current_position.y - donut_center.y,
			drag_current_position.x - donut_center.x
		)
		
		# Track rotation
		current_angle = angle_to_mouse
		
		# Calculate angle difference since last frame
		var angle_diff = _normalize_angle(current_angle - last_angle)
		
		# Update rotation count based on angle difference
		if angle_diff > PI:
			# Crossed from +PI to -PI (counter-clockwise)
			total_rotations -= (2 * PI - angle_diff) / (2 * PI)
		elif angle_diff < -PI:
			# Crossed from -PI to +PI (clockwise)
			total_rotations += (2 * PI + angle_diff) / (2 * PI)
		else:
			# Normal case
			total_rotations += angle_diff / (2 * PI)
		
		# Apply rotation to sprite
		donut.rotation = current_angle
		
		# Save last angle
		last_angle = current_angle

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and is_dragging:
				# Start dragging
				drag_start_position = get_global_mouse_position()
				var donut_center = donut.global_position
				initial_angle = atan2(
					drag_start_position.y - donut_center.y,
					drag_start_position.x - donut_center.x
				)
				last_angle = initial_angle
				current_angle = initial_angle
			elif not event.pressed and has_started_drag:
				# Released mouse button after dragging - END GAME
				_end_game()

func _on_donut_mouse_entered():
	is_dragging = true

func _on_donut_mouse_exited():
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dragging = false
		
		# If we've been dragging and now exited the area, end the game
		if has_started_drag:
			_end_game()

func _normalize_angle(angle):
	# Keep angle between -PI and PI
	while angle > PI:
		angle -= 2 * PI
	while angle < -PI:
		angle += 2 * PI
	return angle

func _end_game():
	# Game over, emit signal with results
	# Round to nearest integer for full rotations
	var score = int(round(total_rotations))
	game_finished.emit(player_id, score)
	queue_free()
