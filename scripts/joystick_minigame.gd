extends Node2D

signal game_finished(id, score)

@export var time_limit: float = 5
@export var player_id: String = "player1"

var score: int = 0
var start_position: Vector2
var is_dragging: bool = false
var ball

# Called when the node enters the scene tree for the first time
func _ready():
	# Get reference to the ball (Ellipse21)
	ball = $Ellipse21
	start_position = ball.position
	
	# Create and start timer
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = time_limit
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	# Make sure Area2D is setup correctly
	var area = $Ellipse21/Area2D
	area.mouse_entered.connect(_on_ball_mouse_entered)
	area.mouse_exited.connect(_on_ball_mouse_exited)

func _process(delta):
	if is_dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		ball.position = get_global_mouse_position()
		score = int(ball.position.distance_to(start_position))

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.pressed:
				is_dragging = false

func _on_ball_mouse_entered():
	is_dragging = true

func _on_ball_mouse_exited():
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dragging = false

func _on_timer_timeout():
	print(score)
	game_finished.emit(player_id, score)
	queue_free()
