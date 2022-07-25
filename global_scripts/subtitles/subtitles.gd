extends CanvasLayer

var queue := []
var text := ""

var animation_state := ""

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if queue.size() > 0 and not $Animation.is_playing() and animation_state == "":
		_start_animation()
	
	_update_ui()

func _start_animation() -> void:
	$Animation.play('show')
	$TimerSubtitle.wait_time = queue.front()["time"]
	animation_state = "show"

func _end_animation() -> void:
	$Animation.play('hide')
	animation_state = "hide"

func _update_ui() -> void:
	if queue.size() > 0:
		text = tr("%s" % [queue.front()["id_text"]])
		$Label.text = text

func add_queue(id_text: String, time: float) -> void:
	var subtitle := {
		"id_text": id_text,
		"time": time,
	}
	
	queue.append(subtitle)

func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "show":
		$TimerSubtitle.start()
	elif anim_name == "hide":
		queue.pop_front()
		animation_state = ""

func _on_TimerSubtitle_timeout() -> void:
	_end_animation()
