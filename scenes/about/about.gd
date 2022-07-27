extends PanelContainer

signal closing

onready var version_game = $VB/Scroll/List/Main/GameVersion/Info
onready var version_engine = $VB/Scroll/List/Main/GameEngine/Info

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
	$VB/Header/Info.text = tr('about')
	
	version_game.text = ProjectSettings.get_setting("application/config/version")
	version_engine.text = Engine.get_version_info()["string"]
	
	$VB/Scroll/List/Info.text = tr('about_info') % [ProjectSettings.get_setting("application/config/version"), Engine.get_version_info()["string"]]
	
	$VB/Scroll/List/Main/GameAuthor/Site.text = tr('site')
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
# warning-ignore:return_value_discarded
	OS.shell_open("https://danredtmf.github.io/dev.html")

func _on_Close_pressed():
	_end_animation()

func _on_BtnLicense_in_Music1_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://creativecommons.org/licenses/by/4.0/")

func _on_BtnAuthor_in_Music1_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("http://www.twinmusicom.org/")

func _on_BtnLicense_in_Music2_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://creativecommons.org/licenses/by/4.0/")

func _on_BtnSource_in_Music2_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100190")

func _on_BtnAuthor_in_Music2_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("http://incompetech.com/")

func _on_BtnAuthor_in_Shader1_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://www.youtube.com/LetsGameDev")

func _on_BtnSource_in_Shader1_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://godotshaders.com/shader/retro-tv-shader/")

func _on_BtnSource_in_Shader2_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://godotshaders.com/shader/color-vignetting/")

func _on_BtnSource_in_BGMusic1_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://freesound.org/s/362670/")

func _on_BtnSource_in_Sound1_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://freesound.org/s/563473/")

func _on_BtnSource_in_Sound2_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://freesound.org/s/33022/")

func _on_BtnSource_in_Sound3_pressed() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("https://freesound.org/s/332711/")

func _on_BtnSource_in_Texture1_pressed() -> void:
	pass # Replace with function body.

func _on_BtnSource_in_Texture2_pressed() -> void:
	pass # Replace with function body.

func _on_BtnSource_in_Texture3_pressed() -> void:
	pass # Replace with function body.

func _on_BtnSource_in_Texture4_pressed() -> void:
	pass # Replace with function body.
