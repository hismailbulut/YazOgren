extends PanelContainer

var _current_leaderboard_json
var _leaderboard_list_item = preload("res://Scenes/LeaderBoardListItem.tscn")

func _create_leaderboard():
	if !_is_empty():
		return
	var _player_name = SettingsManager.get_settings().name
	for p_id in _current_leaderboard_json.size():
		var ins = _leaderboard_list_item.instance()
		var name = _current_leaderboard_json[p_id].name
		var score = _current_leaderboard_json[p_id].score
		ins.initialize(p_id+1, name, score)
		if name == _player_name:
			ins.set_white()
		$scroll/grid.add_child(ins)

func _on_leaderboards_button_pressed():
	_clear_leaderboard()
	if visible:
		hide()
	else:
		if $HSDownloader.download_leaderboard():
			show()

func _clear_leaderboard():
	for i in range($scroll/grid.get_child_count()):
		$scroll/grid.get_child(i).queue_free()

func _is_empty():
	if $scroll/grid.get_child_count() <= 1:
		return true
	else:
		return false

func _on_HSDownloader_request_completed(result, response_code, headers, body):
	var json_result = JSON.parse(body.get_string_from_utf8()).result
	if json_result == null:
		var ins = _leaderboard_list_item.instance()
		ins.initialize("", "Bağlanılamadı", "")
		$scroll/grid.add_child(ins)
		return
	_current_leaderboard_json = json_result.dreamlo.leaderboard.entry
	_create_leaderboard()
