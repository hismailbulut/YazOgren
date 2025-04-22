extends Node2D

# sabitler
const GIVEN_TIME_PER_CHAR = 2.1 # başlangıçta her karakter için verilen süre
const MIN_TIME_PER_CHAR = 0.6
const TIME_DIFF = 120 # arttıkça oyun zorluğu düşer
# çocuk node'ların kolay erişebilmesi için bazı çocuklar burada belirtilir
onready var text_edit = get_node("canvas/Splitter/GamePanel/TextEdit")
onready var admob_local = get_node("Admob")
onready var count_down_bar = get_node("canvas/Splitter/GamePanel/BG/Sentences/countdownbar")
onready var sentences = get_node("canvas/Splitter/GamePanel/BG/Sentences")
onready var sounds = get_node("Sounds")
# oyun içi değişkenler
var is_reward_video_consumed = false
var time_per_char # her karakter için verilen süre (oyun süresine bağlı olarak azalır)
var total_sentence_time # tüm cümle için verilen toplam süre
var max_missed_words = 3 # gameover olması için kaçması gereken kelime sayısı
var game_time = 0 # saniye cinsinden toplam geçen süre (genel olarak oyun yönetimi için gereklidir)
var game_time_mins = 0 # dakika cinsinden toplam geçen süre
var key_press_count = 0 # doğru basılan tuş sayısı (saniyede basılan ortalama tuş sayısını hesaplamak için kullanılır)
var word_input_count = 0 # doğru yazılan kelime sayısı (dakikada yazılan kelime sayısını hesaplamak için kullanılır)
var correct_sentences = 0 # oyuncunun tamamladığı kelime sayısı
var missed_sentences = 0 # oyuncunun tamamlayamadığı kelime sayısı
var st = 0 # oyuncunun saniyede doğru bastığı tuş sayısı
var dk = 0 # oyuncunun dakikada doğru yazdığı kelime sayısı

func _ready():
	randomize()
	$SentReader.load_from_file("res://Files/sentences.res")
	if SettingsManager.get_settings().ads == false:
		max_missed_words = 6
	# oyun içi yapılması gereken ayarlar
	$canvas/Splitter/GamePanel/BG.color = SettingsManager.get_settings().background_color
	$canvas/Splitter/GamePanel/TopPanelBG.color = SettingsManager.get_settings().gtp_color
	time_per_char = GIVEN_TIME_PER_CHAR
	spawn_new_sentence()

func _process(delta):
	# matematiksel hesaplamalar
	game_time += delta
	game_time_mins = game_time / 60
	st = key_press_count / game_time
	dk = word_input_count / game_time_mins
	# üst panodaki label textlerinin değiştirilmesi
	$canvas/Splitter/GamePanel/TopLabels/correct_label.text = ("Doğru: " + str(correct_sentences))
	$canvas/Splitter/GamePanel/TopLabels/missed_label.text = ("Kaçırılan: " + str(missed_sentences) + "/" + str(max_missed_words))
	$canvas/Splitter/GamePanel/TopLabels/st_label.text = ("ST: " + str(st).left(4))
	$canvas/Splitter/GamePanel/TopLabels/dk_label.text = ("DK: " + str(int(dk)))
	$canvas/Splitter/GamePanel/TopLabels/time_label.text = ("Süre: " + str(int(game_time)))
	# gameover kontrolü burada yapılır
	if(missed_sentences == max_missed_words):
		if SettingsManager.get_settings().ads == false:
			$canvas/Splitter/GamePanel/PauseMenu.open_menu_no_ads()
		elif is_reward_video_consumed == true or admob_local._is_rewarded_loaded == false:
			$canvas/Splitter/GamePanel/PauseMenu.open_menu_no_ads()
		else:
			$canvas/Splitter/GamePanel/PauseMenu.open_menu_ads()

func spawn_new_sentence(): # yeni kelime oluşturur
	if($SentReader.en_sents.size() == 0):
		$SentReader.reset_words()
	var rand_word = (randi() % $SentReader.en_sents.size() + 1) - 1
	var new_en_sent: String = $SentReader.en_sents[rand_word]
	$canvas/Splitter/GamePanel/BG/Sentences.set_sentence(new_en_sent, $SentReader.tr_sents[rand_word])
	$SentReader.set_word_to_used(rand_word)
	# yeni cümle için hesaplamalar
	if(time_per_char > MIN_TIME_PER_CHAR):
		time_per_char = GIVEN_TIME_PER_CHAR - game_time / TIME_DIFF
	else:
		time_per_char = MIN_TIME_PER_CHAR
	total_sentence_time = (new_en_sent.length() - new_en_sent.count(" ")) * time_per_char
	sentences.set_timer_wait_time(total_sentence_time)
	#print("tpc: %s, total: %s, length: %s" % [time_per_char, total_sentence_time, new_en_sent.length()])
