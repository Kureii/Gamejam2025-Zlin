extends Camera3D

@export var rotate_speed: float = 5

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
