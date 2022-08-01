extends Control

signal pressed

var is_chapter_two_opened: bool = false

func _ready():
	_config()

func _config():
	_show_info()
	_correct_blocks()
	
	_chance_chapter_two()
	
	$MarginButtons/HB/MainMenu.text = tr('in_main_menu')

func _show_info():
	var minutes = Data.data_player.test_time / 60
	var seconds = int(Data.data_player.test_time) % 60
	
	$MarginInfo/VB/Congratulations/Info.text = tr('win') % [Data.data_player.nick_name]
	$MarginInfo/VB/Time/Info.text = tr('time_result') % [minutes, seconds]

func _correct_blocks():
	$MarginInfo.set_anchors_preset(Control.PRESET_TOP_WIDE, true)
	$MarginButtons.set_anchors_preset(Control.PRESET_BOTTOM_WIDE, true)
	
	$MarginInfo/VB/Congratulations.rect_pivot_offset = $MarginInfo/VB/Congratulations.rect_size / 2
	$MarginInfo/VB/Time.rect_pivot_offset = $MarginInfo/VB/Time.rect_size / 2
	$MarginButtons/HB.rect_pivot_offset = $MarginButtons/HB.rect_size / 2

func start_animation():
	$Animation.play("show")

func _end_animation():
	$Animation.play("hide")

func _chance_chapter_two():
	if Data.data_achievements.quiz_win == true and Data.data_player.is_possible_activate_chapter_two == true:
		var chance = randi() % 2
		if chance == 0:
			_delete_slide_show()
			is_chapter_two_opened = true
		else:
			if Core.game: Core.game.call_deferred("set_music")
	else:
		if Core.game: Core.game.call_deferred("set_music")

func _delete_slide_show():
	$SlideShow.queue_free()

func _on_MainMenu_pressed():
	_end_animation()

func _on_Animation_animation_finished(anim_name):
	if anim_name == "hide":
		emit_signal("pressed")
