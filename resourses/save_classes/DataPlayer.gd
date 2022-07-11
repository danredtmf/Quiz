class_name DataPlayer extends Resource

const PATH = 'user://player.tres'

# - Пвсевдоним игрока
export(String) var nick_name: String = ""
# - Время викторины
export(float) var test_time: float = 0

# - Все ответы игрока викторины
export(Array) var test_answers: Array = []
# - Отдельно ответы каждой части викторины
export(Array) var test_1_answers: Array = []
export(Array) var test_2_answers: Array = []
export(Array) var test_3_answers: Array = []
# - Возможно ли открыть вторую часть
export(bool) var is_possible_activate_chapter_two: bool = false

# - Для тестирования анимации концовки викторины
var test_data_text: Array = [
	"кто", "волк", "тот", "не", "гуляет", "ходит", "борщ", "варить", "искать", "волки", "волчонок", "куда", "идёт", "дверь", "погода", "ясная", "бюргерство", "изгнанник", "пульс", "драгун", "палиндром", "нервничание", "жмыходробилка", "электролюминесценция", "ветродвигатель", "тропот", "уснуть", "обнять", "поразить", "ощутить", "приняться", "двигаться", "попросить", "направиться", "закрывать", "повседневный", "водный", "рыжий", "отдельный", "сплошной", "тонкий", "потребительский", "дежурный", "бетонный", "налоговый", "пространственный", "тихий", "последний", "населенный", "процентный", "видный", "неизвестный", "органический"]

# - Массив первых символов ответов викторины
export(Array) var pass_answers: Array = []
# - Первые символы ответов каждой части викторины
export(Array) var test_1_pass_answers: Array = []
export(Array) var test_2_pass_answers: Array = []
export(Array) var test_3_pass_answers: Array = []

func clear_quiz():
	nick_name = ""
	test_time = 0
	
	test_answers.clear()
	test_1_answers.clear()
	test_2_answers.clear()
	test_3_answers.clear()
	
	pass_answers.clear()
	test_1_pass_answers.clear()
	test_2_pass_answers.clear()
	test_3_pass_answers.clear()
	
	saving()

# Соединение всех ответов в один массив
func connect_answers() -> void:
	test_answers.append_array(test_1_answers)
	test_answers.append_array(test_2_answers)
	test_answers.append_array(test_3_answers)

# Создание ответов в массивах каждой чатси викторины
func test_data() -> void:
	randomize()
	for _i in range(3):
		test_1_answers.append(_create_test_data())
	for _i in range(3):
		test_2_answers.append(_create_test_data())
	for _i in range(3):
		test_3_answers.append(_create_test_data())

# Генерация ответов
func _create_test_data() -> String:
	var result = "%s %s %s" % [
		test_data_text[randi() % test_data_text.size()],
		test_data_text[randi() % test_data_text.size()],
		test_data_text[randi() % test_data_text.size()],
		]
	
	return result

func loading():
	var data := ConfigFile.new()
	
	if data.load(PATH) != OK:
		printerr("File player has been not found!")
	
	nick_name = data.get_value("player", "nick_name", "")
	test_time = data.get_value("player", "t_time", 0)
	test_answers = data.get_value("player", "t_answers", [])
	test_1_answers = data.get_value("player", "t_1_answers", [])
	test_2_answers = data.get_value("player", "t_2_answers", [])
	test_3_answers = data.get_value("player", "t_3_answers", [])
	is_possible_activate_chapter_two = data.get_value("player", "is_a_chp_two", false)
	pass_answers = data.get_value("player", "p_answers", [])
	test_1_pass_answers = data.get_value("player", "t_1_p_answers", [])
	test_2_pass_answers = data.get_value("player", "t_2_p_answers", [])
	test_3_pass_answers = data.get_value("player", "t_3_p_answers", [])

func saving():
	var result := ConfigFile.new()
	result.set_value("player", "nick_name", nick_name)
	result.set_value("player", "t_time", test_time)
	result.set_value("player", "t_answers", test_answers)
	result.set_value("player", "t_1_answers", test_1_answers)
	result.set_value("player", "t_2_answers", test_2_answers)
	result.set_value("player", "t_3_answers", test_3_answers)
	result.set_value("player", "is_a_chp_two", is_possible_activate_chapter_two)
	result.set_value("player", "p_answers", pass_answers)
	result.set_value("player", "t_1_p_answers", test_1_pass_answers)
	result.set_value("player", "t_2_p_answers", test_2_pass_answers)
	result.set_value("player", "t_3_p_answers", test_3_pass_answers)
	if result.save(PATH) == OK:
		print('complete saving settings')
#	var result = ResourceSaver.save(PATH, self)
#	if result == OK:
#		print('complete saving player data')
