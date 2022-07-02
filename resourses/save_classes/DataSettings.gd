class_name DataSettings extends Resource

const PATH = 'user://settings.tres'

# Язык
# | По умолчанию выбран ENGLISH |
enum LANG { ENGLISH, RUSSIAN, ESPERANTO }
# - Текущий язык
export(LANG) var current_lang: int = LANG.ENGLISH

# Громкость
export(float) var volume_master: float
# - Музыки
export(float) var volume_music: float
# - Звуков
export(float) var volume_sounds: float

# Обновление локализации
func change_locale() -> void:
	if current_lang == LANG.ENGLISH:
		TranslationServer.set_locale('en')
	elif current_lang == LANG.RUSSIAN:
		TranslationServer.set_locale('ru')
	elif current_lang == LANG.ESPERANTO:
		TranslationServer.set_locale('eo')

# Английский язык
func set_en() -> void:
	current_lang = LANG.ENGLISH
	change_locale()
	saving()

# Русский язык
func set_ru() -> void:
	current_lang = LANG.RUSSIAN
	change_locale()
	saving()

# Язык Эсперанто
func set_eo() -> void:
	current_lang = LANG.ESPERANTO
	change_locale()
	saving()

func set_volume() -> void:
	if !volume_master and !volume_music and !volume_sounds:
		volume_master = AudioServer.get_bus_volume_db(Data.master_idx)
		volume_music = AudioServer.get_bus_volume_db(Data.music_idx)
		volume_sounds = AudioServer.get_bus_volume_db(Data.sound_idx)

func reset_volume() -> void:
	AudioServer.set_bus_volume_db(Data.master_idx, 0)
	AudioServer.set_bus_volume_db(Data.music_idx, 0)
	AudioServer.set_bus_volume_db(Data.sound_idx, 0)
	set_volume()

func saving():
	var result = ResourceSaver.save(PATH, self)
	if result == OK:
		print('complete saving settings')
