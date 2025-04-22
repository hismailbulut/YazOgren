extends Panel

var pause_icon = preload("res://ui/pause.png")
var resume_icon = preload("res://ui/right.png")
onready var pause_button = get_parent().get_node("PauseBTN")
onready var game = get_tree().current_scene

func open_menu_ads():
	get_tree().paused = true
	show()
	$vbox/buttons/resume_button.hide()
	$vbox/buttons/reward_button.show()
	$vbox/gameover_label.text = "İyi oyun."
	$vbox/score_label.text = str(game.correct_sentences)
	$vbox/info_label.text = "Devam etmek istersen reklam\nizleyebilirsin. Reklam izlemek\nsana 3 hak daha kazandırır."

func open_menu_no_ads():
	get_tree().paused = true
	show()
	$vbox/buttons/resume_button.hide()
	$vbox/buttons/reward_button.hide()
	$vbox/gameover_label.text = "İyi oyun."
	$vbox/score_label.text = str(game.correct_sentences)
	$vbox/info_label.text = ""

func save_hs():
	# TODO google play yüksek skorları eklenecek
	pass

func _on_pause_button_pressed():
	if(get_tree().paused == false):
		get_tree().paused = true
		pause_button.texture_normal = resume_icon
		show()
		$vbox/buttons/reward_button.hide()
		$vbox/buttons/resume_button.show()
		$vbox/gameover_label.text = "Oyun Duraklatıldı."
		$vbox/score_label.text = "Şu anki skorun: " + str(game.correct_sentences)
		$vbox/info_label.text = ""
	else:
		get_tree().paused = false
		pause_button.texture_normal = pause_icon
		hide()

func _on_home_button_pressed():
	go_back_to_main_menu()

func _on_resume_button_pressed():
	get_tree().paused = false
	pause_button.texture_normal = pause_icon
	hide()

func _on_reset_button_pressed():
	get_tree().paused = false
	save_hs()
	get_tree().reload_current_scene()

func _on_reward_button_pressed():
	game.admob_local.show_rewarded()

func on_rewarded():
	get_tree().paused = false
	game.is_reward_video_consumed = true
	game.max_missed_words = 6
	hide()

func on_rewarded_closed():
	open_menu_no_ads()

func go_back_to_main_menu():
	get_tree().paused = false
	OS.hide_virtual_keyboard()
	save_hs()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	if SettingsManager.get_settings().ads == true:
		game.admob_local.show_inter()
