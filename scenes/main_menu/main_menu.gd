extends Control

func _ready():
	_config()

func _start_animation():
	$AnimReady.play("show")

func _end_animation():
	$AnimReady.play("hide")

func _config():
	$Margin/Panel/VB/Name.text = ProjectSettings.get_setting('application/config/name')
	update_ui()
	
	$Version.text = ProjectSettings.get_setting('application/config/version') + " "
	$Version.set_anchors_and_margins_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
	
	_start_animation()

func _process(_delta):
	update_ui()

func update_ui():
	$Margin/Panel/VB/Buttons/Play.text = tr('play')
	$Margin/Panel/VB/Buttons/Settings.text = tr('settings')
	$Margin/Panel/VB/Buttons/About.text = tr('about')
	$Margin/Panel/VB/Buttons/Exit.text = tr('exit')

func _on_AnimReady_animation_finished(anim_name):
	if anim_name == "show":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif anim_name == "hide":
		yield(get_tree().create_timer(1), "timeout")
		if Data.splash_screen_is_appeared:
			Data.clear_data()
			Core.load_scene("game", Core.game_res)

func _on_Exit_pressed():
	get_tree().quit()

func _on_Play_pressed():
	if Data.is_server_exists:
		var send_data_win = Core.send_data_question_res.instance()
		add_child(send_data_win)
		send_data_win.connect("pressed", self, "_on_pressed_send_data_win")
	else:
		_end_animation()

func _on_About_pressed():
	var about_win = Core.about_res.instance()
	add_child(about_win)
	about_win.connect("closing", self, "_on_closing_about_win")
	$Margin/Panel/VB/Buttons/About.disabled = true

func _on_Settings_pressed():
	var settings_win = Core.settings_res.instance()
	add_child(settings_win)
	settings_win.connect("closing", self, "_on_closing_settings_win")
	$Margin/Panel/VB/Buttons/Settings.disabled = true

func _on_pressed_send_data_win():
	_end_animation()

func _on_closing_about_win():
	$Margin/Panel/VB/Buttons/About.disabled = false

func _on_closing_settings_win():
	$Margin/Panel/VB/Buttons/Settings.disabled = false
