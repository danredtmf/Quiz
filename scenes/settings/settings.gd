extends PanelContainer

signal closing

func _ready():
	_config()

func _config():
	_set_center_screen()
	update_ui()
	_start_animation()

func _process(_delta):
	update_ui()

func _set_center_screen():
	rect_pivot_offset = rect_size / 2
	set_anchors_preset(Control.PRESET_CENTER, true)

func update_ui():
	$VB/Header/Info.text = tr('settings')
	$VB/Scroll/VB/Lang/VB/Header/Info.text = tr('lang')
	
	$VB/Scroll/VB/Lang/VB/Lang.selected = Data.data_settings.current_lang
	
	$VB/Scroll/VB/Lang/VB/Lang.set_item_text(0, tr('en'))
	$VB/Scroll/VB/Lang/VB/Lang.set_item_text(1, tr('ru'))
	$VB/Scroll/VB/Lang/VB/Lang.set_item_text(2, tr('eo'))
	
	$VB/Buttons/Close.text = tr('close')

func _start_animation():
	$Animation.play("show")

func _end_animation():
	$Animation.play("hide")

func _on_Animation_animation_finished(anim_name):
	if anim_name == "hide":
		emit_signal("closing")
		queue_free()

func _on_Site_pressed():
	var err = OS.shell_open("https://danredtmf.github.io")
	if err == OK:
		print('Open link...')

func _on_Close_pressed():
	_end_animation()

func _on_Lang_item_selected(index):
	match index:
		DataSettings.LANG.ENGLISH:
			Data.data_settings.set_en()
		DataSettings.LANG.RUSSIAN:
			Data.data_settings.set_ru()
		DataSettings.LANG.ESPERANTO:
			Data.data_settings.set_eo()
#	Data.saving_settings()
