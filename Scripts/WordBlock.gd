extends Control

onready var game = get_tree().current_scene
var _vibration
var word: String # bu bloğa atanan string değer
var width # bu bloğun en uzun kelimesinin genişliği
var speed # bloğun aşağı doğru düşme hızı
var best: bool = false # bu blok şu anda odaklanılmış blok mu ?
var last_wrong_typed = false

func initialize(enword, trword):
	word = enword
	_vibration = SettingsManager.get_settings().vibration
	$colored_word/enword.set_text(enword)
	$colored_word/enword_red.set_text(enword)
	$colored_word/enword_color.set_text(enword)
	$second_word/trword.set_text(trword)
	$colored_word/enword_color.visible_characters = 0
	$colored_word/enword_red.visible_characters = 0

func _ready():
	if($colored_word/enword.get_minimum_size() >= $second_word/trword.get_minimum_size()):
		width = $colored_word/enword.get_minimum_size().x
	else:
		width = $second_word/trword.get_minimum_size().x
	var ranPosX = randi() % int(game.width -width -game.default_font.size *2)
	rect_global_position = Vector2(ranPosX, -40)

func _process(delta):
	speed = game.word_speed * delta
	rect_global_position.y += speed
	if(rect_global_position.y > game.text_edit.rect_global_position.y + 20):
		queue_free()
		game.missed_words += 1
		if SettingsManager.get_settings().sound:
			if(game.missed_words != game.max_missed_words):
				game.sounds.get_node("missed_sound").play()

func color_text_highlight(text: String): # yeşil katmanı açan method
	if(text.empty()):
		_set_hl_size(0, 0)
		return
	var hl_size = 0
	var wrong_typed = false
	for i in text.length():
		if(i >= word.length()):
			break
		if(text[i] == word[i]):
			hl_size += 1
		else:
			if best:
				wrong_typed = true
				break
			else:
				hl_size = 0
				break
	if(best):
		if(wrong_typed):
			if(last_wrong_typed != wrong_typed and _vibration):
				Input.vibrate_handheld(250)
			_set_hl_size(hl_size, text.length())
		else:
			_set_hl_size(hl_size, 0)
	else:
		_set_hl_size(hl_size, 0)
	last_wrong_typed = wrong_typed

func _set_hl_size(green_hl_size, red_hl_size):
	$colored_word/enword_color.visible_characters = green_hl_size
	$colored_word/enword_red.visible_characters = red_hl_size

func get_visible_chars(): # yeşil katmanın açık karakter sayısını döndürür
	return $colored_word/enword_color.visible_characters
