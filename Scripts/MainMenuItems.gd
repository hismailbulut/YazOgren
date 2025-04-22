extends CanvasLayer

func _ready():
	create_button_color_itemlist()
	prepare_color_pickers()
	prepare_sound_icon()

func create_button_color_itemlist():
	var itemlist = $parent_control/SettingsPanelMenu/vbox/styles
	itemlist.add_item("mavi", load("res://ui/blue_button_1.png"))
	itemlist.add_item("yeşil", load("res://ui/green_button_1.png"))
	itemlist.add_item("turuncu", load("res://ui/red_button_1.png"))
	itemlist.add_item("sarı", load("res://ui/yellow_button_1.png"))

func prepare_color_pickers():
	var sm = SettingsManager.get_settings()
	$parent_control/SettingsPanelMenu/vbox/bg_color_picker.color = Color(sm.background_color)
	$parent_control/SettingsPanelMenu/vbox/gtp_color_picker.color = Color(sm.gtp_color)
	$parent_control/SettingsPanelMenu/vbox/mykb/mykb_check.pressed = sm.mykeyboard

func prepare_sound_icon():
	if SettingsManager.get_settings().sound == true:
		$parent_control/bottom_container/sounds_button.texture_normal = load("res://ui/audioOn.png")
	else:
		$parent_control/bottom_container/sounds_button.texture_normal = load("res://ui/audioOff.png")

func _on_start_button_pressed():
	var err = get_tree().change_scene("res://Scenes/Game.tscn")
	if err != OK:
		print("Error: %s" % err)
	get_parent().get_node("AdmobBanner").close_banner()

func _on_sentence_mode_button_pressed():
	var err = get_tree().change_scene("res://SentenceMode/SentenceMode.tscn")
	if err != OK:
		print("Error: %s" % err)
	get_parent().get_node("AdmobBanner").close_banner()

func _on_close_button_pressed():
	$parent_control/SettingsPanelMenu.hide()

func _on_settings_button_pressed():
	$parent_control/SettingsPanelMenu.show()
	$parent_control/SettingsPanelMenu/vbox/mykb/mykb_check.pressed = SettingsManager.get_settings().mykeyboard
	$parent_control/SettingsPanelMenu/vbox/vibration/vibration_check.pressed = SettingsManager.get_settings().vibration

func _on_exit_button_pressed():
	get_tree().quit()

func _on_sounds_button_pressed():
	var t_s = SettingsManager.get_settings()
	if t_s.sound == true:
		t_s.sound = false
		SettingsManager.save_settings(t_s)
		$parent_control/bottom_container/sounds_button.texture_normal = load("res://ui/audioOff.png")
	else:
		t_s.sound = true
		SettingsManager.save_settings(t_s)
		$parent_control/bottom_container/sounds_button.texture_normal = load("res://ui/audioOn.png")

func _on_help_button_pressed():
	if $parent_control/InfoMenu.visible == false:
		$parent_control/InfoMenu.show()
	else:
		$parent_control/InfoMenu.hide()
