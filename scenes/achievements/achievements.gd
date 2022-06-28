extends PanelContainer

var block_res = preload("res://scenes/secondary/achievement/achievement.tscn")

signal closing

func _ready():
	_config()

func _config():
	_set_center_screen()
	update_ui()
	_gen()
	_start_animation()

func _process(_delta):
	update_ui()

func _gen():
	for i in Data.data_achievements.opened:
		var block = block_res.instance()
		block.text_name = i["name"]
		block.text_description = i["description"]
		$VB/Scroll/Margin/VB.add_child(block)

func _set_center_screen():
	rect_pivot_offset = rect_size / 2
	set_anchors_preset(Control.PRESET_CENTER, true)

func _check_count():
	var count = Data.data_achievements.all.size() - Data.data_achievements.opened.size()
	if count == 0:
		$VB/Scroll/Margin/VB/Info.text = 'Все достижения открыты!'
	else:
		$VB/Scroll/Margin/VB/Info.text = 'Закрытых достижений: %d' % [count]

func update_ui():
	$VB/Header/Info.text = tr('achievements')
	
	_check_count()
	
	$VB/Buttons/Close.text = tr('close')

func _start_animation():
	$Animation.play("show")

func _end_animation():
	$Animation.play("hide")

func _on_Animation_animation_finished(anim_name):
	if anim_name == "hide":
		emit_signal("closing")
		queue_free()

func _on_Close_pressed():
	_end_animation()
