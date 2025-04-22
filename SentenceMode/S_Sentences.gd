extends VBoxContainer

onready var game = get_tree().current_scene
var current_sentence: String # şu anki ingilizce cümle
var last_wrong_typed: bool
var _vibration: bool
var _sound: bool

func _ready():
	var _t_s = SettingsManager.get_settings()
	_vibration = _t_s.vibration
	_sound = _t_s.sound

func set_sentence(en_sent, tr_sent):
	current_sentence = en_sent
	$en_center/en.text = en_sent
	$en_center/en_red.text = en_sent
	$en_center/en_green.text = en_sent
	$tr_center/tr.text = tr_sent
	$en_center/en_red.visible_characters = 0
	$en_center/en_green.visible_characters = 0

func set_timer_wait_time(time):
	$countdowntimer.start(time)

func _on_countdowntimer_timeout():
	game.missed_sentences += 1
	if _sound and game.missed_sentences != game.max_missed_words:
		game.sounds.get_node("missed_sound").play()
		game.text_edit.clear_text()
	game.spawn_new_sentence()

func _process(delta):
	if($countdowntimer.time_left <= 0):
		$countdownbar.value = 0
	else:
		$countdownbar.value = 100 * $countdowntimer.time_left / $countdowntimer.wait_time
		if $countdownbar.value < 20:
			$countdownbar.set_tint_progress(Color.red)
		elif $countdownbar.value < 50:
			$countdownbar.set_tint_progress(Color.yellow)
		else:
			$countdownbar.set_tint_progress(Color.green)

func color_text_highlight(text: String):
	if(text.empty()):
		_set_hl_size(0, 0)
		return
	var hl_size = 0
	var wrong_typed = false
	for i in text.length():
		if(i >= current_sentence.length()):
			break
		elif(text[i] == current_sentence[i]):
			if(text[i] != " "):
				hl_size += 1
		else:
			wrong_typed = true
			break
	if(wrong_typed):
		if(last_wrong_typed != wrong_typed and _vibration):
			Input.vibrate_handheld(250)
		_set_hl_size(hl_size, text.length() - text.count(" "))
	else:
		_set_hl_size(hl_size, 0)
	last_wrong_typed = wrong_typed

func _set_hl_size(green_hl_size, red_hl_size):
	$en_center/en_green.visible_characters = green_hl_size
	$en_center/en_red.visible_characters = red_hl_size
