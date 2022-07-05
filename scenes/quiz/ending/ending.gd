extends Node

var animated_text_arr: Array = []
var animated_text_arr_compl: Array = []

func _ready():
	AchvCards.is_allowed = true
	Data.data_player.connect_answers()
	Data.data_achievements.quiz_win = true
	Data.data_achievements.check_achievement()
	_create_animated_text()
	yield(get_tree().create_timer(1), "timeout")
	$ATDelay.start()

func _create_animated_text():
	var font = preload("res://resourses/fonts/Roboto-Regular.ttf")
	var custom_theme = Theme.new()
	var dynamic = DynamicFont.new()
	dynamic.font_data = font
	dynamic.size = 48
	custom_theme.default_font = dynamic
	var center_screen = get_viewport().size / 2
	
	for answer in Data.data_player.test_answers:
		var label = Label.new()
		var tween = Tween.new()
		var tween_show = Tween.new()
		
		label.add_user_signal("showing")
		label.add_user_signal("start")
		label.theme = custom_theme
		label.text = answer
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		label.add_child(tween, true)
		label.add_child(tween_show, true)
		label.rect_position = Core.get_rand_screen_position()
		label.modulate.a = 0
		tween_show.interpolate_property(label, "modulate:a", 0, 1, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(label, "rect_position", label.rect_position, center_screen - label.rect_size / 10, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(label, "modulate:a", 1, 0, 4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(label, "rect_scale", Vector2(1, 1), Vector2(0, 0), 4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		animated_text_arr.append(label)

func _start_animated_text():
	if animated_text_arr.size() > 0:
		add_child(animated_text_arr[0])
		animated_text_arr[0].call_deferred("connect", "start", self, "_on_starting")
		animated_text_arr[0].call_deferred("connect", "showing", self, "_on_showing")
		animated_text_arr[0].call_deferred("emit_signal", "start")
	else:
		$AnimationBG.play("light")

func _on_starting():
	animated_text_arr[0].get_node("Tween2").call_deferred("start")
	yield(animated_text_arr[0].get_node("Tween2"), "tween_all_completed")
	animated_text_arr[0].call_deferred("emit_signal", "showing")

func _on_showing():
	animated_text_arr[0].get_node("Tween").call_deferred("start")
	animated_text_arr_compl.append(animated_text_arr[0])
	animated_text_arr.pop_front()
	$ATDelay.start()

func _on_ATDelay_timeout():
	_start_animated_text()

func _destroy_animated_text():
	if animated_text_arr_compl.size() > 0:
		animated_text_arr_compl[0].call_deferred("free")
		animated_text_arr_compl.pop_front()

func _on_AnimationBG_animation_finished(anim_name):
	if anim_name == "light":
		_destroy_animated_text()
		$AnimationBG.play("show")
		$Result.start_animation()
	elif anim_name == "hide":
		if $Result.is_chapter_two_opened:
			Core.load_scene("main_menu", load(ProjectSettings.get_setting('application/run/main_scene')))
		else:
			Data.data_player.is_possible_activate_chapter_two = true
			Data.data_player.saving()
			
			Core.load_scene("main_menu", load(ProjectSettings.get_setting('application/run/main_scene')))

func _on_Result_pressed():
	$AnimationBG.play("hide")
