extends Control

var is_warning_showed := false

func _ready() -> void:
	$VB2/Margin/VBWarning/Header.text = tr('warning')
	$VB2/Margin/VBWarning/Info.text = tr('warning_info')
	
	$VB3/Margin/Info.text = tr('splash_hint')
	
	_show_dev_animation()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		if is_warning_showed:
			_hide_warning_animation()

func _show_dev_animation() -> void:
	$Animation.play("show_dev")

func _hide_dev_animation() -> void:
	$Animation.play("hide_dev")

func _show_warning_animation() -> void:
	$Animation.play('show_warning')

func _hide_warning_animation() -> void:
	is_warning_showed = false
	$Animation.play('hide_warning')

func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "show_dev":
		yield(get_tree().create_timer(1), "timeout")
		_hide_dev_animation()
	elif anim_name == "hide_dev":
		yield(get_tree().create_timer(1), "timeout")
		_show_warning_animation()
	elif anim_name == "show_warning":
		is_warning_showed = true
	elif anim_name == "hide_warning":
		Data.splash_screen_is_appeared = true
		yield(get_tree().create_timer(1), "timeout")
		Core.load_scene("main_menu", Core.main_menu_res)
