extends PanelContainer

onready var mmenu = get_tree().current_scene
var _name
var unwanted = ["/", "*", "+", ".", ",", "#", "$", "½", "%", "&", "<", ">", "~", "£", "{", "}", "[", "]", 
				"(", ")", "=", "?", "|", "¨", ";", ":", "₺₺₺@", "!", "´", "'", '"', "é", "\\", "€"]
var tr_char =  ["ğ", "ü", "ş", "ı", "ö", "ç", "Ğ", "Ü", "Ş", "İ", "Ö", "Ç"]

func _on_name_save_button_pressed():
	_name = $vbox/name/name_edit.text
	if(_is_name_valid(_name)):
		if not $NameControl.control_name(_name):
			$vbox/warning_info.text = "Bir hata oluştu. Lütfen interneti açın ve uygulamayı yeniden başlatın."

func _is_name_valid(text: String):
	if text == "":
		$vbox/warning_info.text = "Lütfen bir kullanıcı adı gir."
		return false
	if text.length() < 3:
		$vbox/warning_info.text = "Kullanıcı adın bu kadar kısa olmamalı."
		return false
	for i in text:
		if i == " ":
			$vbox/warning_info.text = "Kullanıcı adın boşluk içeremez."
			return false
		for un in unwanted:
			if i == un:
				$vbox/warning_info.text = "Kullanıcı adın " + i + " karakterini içeremez."
				return false
		for tr in tr_char:
			if i == tr:
				$vbox/warning_info.text = "Lütfen türkçe karakter kullanmayın."
				return false
	return true

func save_name():
	var t_s = SettingsManager.get_settings()
	t_s.name = _name
	SettingsManager.save_settings(t_s)
	mmenu.rewrite_name()
	hide()

func _on_NameControl_request_completed(result, response_code, headers, body):
	if result != 0:
		$vbox/warning_info.text = "Lütfen internete bağlanın. Kullanıcı adınızı aldıktan sonra tekrar kapatabilirsiniz."
		return
	if body.get_string_from_utf8() == "":
		save_name()
	else:
		$vbox/warning_info.text = "Bu kullanıcı adı başkası tarafından alınmış."
