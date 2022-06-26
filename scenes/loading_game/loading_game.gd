extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	yield(get_tree().create_timer(1), "timeout")
	if Data.splash_screen_is_appeared:
		Core.load_scene("main_menu", Core.main_menu_res)
	else:
		Core.load_scene("splash_screen", Core.splash_screen_res)
