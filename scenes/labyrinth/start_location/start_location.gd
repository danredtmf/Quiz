extends Spatial

enum States { AnimStart, Playing, Stop }
var current_state = States.AnimStart

var is_creature_showed: bool = false

func _ready():
	_check_state()

func _check_state():
	match current_state:
		States.AnimStart:
			if Core.player:
				Core.player.is_movement_allowed = false
				Core.player.is_running_allowed = false
				Core.player.is_jumping_allowed = false
				$Animation.play("start")
		States.Playing:
			$Animation.play("show")
			$Camera.current = false
			if Core.player:
				Core.player.is_movement_allowed = true
		States.Stop:
			$Animation.play("stop")

func _change_state():
	match current_state:
		States.AnimStart:
			current_state = States.Playing
		States.Playing:
			current_state = States.Stop

func _on_Animation_animation_finished(anim_name):
	if anim_name == "start":
		$Animation.play("end_start")
	elif anim_name == "end_start":
		_change_state()
		_check_state()
	elif anim_name == "stop":
		Data.data_achievements.is_demo_passed = true
		Data.is_playing = true
		Core.load_scene("main_menu", Core.main_menu_res)

func _on_VisibilityNotifier_screen_entered():
	if current_state == States.Playing and is_creature_showed:
		_change_state()
		_check_state()

func _on_SpawnCreatureArea_body_entered(body):
	if body.is_in_group("Player"):
		is_creature_showed = true
