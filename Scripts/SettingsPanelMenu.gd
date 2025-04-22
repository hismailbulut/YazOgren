extends PanelContainer

var button_colors = ["blue", "green", "red", "yellow"]

func _on_save_button_pressed():
	var items = $vbox/styles.get_selected_items()
	var bg_color = $vbox/bg_color_picker.color
	var gtp_color = $vbox/gtp_color_picker.color
	var _mykeyboard = $vbox/mykb/mykb_check.pressed
	var _vibration = $vbox/vibration/vibration_check.pressed
	var t_st = SettingsManager.get_settings()
	if not items.empty():
		t_st.button_color = button_colors[items[0]]
	t_st.background_color = bg_color.to_html(false)
	t_st.gtp_color = gtp_color.to_html(false)
	t_st.mykeyboard = _mykeyboard
	t_st.vibration = _vibration
	SettingsManager.save_settings(t_st)
	get_tree().reload_current_scene()
