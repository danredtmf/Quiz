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
	_check_achv_open()
	_check_quiz_win()
	_check_lang()
	_check_secret_words()
	_check_open_images()
	_check_volume()

func _check_achv_open():
	if is_achievement_opened:
		if opened.find(all[0]) == -1:
			opened.append(all[0])
	if is_achievement_opened and !quiz_win:
		if opened.find(all[1]) == -1:
			opened.append(all[1])

func _check_quiz_win():
	if quiz_win:
		if opened.find(all[6]) == -1:
			opened.append(all[6])

func _check_lang():
	match Data.data_settings.current_lang:
		Data.data_settings.LANG.ENGLISH:
			if opened.find(all[3]) == -1:
				opened.append(all[3])
		Data.data_settings.LANG.RUSSIAN:
			if opened.find(all[4]) == -1:
				opened.append(all[4])
		Data.data_settings.LANG.ESPERANTO:
			if opened.find(all[5]) == -1:
				opened.append(all[5])

func _check_secret_words():
	for word in open_secret_words:
		if word == Data.secret_words[0]: # secret
			if opened.find(all[7]) == -1:
				opened.append(all[7])
		elif word == Data.secret_words[1]: # haggy
			if opened.find(all[9]) == -1:
				opened.append(all[9])
		elif word == Data.secret_words[2]: # minecraft
			if opened.find(all[8]) == -1:
				opened.append(all[8])
		elif word == Data.secret_words[3]: # gachi
			if opened.find(all[11]) == -1:
				opened.append(all[11])
		elif word == Data.secret_words[4]: # floppa
			if opened.find(all[10]) == -1:
				opened.append(all[10])

func _check_open_images():
	var abandoned_houses_count = Core.abandoned_houses.size()
	var illuminating_spaces_count = Core.illuminating_spaces.size()
	var abstraction_count = Core.abstraction.size()
	var animals_count = Core.animals.size()
	var unusual_people_count = Core.unusual_people.size()
	var structures_count = Core.structures.size()
	
	for used in Data.data_achievements.open_images:
		if Core.abandoned_houses.find(used) != -1:
			abandoned_houses_count -= 1
		elif Core.illuminating_spaces.find(used) != -1:
			illuminating_spaces_count -= 1
		elif Core.abstraction.find(used) != -1:
			abstraction_count -= 1
		elif Core.animals.find(used) != -1:
			animals_count -= 1
		elif Core.unusual_people.find(used) != -1:
			unusual_people_count -= 1
		elif Core.structures.find(used) != -1:
			structures_count -= 1
	
	if abandoned_houses_count == 0:
		if opened.find(all[13]) == -1:
			opened.append(all[13])
	if illuminating_spaces_count == 0:
		if opened.find(all[12]) == -1:
			opened.append(all[12])
	if abstraction_count == 0:
		if opened.find(all[14]) == -1:
			opened.append(all[14])
	if animals_count == 0:
		if opened.find(all[15]) == -1:
			opened.append(all[15])
	if unusual_people_count == 0:
		if opened.find(all[16]) == -1:
			opened.append(all[16])
	if structures_count == 0:
		if opened.find(all[17]) == -1:
			opened.append(all[17])
	
	if abandoned_houses_count == 0 and \
	illuminating_spaces_count == 0 and \
	abstraction_count == 0 and \
	animals_count == 0 and \
	unusual_people_count == 0 and \
	structures_count == 0:
		if opened.find(all[18]) == -1:
			opened.append(all[18])

func _check_volume():
	if AudioServer.is_bus_mute(Data.master_idx):
		if opened.find(all[2]) == -1:
			opened.append(all[2])
	elif AudioServer.is_bus_mute(Data.music_idx) and AudioServer.is_bus_mute(Data.sound_idx):
		if opened.find(all[2]) == -1:
			opened.append(all[2])

func add_image(image: Image):
	if open_images.find(image) == -1:
		open_images.append(image)

func test_open_image():
	open_images.append_array(Core.abandoned_houses)
	open_images.append_array(Core.illuminating_spaces)
	open_images.append_array(Core.abstraction)
	open_images.append_array(Core.animals)
	open_images.append_array(Core.unusual_people)
	open_images.append_array(Core.structures)

func _gen_achv_id() -> Array:
	var result = []
	
	for i in range(29):
		result.append(i+1)
	
	return result

func saving():
	var result = ResourceSaver.save(PATH, self)
	if result == OK:
		print('complete loading achievements')
