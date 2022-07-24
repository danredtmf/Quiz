extends Spatial

enum States { AnimStart, Map1, Map2, Map3, Stop }
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

func _on_VisibilityNotifier_camera_entered(_camera):
	if current_state == States.Map3 and is_creature_showed:
		_change_state()
		_check_state()

func _on_SpawnCreatureArea_notify():
	is_creature_showed = true
	$Map3/Ghost/GhostSound.play()
	yield(get_tree().create_timer(0.25), 'timeout')
	$Music.stop()

func _on_CheckPlayerArea_exited_in_Map1():
	$Animation.play("end_start")

func _on_CheckPlayerArea_exited_in_Map2():
	$Animation.play("end_start")

func _on_Wall1_exited_in_Map1() -> void:
	Subtitles.add_queue("tsp_gw_1")

func _on_Wall2_exited_in_Map1() -> void:
	Subtitles.add_queue("tsp_gw_2")

func _on_Desk1_exited_in_Map1() -> void:
	Subtitles.add_queue("tsp_g_1")

func _on_Wall1_exited_in_Map2() -> void:
	Subtitles.add_queue("tsp_gw_3")

func _on_Wall2_exited_in_Map2() -> void:
	Subtitles.add_queue("tsp_gw_4")

func _on_Desk1_exited_in_Map2() -> void:
	Subtitles.add_queue("tsp_g_2")

func _on_Wall1_exited_in_Map3() -> void:
	Subtitles.add_queue("tsp_gw_5")

func _on_Wall2_exited_in_Map3() -> void:
	Subtitles.add_queue("tsp_gw_6")

func _on_Desk1_exited_in_Map3() -> void:
	Subtitles.add_queue("tsp_g_3")
