extends Node3D

# Vlastní signály
signal kliknuto_leve(pozice)
signal kliknuto_prave

# Nastavení pohybu kamery
@export var trvani_pohybu: float = 1.0  # Doba trvání pohybu kamery v sekundách
@export var vzdalenost_zoomu: float = 5.0  # Jak daleko se kamera posune směrem k místu kliknutí
@export var vyska_kamery: float = 2.0  # Výška kamery nad povrchem

# Proměnné pro správu kamery
var puvodni_pozice_kamery: Vector3
var puvodni_rotace_kamery: Vector3
var kamera_v_pohybu: bool = false
var cilova_pozice_kamery: Vector3

# Reference na kameru a tween
@onready var kamera: Camera3D = $Camera3D if has_node("Camera3D") else null
var tween: Tween

func _ready():
	# Uložení původní pozice a rotace kamery
	if kamera:
		puvodni_pozice_kamery = kamera.global_position
		puvodni_rotace_kamery = kamera.rotation_degrees
	
	# Připojení signálů
	kliknuto_leve.connect(_na_kliknuti_leve)
	kliknuto_prave.connect(_na_kliknuti_prave)

# Zachycení vstupní události
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Zjištění pozice v 3D prostoru na základě kliknutí
			var pozice_3d = ziskej_3d_pozici_z_kliknuti(event.position)
			if pozice_3d:
				kliknuto_leve.emit(pozice_3d)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			kliknuto_prave.emit()

# Převod 2D pozice myši na 3D pozici ve scéně
func ziskej_3d_pozici_z_kliknuti(pozice_mysi):
	# Získání prostoru z viewport
	var prostor = get_world_3d().direct_space_state
	
	# Nastavení parametrů pro raycast
	var query = PhysicsRayQueryParameters3D.new()
	query.from = kamera.project_ray_origin(pozice_mysi)
	query.to = query.from + kamera.project_ray_normal(pozice_mysi) * 1000.0
	query.collision_mask = 1  # Upravte podle vašeho nastavení vrstev kolize
	
	# Provedení raycastu
	var vysledek = prostor.intersect_ray(query)
	
	if vysledek.size() > 0:
		return vysledek["position"]
	return null

# Metoda pro zpracování kliknutí levým tlačítkem
func _na_kliknuti_leve(pozice):
	print("Kliknuto levým tlačítkem na 3D pozici: ", pozice)
	
	# Kontrola, jestli máme kameru
	if not kamera:
		print("CHYBA: Kamera nenalezena! Přidejte kameru jako potomka tohoto uzlu.")
		return
	
	# Uložení původní pozice kamery, pokud jsme ještě v původní pozici
	if not kamera_v_pohybu:
		puvodni_pozice_kamery = kamera.global_position
		puvodni_rotace_kamery = kamera.rotation_degrees
	
	# Nastavení cílové pozice
	var cilova_pozice = Vector3(pozice.x, pozice.y + vyska_kamery, pozice.z)
	
	# Výpočet směru pohledu na cíl
	var smer_pohledu = pozice - cilova_pozice
	var cilova_rotace = Vector3()
	cilova_rotace.x = rad_to_deg(atan2(smer_pohledu.y, sqrt(smer_pohledu.x * smer_pohledu.x + smer_pohledu.z * smer_pohledu.z)))
	cilova_rotace.y = rad_to_deg(atan2(smer_pohledu.x, smer_pohledu.z))
	
	# Posun k cíli, ale ne úplně (vzdálenost zoomu)
	var smer_normalized = smer_pohledu.normalized()
	var cilova_kamera_pozice = pozice - smer_normalized * vzdalenost_zoomu
	
	# Spuštění pohybu kamery
	presun_kameru(cilova_kamera_pozice, cilova_rotace)

# Metoda pro zpracování kliknutí pravým tlačítkem
func _na_kliknuti_prave():
	print("Kliknuto pravým tlačítkem - vracení kamery")
	
	# Kontrola, jestli máme kameru
	if not kamera:
		print("CHYBA: Kamera nenalezena! Přidejte kameru jako potomka tohoto uzlu.")
		return
	
	# Vracení kamery na původní pozici
	presun_kameru(puvodni_pozice_kamery, puvodni_rotace_kamery)

# Metoda pro plynulý pohyb kamery
func presun_kameru(cilova_pozice, cilova_rotace):
	# Zrušení předchozího tweenu, pokud existuje
	if tween:
		tween.kill()
	
	# Vytvoření nového tweenu
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Nastavení tweenu pro pozici a rotaci
	tween.parallel().tween_property(kamera, "global_position", cilova_pozice, trvani_pohybu)
	tween.parallel().tween_property(kamera, "rotation_degrees", cilova_rotace, trvani_pohybu)
	
	# Nastavení signálu dokončení
	tween.finished.connect(func(): kamera_v_pohybu = false)
	
	kamera_v_pohybu = true
