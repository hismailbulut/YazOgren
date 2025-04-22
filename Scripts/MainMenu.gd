extends Node2D

onready var popup_dialog = $MainMenuItems/PopupMenu
onready var remove_ads_button = $MainMenuItems/parent_control/middle_buttons_container/center/remove_ads_button
onready var admob_banner = $AdmobBanner
onready var name_menu = $MainMenuItems/parent_control/NameMenu
onready var start_button = $MainMenuItems/parent_control/middle_buttons_container/start_button
onready var sentence_mode_button = $MainMenuItems/parent_control/middle_buttons_container/sentence_mode_button
onready var bg_color_container = $MainMenuItems/background_color
onready var hs_label = $MainMenuItems/parent_control/middle_buttons_container/hs_label
onready var welcome_label = $MainMenuItems/parent_control/middle_buttons_container/welcome_label

func _ready():
	if SettingsManager.get_settings().name == "":
		name_menu.show()
	if SettingsManager.get_settings().ads == false:
		remove_ads_button.hide()
	start_button.set_text("Kelime Modu")
	sentence_mode_button.set_text("Cümle Modu")
	bg_color_container.color = SettingsManager.get_settings().background_color
	rewrite_name()
	hs_label.text = ("Yüksek skorun\n" + str(int(SettingsManager.get_highscore().correct)))

func rewrite_name():
	welcome_label.text = ("Hoşgeldin\n" + SettingsManager.get_settings().name)
