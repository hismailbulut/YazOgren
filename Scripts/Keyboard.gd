extends VBoxContainer

var h1_keys = ["'",'"',"?","!",".","clear"]
var h2_keys = ["q","w","e","r","t","y","u","i","o","p"]
var h3_keys = ["a","s","d","f","g","h","j","k","l"]
var h4_keys = ["caps","z","x","c","v","b","n","m","back"]

var keyboard_button = preload("res://Scenes/DefaultButton.tscn")

onready var game = get_tree().current_scene

func _ready():
	if SettingsManager.get_settings().mykeyboard == false:
		create_keyboard()

func create_keyboard():
	for i in h1_keys:
		create_key(i, $h_1)
	for i in h2_keys:
		create_key(i, $h_2)
	for i in h3_keys:
		create_key(i, $h_3)
	for i in h4_keys:
		create_key(i, $h_4)

func create_key(text, parent_node):
	var ins: TextureButton = keyboard_button.instance()
	ins.initialize(text, true)
	ins.connect("pressed", self, "on_key_pressed", [ins])
	parent_node.add_child(ins)

func on_key_pressed(key):
	if key.get_text() == "caps" or key.get_text() == "CAPS":
		toggle_caps()
	elif key.get_text() == "back" or key.get_text() == "BACK":
		game.text_edit.backspace_erase()
	elif key.get_text() == "clear" or key.get_text() == "CLEAR":
		game.text_edit.clear_text()
	else:
		game.text_edit.add_value(key.get_text())
		if key.is_upper():
			toggle_caps()
	if SettingsManager.get_settings().sound == true:
		game.sounds.get_node("click_sound").play()

func toggle_caps(): # bu fonksiyon capslock açar ve kapatır
	for i in $h_1.get_child_count():
		var key = $h_1.get_child(i)
		if key.is_upper():
			key.set_lower()
		else:
			key.set_upper()
	for i in $h_2.get_child_count():
		var key = $h_2.get_child(i)
		if key.is_upper():
			key.set_lower()
		else:
			key.set_upper()
	for i in $h_3.get_child_count():
		var key = $h_3.get_child(i)
		if key.is_upper():
			key.set_lower()
		else:
			key.set_upper()
	for i in $h_4.get_child_count():
		var key = $h_4.get_child(i)
		if key.is_upper():
			key.set_lower()
		else:
			key.set_upper()
