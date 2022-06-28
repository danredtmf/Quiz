extends Node

# Показывался ли splash_screen
var splash_screen_is_appeared: bool = false

# Для сервера
# | Хотел сделать сервер, где хранил бы ответы пользователей   |
# | Ответы бы использовались для анимации завершения викторины |
# - Отправлять ли данные на сервер
var sending_data_is_allowed: bool = false
# - Существует ли сервер
var is_server_exists: bool = false

# Данные
# - Игрок
var data_player: DataPlayer = loading_player()
# - Настройки
var data_settings: DataSettings = loading_settings()
# - Достижения
var data_achievements: DataAchievements

func _ready():
	data_settings.change_locale()

func loading_player() -> DataPlayer:
	if ResourceLoader.exists(DataPlayer.PATH):
		var data = ResourceLoader.load(DataPlayer.PATH)
		if data is DataPlayer:
			return data
		else:
			return DataPlayer.new()
	else:
		return DataPlayer.new()

func loading_settings() -> DataSettings:
	if ResourceLoader.exists(DataSettings.PATH):
		var data = ResourceLoader.load(DataSettings.PATH)
		if data is DataSettings:
			return data
		else:
			return DataSettings.new()
	else:
		return DataSettings.new()

func saving_player():
	var result = ResourceSaver.save(DataPlayer.PATH, data_player)
	if result == OK:
		print('complete loading settings')

func saving_settings():
	var result = ResourceSaver.save(DataSettings.PATH, data_settings)
	if result == OK:
		print('complete loading settings')

func clear_player():
	data_player = DataPlayer.new()
	Core.used_images.clear()

func clear_settings():
	data_settings = DataSettings.new()
