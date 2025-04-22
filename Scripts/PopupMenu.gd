extends PanelContainer

const DEBUG_MODE = false # release build alırken false yapın

func popup(text, is_debug_message, duration = 0):
	if is_debug_message and !DEBUG_MODE:
		return
	$vsplit/popup_label.text = text
	show()
	if duration != 0:
		$vsplit/center_button/ok_button.hide()
		yield(get_tree().create_timer(duration), "timeout")
		hide()
	else:
		$vsplit/center_button/ok_button.show()
	return true

func _on_ok_button_pressed():
	hide()
