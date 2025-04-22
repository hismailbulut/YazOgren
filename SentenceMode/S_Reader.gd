extends Node2D

var en_sents = []
var tr_sents = []

var used_en_sents = []
var used_tr_sents = []

func load_from_file(file_path : String):
	var file = File.new()
	var debug_int = 0
	file.open(file_path, File.READ)
	while(!file.eof_reached()):
		var current_line = file.get_line()
		var words = current_line.split("=")
		if(words.size() == 2):
			en_sents.append(words[0])
			tr_sents.append(words[1])
	file.close()

func set_word_to_used(id):
	used_en_sents.append(en_sents[id])
	used_tr_sents.append(tr_sents[id])
	en_sents.remove(id)
	tr_sents.remove(id)

func reset_words():
	en_sents = used_en_sents.duplicate()
	tr_sents = used_tr_sents.duplicate()
	used_en_sents.clear()
	used_tr_sents.clear()
