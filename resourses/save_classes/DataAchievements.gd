class_name DataAchievements extends Resource

const PATH = 'user://achievements.tres'

# Достижения
# - Список
var all: Array = [
	{"name": tr('achv_1_name'), "description": tr('achv_1_desc')},
	{"name": tr('achv_2_name'), "description": tr('achv_2_desc')},
	{"name": tr('achv_3_name'), "description": tr('achv_3_desc')},
	{"name": tr('achv_4_name'), "description": tr('achv_4_desc')},
	{"name": tr('achv_5_name'), "description": tr('achv_5_desc')},
	{"name": tr('achv_6_name'), "description": tr('achv_6_desc')},
	{"name": tr('achv_7_name'), "description": tr('achv_7_desc')},
	{"name": tr('achv_8_name'), "description": tr('achv_8_desc')},
	{"name": tr('achv_9_name'), "description": tr('achv_9_desc')},
	{"name": tr('achv_10_name'), "description": tr('achv_10_desc')},
	{"name": tr('achv_11_name'), "description": tr('achv_11_desc')},
	{"name": tr('achv_12_name'), "description": tr('achv_12_desc')},
	{"name": tr('achv_13_name'), "description": tr('achv_13_desc')},
	{"name": tr('achv_14_name'), "description": tr('achv_14_desc')},
	{"name": tr('achv_15_name'), "description": tr('achv_15_desc')},
	{"name": tr('achv_16_name'), "description": tr('achv_16_desc')},
	{"name": tr('achv_17_name'), "description": tr('achv_17_desc')},
	{"name": tr('achv_18_name'), "description": tr('achv_18_desc')},
	{"name": tr('achv_19_name'), "description": tr('achv_19_desc')},
	{"name": tr('achv_20_name'), "description": tr('achv_20_desc')},
	{"name": tr('achv_21_name'), "description": tr('achv_21_desc')},
	{"name": tr('achv_22_name'), "description": tr('achv_22_desc')},
	{"name": tr('achv_23_name'), "description": tr('achv_23_desc')},
	{"name": tr('achv_24_name'), "description": tr('achv_24_desc')},
	{"name": tr('achv_25_name'), "description": tr('achv_25_desc')},
	{"name": tr('achv_26_name'), "description": tr('achv_26_desc')},
	{"name": tr('achv_27_name'), "description": tr('achv_27_desc')},
	{"name": tr('achv_28_name'), "description": tr('achv_28_desc')},
	{"name": tr('achv_29_name'), "description": tr('achv_29_desc')},
]
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

func saving():
	var result = ResourceSaver.save(PATH, self)
	if result == OK:
		print('complete loading achievements')
