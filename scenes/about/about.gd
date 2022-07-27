extends PanelContainer

signal closing

onready var header = $VB/Header/Info
onready var version_game = $VB/Scroll/List/Main/GameVersion/Info
onready var version_engine = $VB/Scroll/List/Main/GameEngine/Info

onready var header_movement = $VB/Scroll/List/HeaderMovement
onready var wasd_info = $VB/Scroll/List/Movement/WASD/Margin/Panel/Header
onready var esc_info = $VB/Scroll/List/Movement/Esc/Margin/Panel/Header

onready var header_assets = $VB/Scroll/List/HeaderAssets
onready var music_info = $VB/Scroll/List/Assets/Music/Margin/Panel/Header
onready var shaders_info = $VB/Scroll/List/Assets/Shaders/Margin/Panel/Header
onready var bg_music_info = $VB/Scroll/List/Assets/BackgroundMusic/Margin/Panel/Header
onready var sounds_info = $VB/Scroll/List/Assets/Sounds/Margin/Panel/Header
onready var textures_info = $VB/Scroll/List/Assets/Textures/Panel/Header
onready var images_info_1 = $VB/Scroll/List/Assets/Images/Margin/Panel/Header
onready var images_info_2 = $VB/Scroll/List/Assets/Images/List/Panel/Info

onready var btn_music1_license = $VB/Scroll/List/Assets/Music/List/Music1/BtnLicense
onready var btn_music1_author = $VB/Scroll/List/Assets/Music/List/Music1/BtnAuthor

onready var btn_music2_license = $VB/Scroll/List/Assets/Music/List/Music2/BtnLicense
onready var btn_music2_source = $VB/Scroll/List/Assets/Music/List/Music2/BtnSource
onready var btn_music2_author = $VB/Scroll/List/Assets/Music/List/Music2/BtnAuthor

onready var btn_shader1_author = $VB/Scroll/List/Assets/Shaders/List/Shader1/BtnAuthor
onready var btn_shader1_source = $VB/Scroll/List/Assets/Shaders/List/Shader1/BtnSource

onready var btn_shader2_source = $VB/Scroll/List/Assets/Shaders/List/Shader2/BtnSource

onready var btn_bg_music1_source = $VB/Scroll/List/Assets/BackgroundMusic/List/Music1/BtnSource

onready var btn_sound1_source = $VB/Scroll/List/Assets/Sounds/List/Sound1/BtnSource
onready var btn_sound2_source = $VB/Scroll/List/Assets/Sounds/List/Sound2/BtnSource
onready var btn_sound3_source = $VB/Scroll/List/Assets/Sounds/List/Sound3/BtnSource

onready var btn_texture1_source = $VB/Scroll/List/Assets/Textures/List/Texture1/BtnSource
onready var btn_texture2_source = $VB/Scroll/List/Assets/Textures/List/Texture2/BtnSource
onready var btn_texture3_source = $VB/Scroll/List/Assets/Textures/List/Texture3/BtnSource
onready var btn_texture4_source = $VB/Scroll/List/Assets/Textures/List/Texture4/BtnSource

onready var wall_info = $VB/Scroll/List/Assets/Textures/List/Texture1/Info
onready var floor_info = $VB/Scroll/List/Assets/Textures/List/Texture2/Info
onready var desk_info = $VB/Scroll/List/Assets/Textures/List/Texture3/Info
onready var ceiling_info = $VB/Scroll/List/Assets/Textures/List/Texture4/Info

onready var btn_site = $VB/Scroll/List/Main/GameAuthor/Site
onready var btn_close = $VB/Buttons/Close

func _ready():
	_config()

func _config():
	_set_center_screen()
	update_ui()
	_start_animation()

func _set_center_screen():
	rect_pivot_offset = rect_size / 2
	set_anchors_preset(Control.PRESET_CENTER, true)

func update_ui():
	header.text = tr('about')
	
	version_game.text = ProjectSettings.get_setting("application/config/version")
	version_engine.text = Engine.get_version_info()["string"]
	
	header_movement.text = tr('move_header')
	wasd_info.text = tr('move_info')
	esc_info.text = tr('pause_info')
	
	header_assets.text = tr('assets_header')
	music_info.text = tr('music_info')
	shaders_info.text = tr('shaders_info')
	bg_music_info.text = tr('background_music_info')
	sounds_info.text = tr('sounds_info')
	textures_info.text = tr('textures_info')
	images_info_1.text = tr('images_info_1')
	images_info_2.text = tr('images_info_2')
	
	btn_music1_license.text = tr('license')
	btn_music1_author.text = tr('author')
	
	btn_music2_license.text = tr('license')
	btn_music2_source.text = tr('source')
	btn_music2_author.text = tr('author')
	
	btn_shader1_author.text = tr('author')
	btn_shader1_source.text = tr('source')
	
	btn_shader2_source.text = tr('source')
	
	btn_bg_music1_source.text = tr('source')
	
	btn_sound1_source.text = tr('source')
	btn_sound2_source.text = tr('source')
	btn_sound3_source.text = tr('source')
	
	btn_texture1_source.text = tr('source')
	btn_texture2_source.text = tr('source')
	btn_texture3_source.text = tr('source')
	btn_texture4_source.text = tr('source')
	
	wall_info.text = tr('wall')
	floor_info.text = tr('floor')
	desk_info.text = tr('desk')
	ceiling_info.text = tr('ceiling')
	
	$VB/Scroll/List/Info.text = tr('about_info') % [ProjectSettings.get_setting("application/config/version"), Engine.get_version_info()["string"]]
	
	btn_site.text = tr('site')
	btn_close.text = tr('close')

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
