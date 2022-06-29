class_name DataAchievements extends Resource

const PATH = 'user://achievements.tres'

# Достижения
# - Список
var all: Array = _gen_achv_id()
# - Открытые достижения
export(Array) var opened: Array = []

# Нужны для достижений
# - Пройдена викторина хотя бы раз
export(bool) var quiz_win: bool = false
# - Открыт ли раздел "Достижения"
export(bool) var is_achievement_opened: bool = false
# - Переключался ли язык на English
export(bool) var is_en_selected: bool = false
# - Переключался ли язык на Russian
export(bool) var is_ru_selected: bool = false
# - Переключался ли язык на Esperanto
export(bool) var is_eo_selected: bool = false
# - Список секретных слов, которые были введены в слайд-шоу
export(Array) var open_secret_words: Array = []
# - Список изображений, которые увидел игрок
export(Array) var open_images: Array = []
# - Список особенных звуков, которые услышал игрок
export(Array) var open_special_sounds: Array = []

func check_achievement():
	pass

func _gen_achv_id() -> Array:
	var result = []
	
	for i in range(29):
		result.append(i+1)
	
	return result

func saving():
	var result = ResourceSaver.save(PATH, self)
	if result == OK:
		print('complete loading achievements')
