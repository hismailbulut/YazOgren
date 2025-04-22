extends TextureButton

func initialize(key, is_keyboard_key):
	set_text(key)
	if is_keyboard_key:
		$label.add_font_override("font", load("res://Font/word-font.tres"))

func _ready():
	var color = SettingsManager.get_settings().button_color
	if(color == "blue"):
		texture_normal = load("res://ui/blue_button_1.png")
		texture_pressed = load("res://ui/blue_button_2.png")
	elif(color == "green"):
		texture_normal = load("res://ui/green_button_1.png")
		texture_pressed = load("res://ui/green_button_2.png")
	elif(color == "red"):
		texture_normal = load("res://ui/red_button_1.png")
		texture_pressed = load("res://ui/red_button_2.png")
	elif(color == "yellow"):
		texture_normal = load("res://ui/yellow_button_1.png")
		texture_pressed = load("res://ui/yellow_button_2.png")
	else:
		print("color settings are broken please fix")

func set_upper():
	set_text(get_text().to_upper())

func set_lower():
	set_text(get_text().to_lower())

func is_upper():
	if get_text() == "'" or get_text() == "." or get_text() == "?" or get_text() == "!" or get_text() == '"':
		return false
	elif get_text() == get_text().to_upper():
		return true
	else:
		return false

func get_text():
	return $label.text

func set_text(value):
	$label.set_text(value)
