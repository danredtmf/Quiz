extends PanelContainer

signal pressed

func _ready():
	_config()

func _config():
	rect_pivot_offset = rect_size / 2
	set_anchors_preset(Control.PRESET_CENTER, true)
	
	_start_animation()

func _start_animation():
	$Anim.play("show")

func _end_animation():
	$Anim.play("hide")

# !Делать ли здесь переход в другую сцену?
# Нет, можно сделать в главном меню через сигнал
func _on_Yes_pressed():
	Data.sending_data_is_allowed = true
	emit_signal("pressed")
	_end_animation()

func _on_No_pressed():
	Data.sending_data_is_allowed = false
	emit_signal("pressed")
	_end_animation()

func _on_Wait_pressed():
	_end_animation()

func _on_Anim_animation_finished(anim_name):
	if anim_name == "hide":
		queue_free()
