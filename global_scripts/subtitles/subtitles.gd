extends CanvasLayer

var queue_text := []
var text := ""

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if queue_text.size() > 0 and not $Animation.is_playing():
		_start_animation()
	
	_update_ui()

func _start_animation() -> void:
	$Animation.play('popup')

func _update_ui() -> void:
	if queue_text.size() > 0:
		text = tr("%s" % [queue_text.front()])
		$Label.text = text

func add_queue(id_text: String) -> void:
	queue_text.append(id_text)

func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "popup":
		queue_text.pop_front()
