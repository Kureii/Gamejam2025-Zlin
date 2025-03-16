extends  Node3D

@onready var anim = $AnimationPlayer

signal close_book()

var end_book: bool = false
var page_swap: bool = false
var page_count:int = 0
var actual_left_page: int = 0
var actual_right_page: int = 1

func _ready() -> void:
	anim.play("book_armature|book_open")
	page_count = count_available_pages()
	change_page_texture(0,actual_left_page)
	change_page_texture(3,actual_right_page)
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if page_swap:
		change_page_texture(0,actual_left_page)
		change_page_texture(3,actual_right_page)
		page_swap = false
	if not end_book:
		anim.play("book_armature|idle")
	else:
		emit_signal("close_book")

func close():
	anim.play("book_armature|book_open", -1, -1, true)
	end_book = true

func next_page():
	if actual_right_page< page_count-1 :
		print(actual_right_page)
		change_page_texture(1,actual_right_page)
		change_page_texture(2,actual_right_page+1)
		change_page_texture(3,actual_right_page+2)
		anim.play("book_armature|book_turn_page")
		actual_left_page += 2
		actual_right_page += 2
		page_swap = true

	
func prew_page():
	if actual_left_page != 0:
		change_page_texture(0,actual_left_page-2)
		change_page_texture(1,actual_left_page-1)
		change_page_texture(2,actual_left_page)
		anim.play("book_armature|book_turn_page", -1, -1, true)
		actual_left_page -= 2
		actual_right_page -= 2
		page_swap = true

	


func _on_next_button_button_up() -> void:
	next_page()


func _on_prew_button_button_up() -> void:
	prew_page() # Replace with function body.
	
func count_available_pages():
	var page_count = 0
	
	# Otevření adresáře s texturami stránek
	var dir = DirAccess.open("res://pages")
	if dir:
		# Projdeme všechny soubory v adresáři
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Kontrola, jestli soubor odpovídá vzoru "page_#"
			if file_name.begins_with("page_") and file_name.get_extension() in ["png", "jpg", "jpeg", "webp"]:
				var page_num_str = file_name.get_basename().split("_")[1]
				
				# Zkontrolujeme, že je to číslo
				if page_num_str.is_valid_int():
					page_count = max(page_count, int(page_num_str) + 1)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
		
		# Ověříme, že soubory jsou spojité
		for i in range(page_count):
			var expected_file = "page_" + str(i)
			var found = false
			
			# Ověříme existenci souboru s různými možnými příponami
			for ext in ["png", "jpg", "jpeg", "webp"]:
				if FileAccess.file_exists("res://pages/" + expected_file + "." + ext):
					found = true
					break
			
			if not found:
				print("Varování: Stránka " + str(i) + " chybí!")
		return page_count
	else:
		print("Nepodařilo se otevřít adresář res://pages")
		return 0
	
func change_page_texture(material_number, texture_number):
	# Get the material resource - přidání přípony
	var material_path = "res://materials/page_" + str(material_number) + ".tres"
	var material = load(material_path)
	
	if material == null:
		print("Material could not be loaded!")
		return
		
	# Load the texture - přidání přípony
	var texture_path = "res://pages/page_" + str(texture_number) + ".png"  # zkuste i jiné přípony, pokud PNG nefunguje
	var texture = load(texture_path)
	
	if texture == null:
		# Zkusíme zjistit správnou příponu
		var dir = DirAccess.open("res://pages")
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			
			while file_name != "":
				if file_name.begins_with("page_" + str(texture_number) + "."):
					var correct_path = "res://pages/" + file_name
					print("Found correct path: " + correct_path)
					texture = load(correct_path)
					break
				file_name = dir.get_next()
			dir.list_dir_end()
	
	if texture:
		# Set the shader parameter
		material.set_shader_parameter("Texture", texture)
		
	else:
		print("Failed to load texture at path: " + texture_path)
		print("Make sure the file exists and the path is correct!")
