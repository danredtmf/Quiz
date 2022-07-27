extends Control

var word = ""

var secret_pics = {
	Data.secret_words[0]: Core.secret_images[0],
	Data.secret_words[1]: Core.secret_images[1],
	Data.secret_words[2]: Core.secret_images[2],
	Data.secret_words[3]: Core.secret_images[3],
	Data.secret_words[4]: Core.secret_images[4],
}

func _input(event):
	if event is InputEventKey and not event.is_pressed():
		if event.scancode != KEY_ENTER and event.scancode != KEY_F5 and event.scancode != KEY_SHIFT and event.scancode != KEY_ALT:
			word += event.as_text()
		elif event.scancode == KEY_ENTER:
			_check_secret_word()

func _change_secret_picture(name: String) -> void:
	var texture = ImageTexture.new()
	var image: Image = secret_pics[name]
	texture.create_from_image(image)
	
	$SecretPic.texture = texture

func _check_secret_word():
	for secret in Data.secret_words:
		word = word.to_lower()
		print(word)
		if word == secret:
			if word == Data.secret_words.back(): # "ben"
				_gen_secret_sound()
				if Data.data_achievements.open_secret_sounds.size() > 4:
					Data.data_achievements.add_word(word)
					Data.data_achievements.check_achievement()
				break
			else:
				_show_secret_pic()
				Data.data_achievements.add_word(word)
				Data.data_achievements.check_achievement()
				break
	
	word = ""

func _gen_secret_sound():
	if Data.data_achievements.open_secret_sounds.size() < 1:
		var sound = Core.secret_sounds.front()
		var sound_name = Data.secret_sounds.front()
		$SoundPlayer.stream = sound
		_play_sound()
		
		Data.data_achievements.add_secret_sound(sound_name)
		Data.data_achievements.check_achievement()
	else:
		var i = 0
		while i == 0:
			for s in Core.secret_sounds:
				var sound = s
				var sound_name = Data.secret_sounds[Core.secret_sounds.rfind(s)]
				if sound_name != Data.secret_sounds.front():
					if randi() % 3 == 0:
						i = 1
						$SoundPlayer.stream = sound
						_play_sound()
						
						Data.data_achievements.add_secret_sound(sound_name)
						Data.data_achievements.check_achievement()
						break

func _show_secret_pic():
	_change_secret_picture(word)
	$SecretPic.show()
	$DelaySecretPic.start()

func _on_DelaySecretPic_timeout():
	$SecretPic.hide()

func _play_sound():
	$SoundPlayer.play()
