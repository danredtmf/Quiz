extends PanelContainer

signal pressed

export(String) var header_text = ""
export(String) var info_text = ""

func _ready():
	_config()
	_start_animation()

func _config():
	rect_pivot_offset = rect_size / 2
	set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	
	$VB/HeaderPanel/Header.text = header_text
	$VB/Info.text = info_text
	
	$VB/Buttons/Next.text = tr('ok')

func _start_animation():
	$Anim.play("show")

func _end_animation():
	$Anim.play("hide")

func _on_Next_pressed():
	_end_animation()

func _on_Anim_animation_finished(anim_name):
	if anim_name == "hide":
		emit_signal("pressed")
		queue_free()
