extends Control

const main_menu_res = preload("res://scenes/main_menu/main_menu.tscn")

func _ready():
	_start_animation()

func _start_animation():
	$Anim.play("show")

func _end_animation():
	$Anim.play("hide")

func _on_Anim_animation_finished(anim_name):
	if anim_name == "show":
		yield(get_tree().create_timer(1), "timeout")
		_end_animation()
	elif anim_name == "hide":
		Data.splash_screen_is_appeared = true
		yield(get_tree().create_timer(1), "timeout")
		Core.load_scene("main_menu", main_menu_res)
