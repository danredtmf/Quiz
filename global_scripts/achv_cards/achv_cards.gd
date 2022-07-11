extends CanvasLayer

const achv_card_res = preload("res://global_scripts/achv_cards/secondary/achv_card.tscn")

var queue_achv: Array = []

var queue: Array = []
var queue_showed: Array = []

var is_visible: bool = false

var is_activated: bool = false
var is_allowed: bool = false
var is_showing: bool = false
var is_deleting: bool = false

func _process(_delta):
	_check_activate()
	
	_create_card()
	
	if is_activated and is_allowed:
		_show_card()
	
	if !is_showing and !is_deleting and $DelayEnd.is_stopped():
		$DelayEnd.start()

func add_achv(number: int):
	queue_achv.append(number)

func _check_activate():
	is_activated = Data.data_achievements.is_achievement_opened

func _create_card():
	if queue_achv.size() > 0:
		var achv_card = achv_card_res.instance()
		achv_card.text_name = tr('achv_%d_name') % queue_achv[0]
		achv_card.text_description = tr('achv_%d_desc') % queue_achv[0]
		queue.append(achv_card)
		queue_achv.pop_front()

func _show_card():
	if queue.size() > 0:
		if !is_visible and !$Animation.is_playing():
			$Animation.play("show")
			is_visible = true
		
		for card in queue:
			if queue_showed.find(card) == -1:
				is_showing = true
				$UI/Scroll/Margin/VB.add_child(card)
				queue_showed.append(card)
				yield(card, "showed")
				queue.pop_front()
	else:
		is_showing = false

func _delete_card():
	if queue_showed.size() > 0:
		var card = queue_showed[-1]
		card.call_deferred("emit_signal", "hiding")
		is_deleting = true
		yield(card, "hided")
		queue_showed.pop_at(queue_showed.rfind(card))
		is_deleting = false
	else:
		if is_visible and !$Animation.is_playing():
			$Animation.play("hide")
			is_visible = false

func _on_DelayEnd_timeout():
	_delete_card()
