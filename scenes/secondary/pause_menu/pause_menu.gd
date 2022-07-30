extends Control

onready var header = $List/Header/Info
onready var btn_continue = $List/Margin/Buttons/BtnContinue
onready var btn_settings = $List/Margin/Buttons/BtnSettings
onready var btn_main_menu = $List/Margin/Buttons/BtnInMainMenu

enum States { None, Settings, Exit }
var state = States.None

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_ui()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('ui_cancel') and $Childs.get_child_count() > 0:
		_check_childs()
	elif Input.is_action_just_pressed('ui_cancel') and not state == States.Exit:
		_on_BtnContinue_pressed()
	
	update_ui()

func update_ui():
	header.text = tr('pause_info')
	
	btn_continue.text = tr('continue')
	btn_settings.text = tr('settings')
	btn_main_menu.text = tr('in_main_menu')

func _end_animation():
	$Animation.play('exit')

func _check_childs():
	if $Childs.get_child_count() > 0:
		for node in $Childs.get_children():
			node.call_deferred("close")
			yield(node, "closing")
		$Childs.hide()

func _on_BtnContinue_pressed() -> void:
	_check_childs()
	get_tree().paused = false
	queue_free()

func _on_BtnSettings_pressed() -> void:
	var settings_win = Core.settings_res.instance()
	$Childs.add_child(settings_win)
	settings_win.connect("closing", self, "_on_closing_settings_win")
	$Childs.show()
	btn_settings.disabled = true

func _on_BtnInMainMenu_pressed() -> void:
	state = States.Exit
	_check_childs()
	_end_animation()

func _on_closing_settings_win():
	btn_settings.disabled = false
	$Childs.hide()

func _on_Animation_animation_finished(anim_name: String) -> void:
	if anim_name == "exit":
		match state:
			States.Exit:
				Core.load_scene("main_menu", Core.main_menu_res)
