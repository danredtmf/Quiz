extends PanelContainer

signal closing

onready var header_win = $VB/Header/Info

onready var lang_header_info = $VB/Scroll/HB/VB/Lang/VB/Header/Info
onready var lang_menu = $VB/Scroll/HB/VB/Lang/VB/Lang

onready var volume_header_info = $VB/Scroll/HB/VB/Volume/VB/Header/Info
onready var general_header_info = $VB/Scroll/HB/VB/Volume/VB/VB/General/VB/Header/Info
onready var music_header_info = $VB/Scroll/HB/VB/Volume/VB/VB/Music/VB/Header/Info
onready var sound_header_info = $VB/Scroll/HB/VB/Volume/VB/VB/Sound/VB/Header/Info

onready var general_slider = $VB/Scroll/HB/VB/Volume/VB/VB/General/VB/VB/GeneralSlider
onready var music_slider = $VB/Scroll/HB/VB/Volume/VB/VB/Music/VB/VB/MusicSlider
onready var sound_slider = $VB/Scroll/HB/VB/Volume/VB/VB/Sound/VB/VB/SoundSlider

onready var general_info = $VB/Scroll/HB/VB/Volume/VB/VB/General/VB/VB/Info
onready var music_info = $VB/Scroll/HB/VB/Volume/VB/VB/Music/VB/VB/Info
onready var sound_info = $VB/Scroll/HB/VB/Volume/VB/VB/Sound/VB/VB/Info

onready var close_btn = $VB/Buttons/Close

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
	header_win.text = tr('settings')
	
	_lang_info()
	_volume_info()
	
	close_btn.text = tr('close')

func _lang_info():
	lang_header_info.text = tr('lang')
	
	lang_menu.selected = Data.data_settings.current_lang
	
	lang_menu.set_item_text(0, tr('en'))
	lang_menu.set_item_text(1, tr('ru'))
	lang_menu.set_item_text(2, tr('eo'))

func _volume_info():
	volume_header_info.text = tr('volume')
	general_header_info.text = tr('volume_general')
	music_header_info.text = tr('volume_music')
	sound_header_info.text = tr('volume_sound')
	
	general_info.text = str(
		int(
			lerp(0, 1, 
			((general_slider.value + -general_slider.min_value) * 100) / -general_slider.min_value)
		)
	) + ' %'
	music_info.text = str(
		int(
			lerp(0, 1, 
			((music_slider.value + -music_slider.min_value) * 100) / -music_slider.min_value)
		)
	) + ' %'
	sound_info.text = str(
		int(
			lerp(0, 1, 
			((sound_slider.value + -sound_slider.min_value) * 100) / -sound_slider.min_value)
		)
	) + ' %'
	
	general_slider.value = Data.data_settings.volume_master
	music_slider.value = Data.data_settings.volume_music
	sound_slider.value = Data.data_settings.volume_sounds

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
	Data.data_achievements.check_achievement()

func _on_GeneralSlider_value_changed(value):
	Data.data_settings.volume_master = value
	if value > general_slider.min_value:
		AudioServer.set_bus_mute(Data.master_idx, false)
		AudioServer.set_bus_volume_db(Data.master_idx, Data.data_settings.volume_master)
	else:
		AudioServer.set_bus_mute(Data.master_idx, true)
	Data.data_settings.saving()
	Data.data_achievements.check_achievement()

func _on_MusicSlider_value_changed(value):
	Data.data_settings.volume_music = value
	if value > music_slider.min_value:
		AudioServer.set_bus_mute(Data.music_idx, false)
		AudioServer.set_bus_volume_db(Data.music_idx, Data.data_settings.volume_music)
	else:
		AudioServer.set_bus_mute(Data.music_idx, true)
	Data.data_settings.saving()
	Data.data_achievements.check_achievement()

func _on_SoundSlider_value_changed(value):
	Data.data_settings.volume_sounds = value
	if value > sound_slider.min_value:
		AudioServer.set_bus_mute(Data.sound_idx, false)
		AudioServer.set_bus_volume_db(Data.sound_idx, Data.data_settings.volume_sounds)
	else:
		AudioServer.set_bus_mute(Data.sound_idx, true)
	Data.data_settings.saving()
	Data.data_achievements.check_achievement()

func _on_ResetProgress_pressed():
	Data.clear_player()

func _on_ResetSettings_pressed():
	Data.clear_settings()

func _on_ResetAchievements_pressed():
	Data.clear_achievements()
