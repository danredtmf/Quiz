extends Spatial

enum States { AnimStart, Map1, Map2, Map3, Stop }
var current_state = States.AnimStart

var is_creature_showed: bool = false

func _ready():
	Core.game = self
	set_process(false)
	_check_state()

func _process(_delta: float) -> void:
	$CanvasLayer/MoveInfo.text = "%s:\nWASD - %s\nEsc - %s" % [tr('move_header'), tr('move_info'), tr('pause_info')]
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed('ui_cancel'):
		var pause = Core.pause_res.instance()
		add_child(pause)
		
		get_tree().set_pause(true)

func _check_state():
	match current_state:
		States.AnimStart:
			if Core.player:
				Core.player.is_movement_allowed = false
				Core.player.is_running_allowed = false
				Core.player.is_jumping_allowed = false
				
				$CanvasLayer/Image.texture = Core.main_menu_screenshot
				OS.window_fullscreen = true
				$Animation.play("start")
		States.Map1:
			$Animation.play("show")
			$Map1/WallText1.show()
			$Map1/WallText2.show()
			$Map1/Text3.show()
			$Camera.current = false
			if Core.player:
				Core.player.is_movement_allowed = true
			set_process(true)
		States.Map2:
			$Map1.hide()
			$Map2.show()
			var point = $Map2/PlayerPoint.global_transform.origin
			var player_point = Core.player.global_transform.origin
			var rotation_player = Core.player.rotation_degrees
			Core.player.movement = Vector3()
			Core.player.rotation_degrees = Vector3(rotation_player.x, -180, rotation_player.z)
			Core.player.global_transform.origin = Vector3(point.x, player_point.y, point.z)
			$Animation.play("show")
			set_process(true)
		States.Map3:
			$Map2.hide()
			$Map3.show()
			var point = $Map3/PlayerPoint.global_transform.origin
			var player_point = Core.player.global_transform.origin
			var rotation_player = Core.player.rotation_degrees
			Core.player.movement = Vector3()
			Core.player.rotation_degrees = Vector3(rotation_player.x, -180, rotation_player.z)
			Core.player.global_transform.origin = Vector3(point.x, player_point.y, point.z)
			$Animation.play("show")
			set_process(true)
		States.Stop:
			$Animation.play("stop")

func _change_state():
	match current_state:
		States.AnimStart:
			current_state = States.Map1
		States.Map1:
			current_state = States.Map2
		States.Map2:
			current_state = States.Map3
		States.Map3:
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
	elif anim_name == "show" and current_state == States.Map1:
		$Animation.play('popup_move')

func _on_VisibilityNotifier_camera_entered(_camera):
	if current_state == States.Map3 and is_creature_showed:
		set_process(false)
		_change_state()
		_check_state()

func _on_SpawnCreatureArea_notify():
	is_creature_showed = true
	yield(get_tree().create_timer(.5), 'timeout')	
	$Map3/Ghost/GhostSound.play()
	yield(get_tree().create_timer(0.25), 'timeout')
	$Music.stop()

func _on_CheckPlayerArea_exited_in_Map1():
	$Animation.play("end_start")
	set_process(false)

func _on_CheckPlayerArea_exited_in_Map2():
	$Animation.play("end_start")
	set_process(false)
