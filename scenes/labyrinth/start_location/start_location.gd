extends Spatial

enum States { AnimStart, Playing }
var current_state = States.AnimStart

func _ready():
	_check_state()

func _check_state():
	match current_state:
		States.AnimStart:
			if Core.player:
				Core.player.is_movement_allowed = false
				$Animation.play("start")
		States.Playing:
			$Camera.current = false
			if Core.player:
				Core.player.is_movement_allowed = true

func _change_state():
	match current_state:
		States.AnimStart:
			current_state = States.Playing

func _on_Animation_animation_finished(anim_name):
	if anim_name == "start":
		_change_state()
		_check_state()
