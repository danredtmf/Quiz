extends PanelContainer

const bw_res = preload("res://resourses/shaders/bw.gdshader")

signal pressed

export(int) var state
export(int) var stage

export(Image) var image
export(AudioStreamOGGVorbis) var audio
export(String) var header_text = ""
export(bool) var is_black_white = false

enum BW_STATE { DEFAULT, BW }
var bw_state = BW_STATE.DEFAULT

func _ready():
	_config()
	_start_animation()

func _process(_delta):
	var time = "%1.0f" % $Timer.time_left
	$VB/HeaderPanel/Header.text = time

func _config():
	rect_pivot_offset = rect_size / 2
	$VB/TextureRect/Sh.hide()
	if is_black_white:
		$VB/TextureRect/Dot.show()
		set_process(true)
		_change_image()
		_check_bw()
		$Timer.start()
	else:
		$VB/TextureRect/Dot.hide()
		_set_header_text()
		_change_image()
		set_process(false)

func _set_header_text():
	$VB/HeaderPanel/Header.text = header_text

func _check_bw():
	if bw_state == BW_STATE.DEFAULT:
		$VB/TextureRect/Sh.hide()
		if !OS.has_feature("editor"):
			$VB/TextEdit.readonly = true
	elif bw_state == BW_STATE.BW:
		$VB/TextEdit.readonly = false
		$VB/TextureRect/Dot.hide()
		$VB/TextureRect/Sh.show()

func _change_image():
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$VB/TextureRect.texture = texture

func _start_animation():
	$Anim.play("show")

func _end_animation():
	$Anim.play("hide")

func _change_image_color():
	var sm = ShaderMaterial.new()
	var s = bw_res as Shader
	sm.shader = s
	$VB/TextureRect/Sh.material = sm

func _on_Next_pressed():
	if $VB/TextEdit.text != "":
		match state:
			Core.GAME_STATE.TEST1:
				Data.test_1_answers.append($VB/TextEdit.text)
			Core.GAME_STATE.TEST2:
				Data.test_2_answers.append($VB/TextEdit.text)
			Core.GAME_STATE.TEST3:
				Data.test_3_answers.append($VB/TextEdit.text)
		_end_animation()

func _on_Anim_animation_finished(anim_name):
	if anim_name == "hide":
		emit_signal("pressed")
		queue_free()

func _on_Timer_timeout():
	match bw_state:
		BW_STATE.DEFAULT:
			_change_image_color()
			bw_state = BW_STATE.BW
			set_process(false)
			_check_bw()
			_set_header_text()

func _play_audio():
	pass
