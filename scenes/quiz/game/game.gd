extends Node

# Для соблюдения последовательности геймплея
var current_state: int = Core.GAME_STATE.ENTER_NICKNAME

# Для соблюдения последовательности тестирования
var current_stage: int = Core.TEST_STAGE.NONE

var selected_images: Array = []

var test_time: float = 0

func _ready():
	set_process(false)
	Core.shuffle_images()
	if OS.has_feature('editor'):
		_load_pictures_test()
		Data.data_player.test_data()
		_state_ending()
	else:
		_check_state()

func _process(delta):
	test_time += delta

func _check_state():
	match current_state:
		Core.GAME_STATE.ENTER_NICKNAME:
			_state_enter_nickname()
		Core.GAME_STATE.TEST1:
			_state_test1()
		Core.GAME_STATE.TEST2:
			_state_test2()
		Core.GAME_STATE.TEST3:
			_state_test3()
		Core.GAME_STATE.ENDING:
			_state_ending()

func _check_stage():
	match current_stage:
		Core.TEST_STAGE.NONE:
			_build_info()
		Core.TEST_STAGE.ONE:
			_build_stage()
		Core.TEST_STAGE.TWO:
			_build_stage()
		Core.TEST_STAGE.THREE:
			_build_stage()

func _state_enter_nickname():
	var enter_nickname = Core.enter_nickname_res.instance()
	add_child(enter_nickname)
	enter_nickname.connect("pressed", self, "_on_enter_nickname_pressed")

func _state_test1():
	set_process(true)
	_check_stage()
	_load_pictures()

func _state_test2():
	_check_stage()
	_load_pictures()

func _state_test3():
	_check_stage()
	_load_pictures()

func _state_ending():
	set_process(false)
	_record_test_time()
	var ending = Core.ending_res.instance()
	add_child(ending)

func _record_test_time():
	var minutes = test_time / 60
	var seconds = int(test_time) % 60
	var result = "Test time - %d min %d sec" % [minutes, seconds]
	print(result)
	Data.data_player.test_time = test_time

func _build_info():
	var info = Core.info_res.instance()
	
	match current_state:
		Core.GAME_STATE.TEST1:
			info.header_text = tr('test1_name')
			add_child(info)
			info.connect("pressed", self, "_on_info_pressed")
		Core.GAME_STATE.TEST2:
			info.header_text = tr('test2_name')
			add_child(info)
			info.connect("pressed", self, "_on_info_pressed")
		Core.GAME_STATE.TEST3:
			info.header_text = tr('test3_name')
			info.info_text = tr('test3_info')
			add_child(info)
			info.connect("pressed", self, "_on_info_pressed")

func _build_stage():
	var testing = Core.testing_res.instance()
	
	testing.state = current_state
	testing.stage = current_stage
	
	match current_stage:
		Core.TEST_STAGE.ONE:
			testing.image = selected_images[0]
		Core.TEST_STAGE.TWO:
			testing.image = selected_images[1]
		Core.TEST_STAGE.THREE:
			testing.image = selected_images[2]
	
	match current_state:
		Core.GAME_STATE.TEST1:
			testing.header_text = tr('test1_header')
			add_child(testing)
			testing.connect("pressed", self, "_on_testing_pressed")
		Core.GAME_STATE.TEST2:
			testing.header_text = tr('test2_header')
			add_child(testing)
			testing.connect("pressed", self, "_on_testing_pressed")
		Core.GAME_STATE.TEST3:
			testing.is_black_white = true
			testing.header_text = tr('test3_header')
			add_child(testing)
			testing.connect("pressed", self, "_on_testing_pressed")

func _change_state():
	match current_state:
		Core.GAME_STATE.ENTER_NICKNAME:
			current_state = Core.GAME_STATE.TEST1
			_check_state()
		Core.GAME_STATE.TEST1:
			current_state = Core.GAME_STATE.TEST2
			_check_state()
		Core.GAME_STATE.TEST2:
			current_state = Core.GAME_STATE.TEST3
			_check_state()
		Core.GAME_STATE.TEST3:
			current_state = Core.GAME_STATE.ENDING
			_check_state()

