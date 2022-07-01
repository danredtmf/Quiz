extends Control

export(int) var MIN_IMAGES = 7

var word = ""

var slide_show_pics = []

var secret_pics = {
	Data.secret_words[0]: Core.secret_images[0],
	Data.secret_words[1]: Core.secret_images[1],
	Data.secret_words[2]: Core.secret_images[2],
	Data.secret_words[3]: Core.secret_images[3],
	Data.secret_words[4]: Core.secret_images[4],
}

var special_image: Image

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
	randomize()
	
	var count = 0
	
	print("Starting load images for slide show...")
	
	print("	Step 1 / 6")
	for img in Core.abandoned_houses:
		if Core.get_rand_chance() <= 10:
			slide_show_pics.append(img)
			Data.data_achievements.add_image(img)
			count += 1
	
	print("	Step 2 / 6")
	for img in Core.illuminating_spaces:
		if Core.get_rand_chance() <= 10:
			slide_show_pics.append(img)
			Data.data_achievements.add_image(img)
			count += 1
	
	print("	Step 3 / 6")
	for img in Core.abstraction:
		if Core.get_rand_chance() <= 10:
			slide_show_pics.append(img)
			Data.data_achievements.add_image(img)
			count += 1
	
	print("	Step 4 / 6")
	for img in Core.animals:
		if Core.get_rand_chance() <= 10:
			slide_show_pics.append(img)
			Data.data_achievements.add_image(img)
			count += 1
	
	print("	Step 5 / 6")
	for img in Core.unusual_people:
		if Core.get_rand_chance() <= 10:
			slide_show_pics.append(img)
			Data.data_achievements.add_image(img)
			count += 1
	
	print("	Step 6 / 6")
	for img in Core.structures:
		if Core.get_rand_chance() <= 10:
			slide_show_pics.append(img)
			Data.data_achievements.add_image(img)
			count += 1
	
	Data.data_achievements.check_achievement()
	
	special_image = Core.special_images[randi() % Core.special_images.size()]
	
	print("	Loaded images: {0}".format([count]))
	
	if count < MIN_IMAGES:
		print("	Oops! Few images! Showing a question mark. Hmm...")

func _change_pictures(number: int) -> void:
	randomize()
	
	var texture = ImageTexture.new()
	var image: Image
	if slide_show_pics.size() >= MIN_IMAGES:
		image = slide_show_pics[randi() % slide_show_pics.size()]
	else:
		image = special_image
	
	texture.create_from_image(image)
	
	if number == 1:
		$Pic1.texture = texture
	elif number == 2:
		$Pic2.texture = texture

func _change_secret_picture(name: String) -> void:
	var texture = ImageTexture.new()
	var image: Image = secret_pics[name]
	texture.create_from_image(image)
	
	$SecretPic.texture = texture

func _on_Anim_animation_finished(anim_name):
	if anim_name == "show_2":
		_change_pictures(1)
		$Anim.play("show_1")
	elif anim_name == "show_1":
		_change_pictures(2)
		$Anim.play("show_2")

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode != KEY_ENTER:
			word += event.as_text()
		else:
			_check_secret_word()

func _check_secret_word():
	for secret in Data.secret_words:
		word = word.to_lower()
		if word == secret:
			_show_secret_pic()
			Data.data_achievements.add_word(word)
			Data.data_achievements.check_achievement()
	
	word = ""

func _show_secret_pic():
	_change_secret_picture(word)
	$SecretPic.show()
	$DelaySecretPic.start()

func _on_DelaySecretPic_timeout():
	$SecretPic.hide()
