extends VSplitContainer

var opened = false
var vk_timer = 2
var last_vk_height
onready var screen_height = ProjectSettings.get_setting("display/window/size/height")
onready var resolution = OS.get_window_size()

func _ready():
	if SettingsManager.get_settings().mykeyboard == true:
		OS.show_virtual_keyboard()
		last_vk_height = 0
		set_process(true)
	else:
		split_offset = screen_height * 75 / 100
		set_process(false)

func _process(delta):
	if(vk_timer > 3):
		var vk_height = OS.get_virtual_keyboard_height()
		if(vk_height > 0 and last_vk_height != vk_height):
			last_vk_height = vk_height
			var keyboard_height = int(vk_height * screen_height / resolution.y)
			split_offset = screen_height - keyboard_height
			print("Split offset: %s" % split_offset)
		vk_timer = 0
	else:
		vk_timer += delta
