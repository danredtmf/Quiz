extends Node

const music1 = preload('res://resourses/audio/music/Retro_Dreamscape-Twin_Musicom.ogg')
const music2 = preload('res://resourses/audio/music/I_Found_an_Answer-Twin_Musicom.ogg')

# Для соблюдения последовательности геймплея
var current_state: int = Core.GAME_STATE.ENTER_NICKNAME

# Для соблюдения последовательности тестирования
var current_stage: int = Core.TEST_STAGE.NONE

var used_images: Array = []

var selected_images: Array = []
var selected_sound: AudioStreamOGGVorbis

var test_started := false

var test_time: float = 0

func _ready():
	Core.game = self
	AchvCards.is_allowed = false
	Core.shuffle_images()
	if OS.has_feature('editor'):
		_load_pictures_test()
		_load_audio()
		Data.data_player.test_data()
		_state_ending()
	else:
		_check_state()

func _process(delta):
	if test_started:
		test_time += delta
		
		if Input.is_action_just_pressed('ui_cancel'):
			var pause = Core.pause_res.instance()
			add_child(pause)
			
			get_tree().set_pause(true)

func _end_animation():
	var end = $Animation.get_animation("end")
	end.track_set_key_value(0, 0, $Music.volume_db)
	$Animation.play('end')

func set_music():
	match current_state:
		Core.GAME_STATE.ENTER_NICKNAME:
			$Music.stream = music1
			$Music.volume_db = -20
			$Music.play()
		Core.GAME_STATE.ENDING:
			$Music.stream = music2
			$Music.volume_db = -25
			$Music.play()

func set_pause_music():
	$Music.stream_paused = not $Music.stream_paused

func _check_state():
	match current_state:
		Core.GAME_STATE.ENTER_NICKNAME:
			set_music()
			_state_enter_nickname()
		Core.GAME_STATE.TEST1:
			test_started = true
			_state_test1()
		Core.GAME_STATE.TEST2:
			_state_test2()
		Core.GAME_STATE.TEST3:
			_state_test3()
		Core.GAME_STATE.ENDING:
			test_started = false
			_end_animation()
			yield($Animation, 'animation_finished')
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
	_check_stage()
	_load_pictures()

func _state_test2():
	_check_stage()
	_load_pictures()

func _state_test3():
	_check_stage()
	_load_pictures()
	_load_audio()

func _state_ending():
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
			if current_stage == Core.TEST_STAGE.THREE:
				testing.audio = selected_sound
			
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

func _add_image(image: Image):
	selected_images.append(image)
	used_images.append(image)
	Data.data_achievements.add_image(image)

func image_is_used(image: Image) -> bool:
	if used_images.find(image) != -1 or selected_images.find(image) != -1:
		return true
	else: return false

func _load_pictures():
	randomize()
	
	selected_images.clear()
	
	match current_state:
		Core.GAME_STATE.TEST1:
			var i = 0
			while i != 1:
				for pic in Core.abandoned_houses:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
			while i != 2:
				for pic in Core.structures:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
			while i != 3:
				for pic in Core.animals:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
		Core.GAME_STATE.TEST2:
			var i = 0
			while i != 1:
				for pic in Core.illuminating_spaces:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
			while i != 2:
				for pic in Core.illuminating_spaces:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
			while i != 3:
				for pic in Core.abstraction:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
		Core.GAME_STATE.TEST3:
			var i = 0
			while i != 1:
				for pic in Core.unusual_people:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
			while i != 2:
				for pic in Core.abstraction:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
			while i != 3:
				for pic in Core.abstraction:
					if not image_is_used(pic):
						if randi() % 2 == 0:
							if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
								_add_image(pic)
								i += 1
								break
							else:
								_add_image(pic)
								i += 1
								break
	
	Data.data_achievements.check_achievement()

func _load_pictures_test():
	randomize()
	
	selected_images.clear()
	
	var i = 0
	while i != 1:
		for pic in Core.abandoned_houses:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	while i != 2:
		for pic in Core.structures:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	while i != 3:
		for pic in Core.animals:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	i = 0
	while i != 1:
		for pic in Core.illuminating_spaces:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	while i != 2:
		for pic in Core.illuminating_spaces:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	while i != 3:
		for pic in Core.abstraction:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	i = 0
	while i != 1:
		for pic in Core.unusual_people:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	while i != 2:
		for pic in Core.abstraction:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	while i != 3:
		for pic in Core.abstraction:
			if not image_is_used(pic):
				if randi() % 2 == 0:
					if randi() % 5 == 0 and Data.data_achievements.open_image_is_used(pic):
						_add_image(pic)
						i += 1
						break
					else:
						_add_image(pic)
						i += 1
						break
	
	Data.data_achievements.check_achievement()

func _load_audio():
	randomize()
	
	var audio: AudioStreamOGGVorbis
	
	var i = 0
	while i == 0:
		for a in Core.special_sounds:
			var audio_name = Core.get_audio_name(a)
			if randi() % 2 == 0 and audio_name != "connect":
				if Data.data_achievements.open_special_sounds.find(audio_name) != -1:
					if randi() % 5 == 0:
						audio = a
						Data.data_achievements.add_special_sound(audio_name)
						i += 1
						break
				else:
					audio = a
					Data.data_achievements.add_special_sound(audio_name)
					i += 1
					break
	
	Data.data_achievements.check_achievement()
	
	selected_sound = audio

func _on_info_pressed():
	_change_stage()

func _on_testing_pressed():
	_change_stage()

func _on_enter_nickname_pressed():
	_change_state()

func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "end":
		$Music.stop()
		$Music.volume_db = -10
