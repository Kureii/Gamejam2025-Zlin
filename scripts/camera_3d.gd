extends Camera3D

@export var rotate_speed: float = 5
@export var lock_mouse: bool = true;
@export var lock_rotation: bool = false;

var rot_vector_ : Vector3 = Vector3(0,0,0)

func _process(delta: float) -> void:
	cam_rotate(delta)
	
	
func cam_rotate(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rot_vector_ += Vector3(0,delta * rotate_speed * 0.5,0)
	if Input.is_action_pressed("ui_right"):
		rot_vector_ += Vector3(0,delta * rotate_speed * -0.5,0)
	if Input.is_action_pressed("ui_up"):
		rot_vector_ += Vector3(delta * rotate_speed * 0.5,0,0)
	if Input.is_action_pressed("ui_down"):
		rot_vector_ += Vector3(delta * rotate_speed * -0.5,0,0)
	
	rotation = rot_vector_ 

func _input(event):
	if event is InputEventMouseMotion:
		if(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
			rot_vector_ += Vector3(event.relative.y,event.relative.x,0)*0.001*rotate_speed



func _on_button_clicked(id: int) -> void:
	pass # Replace with function body.
