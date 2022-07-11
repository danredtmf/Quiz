extends PanelContainer

signal closing

func _ready():
	_config()

func _config():
	_set_center_screen()
	update_ui()
	_start_animation()

func _process(_delta):
	update_ui()

func _set_center_screen():
	rect_pivot_offset = rect_size / 2
	set_anchors_preset(Control.PRESET_CENTER, true)

func update_ui():
	$VB/Header/Info.text = tr('demo_win_header')
	
	$VB/Info.text = tr('demo_win_info')
	
	$VB/Buttons/Horizontal/Site.text = tr('site')
	$VB/Buttons/Close.text = tr('close')

func _start_animation():
	$Animation.play("show")

func _end_animation():
	$Animation.play("hide")

func _on_Animation_animation_finished(anim_name):
	if anim_name == "hide":
		emit_signal("closing")
		queue_free()

func _on_Site_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://danredtmf.github.io")

func _on_Close_pressed():
	_end_animation()
