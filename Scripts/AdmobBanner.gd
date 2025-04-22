extends Node2D

func _ready():
	if SettingsManager.get_settings().ads == true:
		$AdMob.load_banner()

func close_banner():
	$AdMob.hide_banner()
