extends ColorRect

func initialize(rank, name, score):
	$hbox/rank_label.text = str(rank)
	$hbox/name_label.text = name
	$hbox/score_label.text = str(score)

func set_white():
	color = Color(SettingsManager.get_settings().gtp_color)
