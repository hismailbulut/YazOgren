extends Node
# dosya yolları ve şifreleme anahtarı
const _HS_FILE_PATH = "user://highscore.dat"
const _SETTINGS_FILE_PATH = "user://settings.dat"
const _FILE_ENCRYPT_PASS = "z3xxxJ4tjALVAB@dFH=WVxQ7?y@&b=5KG2Mx"
# dosyalar
var _highscore_file: File
var _settings_file: File
# kontrol dosyaları - dosyalarda eksik keyler olup olmadığını kontrol etmek içindir
var _highscore_control = ["correct", "missed", "st", "dk", "time"]
var _settings_control = ["ads", "name", "button_color", "background_color", "gtp_color", "sound", "mykeyboard", "vibration"]
# varsayılan ayarlar
var _default_highscore = {
	"correct" : 0,
	"missed"  : 0,
	"st"      : 0,
	"dk"      : 0,
	"time"    : 0
}
var _default_settings = {
	"ads"              : true,
	"name"             : "",
	"button_color"     : "blue",
	"background_color" : "6b958c",
	"gtp_color"        : "04633d",
	"sound"            : true,
	"mykeyboard"       : false,
	"vibration"        : true
}
# geçerli ayarlar - eğer oyun ilk defa açılıyorsa varsayılan ayarlara eşitlenirler
var _highscore: Dictionary
var _settings: Dictionary

func _ready():
	_highscore_file = File.new()
	_settings_file = File.new()
	_control_files()
	_load_files()

func _control_files(): # dosyaların yerinde olup olmadığını ve hatalarını kontrol eder ve düzeltir
	if not _highscore_file.file_exists(_HS_FILE_PATH):
		_repair_highscore()
		print("hs file created")
	if not _settings_file.file_exists(_SETTINGS_FILE_PATH):
		_repair_settings()
		print("st file created")
	var temp_highscore = _read_from_file(_highscore_file, _HS_FILE_PATH)
	var temp_settings = _read_from_file(_settings_file, _SETTINGS_FILE_PATH)
	if temp_highscore == null:
		_repair_highscore()
		print("hs null")
	if temp_settings == null:
		_repair_settings()
		print("st null")
	if not temp_highscore.has_all(_highscore_control):
		_repair_highscore()
		print("hs file broken")
	if not temp_settings.has_all(_settings_control):
		_repair_settings()
		print("st file broken")

func _load_files(): # dosyaları belleğe yükler
	_highscore = _read_from_file(_highscore_file, _HS_FILE_PATH)
	_settings = _read_from_file(_settings_file, _SETTINGS_FILE_PATH)

func _repair_highscore(): # higscore dosyasını yeniden oluşturur
	_write_to_file(_highscore_file, _HS_FILE_PATH, _default_highscore)

func _repair_settings(): # settings dosyasını varolan ayarları değiştirmeden onarır
	var temp_settings = _read_from_file(_settings_file, _SETTINGS_FILE_PATH)
	if temp_settings == null:
		_write_to_file(_settings_file, _SETTINGS_FILE_PATH, _default_settings)
		return
	for key in _default_settings.keys():
		if temp_settings.has(key) != true:
			temp_settings[key] = _default_settings.get(key)
	_write_to_file(_settings_file, _SETTINGS_FILE_PATH, temp_settings)

func _write_to_file(file: File, path: String, value: Dictionary): # verilen parametreyi verilen dosyaya yazar
	var err = file.open_encrypted_with_pass(path, File.WRITE, _FILE_ENCRYPT_PASS)
	if err != OK:
		return
	file.store_string(to_json(value))
	file.close()

func _read_from_file(file: File, path: String): # dosyadan okur ve döndürür
	var err = file.open_encrypted_with_pass(path, File.READ, _FILE_ENCRYPT_PASS)
	if err != OK:
		return
	var value = JSON.parse(file.get_as_text()).result
	file.close()
	return value

func save_highscore(value: Dictionary): # yeni yüksek skoru kaydeder
	var temp = _read_from_file(_highscore_file, _HS_FILE_PATH)
	if value.correct > temp.correct:
		_write_to_file(_highscore_file, _HS_FILE_PATH, value)
		_load_files()
		return true
	return false

func is_new_highscore(value): # verilen değerin yüksek skor olup olmadığını hesaplar ve döndürür
	var temp = _read_from_file(_highscore_file, _HS_FILE_PATH)
	if value.correct > temp.correct:
		return true
	else:
		return false

func save_settings(value: Dictionary): # yeni ayarları kaydeder
	_write_to_file(_settings_file, _SETTINGS_FILE_PATH, value)
	_load_files()

func get_highscore(): # yüksek skoru döndürür
	return _highscore.duplicate()

func get_settings(): # ayarları döndürür
	return _settings.duplicate()

func disable_ads(): # reklamları kaldırır
	var t_st = get_settings()
	t_st.ads = false
	save_settings(t_st)

func enable_ads(): # debug only # sorun olursa korsan önleme amaçlı da kullanılabilir
	var t_st = get_settings()
	t_st.ads = true
	save_settings(t_st)

func reset_settings(): # debug only
	_write_to_file(_settings_file, _SETTINGS_FILE_PATH, _default_settings)
	_write_to_file(_highscore_file, _HS_FILE_PATH, _default_highscore)
