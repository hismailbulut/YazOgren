extends Node2D

var _ads = false
var _is_intersititial_loaded = false
var _is_rewarded_loaded = false
var _is_rewarded = false

func _ready():
	if SettingsManager.get_settings().ads == true:
		#$AdMob.load_interstitial()
		$AdMob.load_rewarded_video()
		_ads = true
	else:
		_ads = false

func show_inter():
	if _is_intersititial_loaded and _ads:
		$AdMob.show_interstitial()
		return true
	else:
		return false

func show_rewarded():
	if _is_rewarded_loaded and _ads:
		$AdMob.show_rewarded_video()
		return true
	else:
		return false

func _on_AdMob_rewarded(currency, ammount):
	_is_rewarded = true

func _on_AdMob_rewarded_video_closed():
	if _is_rewarded:
		get_parent().get_node("canvas/Splitter/GamePanel/PauseMenu").on_rewarded()
	else:
		get_parent().get_node("canvas/Splitter/GamePanel/PauseMenu").on_rewarded_closed()

func _on_AdMob_interstitial_failed_to_load(error_code):
	_is_intersititial_loaded = false

func _on_AdMob_interstitial_loaded():
	_is_intersititial_loaded = true

func _on_AdMob_rewarded_video_failed_to_load(error_code):
	_is_rewarded_loaded = false

func _on_AdMob_rewarded_video_loaded():
	_is_rewarded_loaded = true
