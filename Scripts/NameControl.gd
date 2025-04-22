extends HTTPRequest

const URL = "http://dreamlo.com/lb/"
const PUBLIC_CODE = "<your-public-key-here>"

func control_name(name):
	var err = request(URL + PUBLIC_CODE + "/pipe-get/" + name)
	if err != OK:
		return false
	return true
