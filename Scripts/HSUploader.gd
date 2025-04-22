extends HTTPRequest

const URL = "http://dreamlo.com/lb/"
const PRIVATE_CODE = "<your-private-key-here>"

func upload_new_highscore(name, score):
	var err = request(URL + PRIVATE_CODE + "/add/" + name + "/" + str(score))
	if err != OK:
		print("HS Upload Failed")
