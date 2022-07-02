extends PanelContainer

signal pressed

func _ready():
	_config()

# !Пригодится в будущем для перевода строк
func _config():
	rect_pivot_offset = rect_size / 2
	set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	_start_animation()
	
	$VB/LineEdit.placeholder_text = tr('enter_nickname')
	$VB/Buttons/Next.text = tr('start_quiz')

func _start_animation():
	$Anim.play("show")

func _end_animation():
	$Anim.play("hide")

func _on_Next_pressed():
	if $VB/LineEdit.text != "":
		Data.data_player.nick_name = $VB/LineEdit.text
		_end_animation()

func _on_Anim_animation_finished(anim_name):
	if anim_name == "hide":
		emit_signal("pressed")
		queue_free()
