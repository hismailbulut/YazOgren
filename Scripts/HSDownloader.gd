extends HTTPRequest

const URL = "http://dreamlo.com/lb/"
const PUBLIC_CODE = "<your-public-key-here>"

func download_leaderboard():
	var err = request(URL + PUBLIC_CODE + "/json")
	if err != OK:
		return false
	return true
