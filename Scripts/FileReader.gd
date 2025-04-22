extends Node2D

var en_words = []
var tr_words = []

var used_en_words = []
var used_tr_words = []

func load_from_file(file_path : String):
	var file = File.new()
	var debug_int = 0
	file.open(file_path, File.READ)
	while(!file.eof_reached()):
		var current_line = file.get_line()
		var words = current_line.split("=")
		if(words.size() == 2):
			en_words.append(words[0])
			tr_words.append(words[1])
	file.close()

func set_word_to_used(id):
	used_en_words.append(en_words[id])
	used_tr_words.append(tr_words[id])
	en_words.remove(id)
	tr_words.remove(id)

func reset_words():
	en_words = used_en_words.duplicate()
	tr_words = used_tr_words.duplicate()
	used_en_words.clear()
	used_tr_words.clear()
