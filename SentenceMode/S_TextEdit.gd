extends TextEdit

onready var game = get_tree().current_scene
var _vibration
var _sound

func _ready():
	var _t_s = SettingsManager.get_settings()
	_vibration = _t_s.vibration
	_sound = _t_s.sound
	var mykb = _t_s.mykeyboard
	virtual_keyboard_enabled = mykb
	if mykb:
		grab_focus()

func _on_TextEdit_text_changed():
	var current_sent = game.sentences.current_sentence
	if current_sent in text:
		clear_text()
		game.key_press_count += current_sent.length()
		game.word_input_count += current_sent.split(" ").size()
		game.correct_sentences += 1
		if _sound:
			game.sounds.get_node("correct_sound").play()
		game.spawn_new_sentence()
	game.sentences.color_text_highlight(text)

func clear_text():
	set_text("")
	emit_signal("text_changed")
	if(OS.get_virtual_keyboard_height() > 0):
		#OS.show_virtual_keyboard(text, true)
		OS.show_virtual_keyboard()

func backspace_erase():
	if(text.length() > 0):
		text = text.left(text.length()-1)
		emit_signal("text_changed")

func add_value(txt):
	text = text + txt
	emit_signal("text_changed")
