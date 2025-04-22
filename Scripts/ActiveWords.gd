extends Node2D

func get_active_words():
	var t_arr = []
	for i in get_child_count():
		t_arr.append(get_child(i))
	return t_arr

func clear_all():
	for i in range(get_child_count()):
		get_child(i).queue_free()

func get_current_best(): # best olanı işaretler ve döndürür
	var allwords = get_active_words()
	var colored_word_count = 0
	for wordblock in allwords:
		if(wordblock.get_visible_chars() > 0):
			colored_word_count += 1
	var current_best = null
	if colored_word_count == 1:
		for word in allwords:
			if(word.get_visible_chars() > 0):
				current_best = word
				word.best = true
			else:
				word.best = false
	return current_best

func reset_best():
	var allwords = get_active_words()
	for word in allwords:
		word.best = false
