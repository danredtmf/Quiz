extends PanelContainer

signal showed
signal hided
# warning-ignore:unused_signal
signal hiding

var text_name: String = "Название"
var text_description: String = "Описание"

var die: bool = false

func _ready():
	_config()

func _config():
# warning-ignore:return_value_discarded
	connect("hiding", self, "_on_hiding")
	rect_position.x += rect_size.x + 50
	modulate.a = 0
	
	$VB/Name.text = text_name
	$VB/Description.text = text_description
	
	set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	
	_start_animation()

func _start_animation():
	$Tween.interpolate_property(self, "rect_position:x", rect_position.x, rect_position.x - rect_size.x - 50, .5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a", 0, 1, .5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()

func _end_animation():
	$Tween.interpolate_property(self, "rect_position:x", rect_position.x, rect_position.x + rect_size.x + 50, .5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a", 1, 0, .5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	die = true

func _on_Tween_tween_all_completed():
	if die:
		emit_signal("hided")
		queue_free()
	else:
		emit_signal("showed")

func _on_hiding():
	$DelayEnd.start()

func _on_DelayEnd_timeout():
	_end_animation()
