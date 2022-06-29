class_name DataSettings extends Resource

const PATH = 'user://settings.tres'

# Язык
# | По умолчанию выбран ENGLISH |
enum LANG { ENGLISH, RUSSIAN, ESPERANTO }
# - Текущий язык
export(LANG) var current_lang: int = LANG.ENGLISH

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

func saving():
	var result = ResourceSaver.save(PATH, self)
	if result == OK:
		print('complete loading settings')
