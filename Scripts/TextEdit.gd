extends LineEdit

onready var game = get_tree().current_scene
var _vibration

func _ready():
	_vibration = SettingsManager.get_settings().vibration
	var mykb = SettingsManager.get_settings().mykeyboard
	virtual_keyboard_enabled = mykb
	clear_button_enabled = mykb
	if mykb:
		grab_focus()

func _on_TextEdit_text_changed(new_text: String):
	# hangisinin best olduğunu yeni karakterlere göre tekrar belirler
	if(new_text.empty()):
		game.active_words.reset_best()
	else:
		game.active_words.get_current_best()
	# şu andaki bütün blokları denetler
	var cur_active_words = game.active_words.get_active_words()
	for i in cur_active_words:
		#var t_label: Label = i.get_node("colored_word").get_node("enword")
		if(new_text == i.word):
			game.key_press_count += i.word.length()
			game.word_input_count += 1
			clear_text()
			i.queue_free()
			game.correct_words += 1
			if SettingsManager.get_settings().sound:
				game.sounds.get_node("correct_sound").play()
		i.color_text_highlight(text)

func clear_text():
	clear()
	if(OS.get_virtual_keyboard_height() > 0):
		OS.show_virtual_keyboard()
	emit_signal("text_changed", text)

func backspace_erase():
	if(text.length() > 0):
		text = text.left(text.length()-1)
		emit_signal("text_changed", text)

func add_value(txt):
	text = text + txt
	emit_signal("text_changed", text)
