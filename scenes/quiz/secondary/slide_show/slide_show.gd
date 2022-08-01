extends Control

export(int) var MIN_IMAGES = 7

var slide_show_pics = []

func _ready():
	_config()

func _config():
	_choose_pictures()
	_change_pictures(1)
	_change_pictures(2)
	_start_animation()

func _start_animation():
	$Anim.play("show_2")

func _choose_pictures():
	for img in Core.abandoned_houses:
		if randi() % 10 == 0:
			slide_show_pics.append(img)

	for img in Core.illuminating_spaces:
		if randi() % 10 == 0:
			slide_show_pics.append(img)

	for img in Core.abstraction:
		if randi() % 10 == 0:
			slide_show_pics.append(img)

	for img in Core.animals:
		if randi() % 10 == 0:
			slide_show_pics.append(img)

	for img in Core.unusual_people:
		if randi() % 10 == 0:
			slide_show_pics.append(img)

	for img in Core.structures:
		if randi() % 10 == 0:
			slide_show_pics.append(img)
	
	if slide_show_pics.size() < MIN_IMAGES:
		slide_show_pics.clear()
		slide_show_pics.append_array(Core.special_images)

func _change_pictures(number: int) -> void:
	var texture = ImageTexture.new()
	var image: Image = slide_show_pics[randi() % slide_show_pics.size()]
	
	texture.create_from_image(image)
	
	if number == 1:
		$Pic1.texture = texture
	elif number == 2:
		$Pic2.texture = texture

func _on_Anim_animation_finished(anim_name):
	if anim_name == "show_2":
		_change_pictures(1)
		$Anim.play("show_1")
	elif anim_name == "show_1":
		_change_pictures(2)
		$Anim.play("show_2")
