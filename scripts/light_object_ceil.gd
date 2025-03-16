extends MeshInstance3D

@export var use_temperature: bool
@export_color_no_alpha var color
@export_range(0,2) var intensity: float
@export_range(500,15000,50,) var temperature: float
@export_range(0,2) var temperature_intensity: float

func _ready() -> void:
	for i in range(get_child_count()):
		get_child(i).light_energy = intensity
		# if use_temperature:
		# 	get_child(i).light_color = kelvin_to_rgb(temperature, temperature_intensity)
		# else:
		# 	get_child(i).light_color = color

static func kelvin_to_rgb(kelvin: float, temperature_intensity: float = 1.0) -> Color:
	kelvin = clamp(kelvin, 1000.0, 40000.0)
	
	var r: float
	var g: float
	var b: float
	
	if kelvin < 6600.0:
		r = 255.0
	else:
		r = kelvin / 100.0 - 60.0
		r = 329.698727446 * pow(r, -0.1332047592)
	
	if kelvin < 6600.0:
		g = kelvin / 100.0
		g = 99.4708025861 * log(g) - 161.1195681661
	else:
		g = kelvin / 100.0 - 60.0
		g = 288.1221695283 * pow(g, -0.0755148492)
	
	if kelvin < 6600.0:
		if kelvin <= 1900.0:
			b = 0.0
		else:
			b = kelvin / 100.0 - 10.0
			b = 138.5177312231 * log(b) - 305.0447927307
	else:
		b = 255.0
	
	r = max(0.0, r) / 255.0 * temperature_intensity
	g = max(0.0, g) / 255.0 * temperature_intensity
	b = max(0.0, b) / 255.0 * temperature_intensity
	
	return Color(r, g, b)

		
