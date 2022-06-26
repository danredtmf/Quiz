extends Node

var splash_screen_is_appeared: bool = false
var sending_data_is_allowed: bool = false

# Хотел сделать сервер, где хранил бы ответы пользователей
# Ответы бы использовались для анимации завершения викторины
var is_server_exists: bool = false

var nick_name: String = ""
var test_time: float = 0

enum LANG { ENGLISH, RUSSIAN, ESPERANTO }

var current_lang = LANG.ENGLISH

var test_answers: Array = []

var test_1_answers: Array = []
var test_2_answers: Array = []
var test_3_answers: Array = []

var test_data_text: Array = ["кто", "волк", "тот", "не", "гуляет", "ходит", "борщ", "варить", "искать", "волки", "волчонок", "куда", "идёт", "дверь", "погода", "ясная", "бюргерство", "изгнанник", "пульс", "драгун", "палиндром", "нервничание", "жмыходробилка", "электролюминесценция", "ветродвигатель", "тропот", "умирать", "уснуть", "обнять", "поразить", "ощутить", "приняться", "двигаться", "попросить", "направиться", "закрывать", "повседневный", "водный", "рыжий", "отдельный", "сплошной", "тонкий", "потребительский", "дежурный", "бетонный", "налоговый", "пространственный", "тихий", "последний", "населенный", "процентный", "видный", "неизвестный", "органический"]

func _ready():
	change_locale()

func change_locale():
	if current_lang == LANG.ENGLISH:
		TranslationServer.set_locale('en')
	elif current_lang == LANG.RUSSIAN:
		TranslationServer.set_locale('ru')
	elif current_lang == LANG.ESPERANTO:
		TranslationServer.set_locale('eo')

func connect_answers():
	test_answers.append_array(test_1_answers)
	test_answers.append_array(test_2_answers)
	test_answers.append_array(test_3_answers)

func test_data():
	randomize()
	for _i in range(3):
		test_1_answers.append(_create_test_data())
	for _i in range(3):
		test_2_answers.append(_create_test_data())
	for _i in range(3):
		test_3_answers.append(_create_test_data())

func _create_test_data() -> String:
	var result = "%s %s %s %s" % [
		test_data_text[randi() % test_data_text.size()],
		test_data_text[randi() % test_data_text.size()],
		test_data_text[randi() % test_data_text.size()],
		test_data_text[randi() % test_data_text.size()]
		]
	
	return result

func clear_data():
	nick_name = ""
	test_time = 0
	test_answers.clear()
	test_1_answers.clear()
	test_2_answers.clear()
	test_3_answers.clear()
	Core.used_images.clear()
