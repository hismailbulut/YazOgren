extends Node2D

# sabitler
const SPAWN_TIME = 3 # oyunun başında kelime oluşması için geçmesi gereken süreyi belirten sabit
const MIN_SPAWN_TIME = 1.7 # zorluk seviyesinin ulaşabileceği minimum spawn_time sabit
const WORD_SPEED = 20 # oyunun başında kelime için belirtilen hız sabit
const MAX_WORD_SPEED = 38 # zorluk seviyesinin ulaşabileceği maximum word_speed sabit
const SPAWN_TIME_DIFF = 250 # spawn_time hesaplaması için kullanılan sabit (arttıkça zorluk seviyesi düşer)
const WORD_SPEED_DIFF = 25 # word_speed hesaplaması için kullanılan sabit (arttıkça zorluk seviyesi düşer)
# kaynaklar
var word_block = preload("res://Scenes/WordBlock.tscn")
var default_font: DynamicFont = preload("res://Font/word-font.tres")
# çocuk node'ların kolay erişebilmesi için bazı çocuklar burada belirtilir
onready var text_edit = $main_control/SplitManager/GamePanel/TextEdit
onready var active_words = $main_control/SplitManager/GamePanel/ActiveWords
onready var admob_local = $AdmobLocal
onready var sounds = $Sounds
# cihaz ekran boyutu
var width # oyun alanının genişliği (x değeri)
var height # oyun alanının yüksekliği (y değeri)
# oyun içi değişkenler
var is_reward_video_consumed = false
var max_missed_words = 10 # gameover olması için kaçması gereken kelime sayısı
var game_time = 0 # saniye cinsinden toplam geçen süre (genel olarak oyun yönetimi için gereklidir)
var game_time_mins = 0 # dakika cinsinden toplam geçen süre
var word_time = 3 # yeni bir kelime oluşturması için tutulan süre (spawn_time değerine ulaşına sıfırlanır ve tekrar saymaya başlar)
var spawn_time = 0 # yeni kelimenin oluşması için gereken süre (zorluk seviyesine bağlı olarak değişmektedir)
var word_speed = 0 # kelimelerin düşme hızı (zorluk seviyesine bağlı olarak değişmektedir)
var key_press_count = 0 # doğru basılan tuş sayısı (saniyede basılan ortalama tuş sayısını hesaplamak için kullanılır)
var word_input_count = 0 # doğru yazılan kelime sayısı (dakikada yazılan kelime sayısını hesaplamak için kullanılır)
var correct_words = 0 # oyuncunun doğru girdiği kelime sayısı
var missed_words = 0 # oyuncunun giremediği kelime sayısı
var st = 0 # oyuncunun saniyede doğru bastığı tuş sayısı
var dk = 0 # oyuncunun dakikada doğru yazdığı kelime sayısı

func on_resize():
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y

func _ready():
	randomize()
	on_resize()
	$FileReader.load_from_file("res://Files/words.res")
	get_tree().connect("screen_resized", self, "on_resize")
	if SettingsManager.get_settings().ads == false:
		max_missed_words = 15
	$main_control/SplitManager/GamePanel/bg_color.color = SettingsManager.get_settings().background_color
	$main_control/SplitManager/GamePanel/gtp_color.color = SettingsManager.get_settings().gtp_color
	spawn_time = SPAWN_TIME
	word_speed = WORD_SPEED

func _process(delta):
	# zamanı geldiyse yeni kelime bloğunun oluşturulması
	if(word_time >= spawn_time):
		_spawn_word_block()
		word_time = 0
	else:
		word_time += delta
	# matematiksel hesaplamalar ve değişken değerlerinin atanması
	game_time += delta
	game_time_mins = game_time / 60
	if(spawn_time > MIN_SPAWN_TIME):
		spawn_time = SPAWN_TIME - game_time / SPAWN_TIME_DIFF # kelime oluşma süresi için zorluk seviyesi 
	if(word_speed < MAX_WORD_SPEED):
		word_speed = WORD_SPEED + game_time / WORD_SPEED_DIFF # kelimelerin hızı için zorluk seviyesi
	st = key_press_count / game_time
	dk = word_input_count / game_time_mins
	# üst bilgi ekranı değerlerinin yazdırılması
	$main_control/SplitManager/GamePanel/cm_labels/correct_label.text = ("Doğru: " + str(correct_words))
	$main_control/SplitManager/GamePanel/cm_labels/missed_label.text = ("Kaçırılan: " + str(missed_words) + "/" + str(max_missed_words))
	$main_control/SplitManager/GamePanel/cm_labels/st_label.text = ("ST: " + str(st).left(4))
	$main_control/SplitManager/GamePanel/cm_labels/dk_label.text = ("DK: " + str(int(dk)))
	$main_control/SplitManager/GamePanel/cm_labels/time_label.text = ("Süre: " + str(int(game_time)))
	# gameover
	if(missed_words >= max_missed_words):
		if SettingsManager.get_settings().ads == false:
			$main_control/SplitManager/GamePanel/PauseMenu.open_menu_no_ads()
		elif is_reward_video_consumed == true or admob_local._is_rewarded_loaded == false:
			$main_control/SplitManager/GamePanel/PauseMenu.open_menu_no_ads()
		else:
			$main_control/SplitManager/GamePanel/PauseMenu.open_menu_ads()

func _spawn_word_block():
	var ins = word_block.instance()
	if($FileReader.en_words.size() == 0):
		$FileReader.reset_words()
	var rand_word = (randi() % $FileReader.en_words.size() + 1) - 1
	ins.initialize($FileReader.en_words[rand_word], $FileReader.tr_words[rand_word])
	$FileReader.set_word_to_used(rand_word)
	active_words.add_child(ins)