func _change_stage():
	yield(get_tree().create_timer(1), "timeout")
	match current_stage:
		Core.TEST_STAGE.NONE:
			current_stage = Core.TEST_STAGE.ONE
			_check_stage()
		Core.TEST_STAGE.ONE:
			current_stage = Core.TEST_STAGE.TWO
			_check_stage()
		Core.TEST_STAGE.TWO:
			current_stage = Core.TEST_STAGE.THREE
			_check_stage()
		Core.TEST_STAGE.THREE:
			current_stage = Core.TEST_STAGE.NONE
			_change_state()

func _load_pictures():
	randomize()
	
	selected_images.clear()
	
	match current_state:
		Core.GAME_STATE.TEST1:
			var i = 0
			while i != 1:
				for pic in Core.abandoned_houses:
					if Core.get_rand_chance() <= 30:
						if !Core.image_is_used(pic):
							selected_images.append(pic)
							Core.used_images.append(pic)
							Data.data_achievements.add_image(pic)
							i += 1
							break
			while i != 2:
				for pic in Core.structures:
					if Core.get_rand_chance() <= 30:
						if !Core.image_is_used(pic):
							selected_images.append(pic)
							Core.used_images.append(pic)
							Data.data_achievements.add_image(pic)
							i += 1
							break
			while i != 3:
				for pic in Core.animals:
					if Core.get_rand_chance() <= 30:
						if !Core.image_is_used(pic):
							selected_images.append(pic)
							Core.used_images.append(pic)
							Data.data_achievements.add_image(pic)
							i += 1
							break
		Core.GAME_STATE.TEST2:
			var i = 0
			while i != 3:
				for pic in Core.abstraction:
					if Core.get_rand_chance() <= 30:
						if selected_images.find(pic) == -1 && !Core.image_is_used(pic):
							selected_images.append(pic)
							Core.used_images.append(pic)
							Data.data_achievements.add_image(pic)
							i += 1
							break
		Core.GAME_STATE.TEST3:
			var i = 0
			while i != 1:
				for pic in Core.animals:
					if Core.get_rand_chance() <= 30:
						if !Core.image_is_used(pic):
							selected_images.append(pic)
							Core.used_images.append(pic)
							Data.data_achievements.add_image(pic)
							i += 1
							break
			while i != 2:
				for pic in Core.unusual_people:
					if Core.get_rand_chance() <= 30:
						if !Core.image_is_used(pic):
							selected_images.append(pic)
							Core.used_images.append(pic)
							Data.data_achievements.add_image(pic)
							i += 1
							break
			while i != 3:
				for pic in Core.unusual_people:
					if Core.get_rand_chance() <= 30:
						if !Core.image_is_used(pic):
							selected_images.append(pic)
							Core.used_images.append(pic)
							Data.data_achievements.add_image(pic)
							i += 1
							break
	
	Data.data_achievements.check_achievement()

func _load_pictures_test():
	randomize()
	
	selected_images.clear()
	
	var i = 0
	while i != 1:
		for pic in Core.abandoned_houses:
			if Core.get_rand_chance() <= 30:
				Data.data_achievements.add_image(pic)
				i += 1
				break
	while i != 2:
		for pic in Core.structures:
			if Core.get_rand_chance() <= 30:
				Data.data_achievements.add_image(pic)
				i += 1
				break
	while i != 3:
		for pic in Core.animals:
			if Core.get_rand_chance() <= 30:
				Data.data_achievements.add_image(pic)
				i += 1
				break
	i = 0
	while i != 3:
		for pic in Core.abstraction:
			if Core.get_rand_chance() <= 30:
				Data.data_achievements.add_image(pic)
				i += 1
				break
	i = 0
	while i != 1:
		for pic in Core.animals:
			if Core.get_rand_chance() <= 30:
				Data.data_achievements.add_image(pic)
				i += 1
				break
	while i != 2:
		for pic in Core.unusual_people:
			if Core.get_rand_chance() <= 30:
				Data.data_achievements.add_image(pic)
				i += 1
				break
	while i != 3:
		for pic in Core.unusual_people:
			if Core.get_rand_chance() <= 30:
				Data.data_achievements.add_image(pic)
				i += 1
				break
	
	Data.data_achievements.check_achievement()

func _load_audio():
	pass

func _on_info_pressed():
	_change_stage()

func _on_testing_pressed():
	_change_stage()

func _on_enter_nickname_pressed():
	_change_state()
