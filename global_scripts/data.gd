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

# Данные звуковых дорожок
var master_idx = AudioServer.get_bus_index('Master')
var music_idx = AudioServer.get_bus_index('Music')
var sound_idx = AudioServer.get_bus_index('Sound')

# Данные
# - Игрок
var data_player: DataPlayer = loading_player()
# - Настройки
var data_settings: DataSettings = loading_settings()
# - Достижения
var data_achievements: DataAchievements = loading_achievements()
# - Секретные слова
var secret_words: Array = ["secret", "haggy", "minecraft", "gachi", "floppa"]

func _ready():
	data_settings.change_locale()
	data_settings.set_volume()

func loading_player() -> DataPlayer:
	var empty = DataPlayer.new()
	if ResourceLoader.exists(DataPlayer.PATH):
		var data = ResourceLoader.load(DataPlayer.PATH)
		if data is DataPlayer:
			return data.duplicate()
		else:
			return empty.duplicate()
	else:
		return empty.duplicate()

func loading_settings() -> DataSettings:
	var empty = DataSettings.new()
	if ResourceLoader.exists(DataSettings.PATH):
		var data = ResourceLoader.load(DataSettings.PATH)
		if data is DataSettings:
			return data.duplicate()
		else:
			return empty.duplicate()
	else:
		return empty.duplicate()

func loading_achievements() -> DataAchievements:
	var empty = DataAchievements.new()
	if ResourceLoader.exists(DataAchievements.PATH):
		var data = ResourceLoader.load(DataAchievements.PATH)
		if data is DataAchievements:
			return data.duplicate()
		else:
			return empty.duplicate()
	else:
		return empty.duplicate()

func clear_player():
	data_player = DataPlayer.new().duplicate()
	Core.used_images.clear()

func clear_settings():
	data_settings = DataSettings.new().duplicate()
	data_settings.change_locale()
	data_settings.reset_volume()
	data_settings.saving()

func clear_achievements():
	data_achievements = DataAchievements.new().duplicate()
	data_achievements.saving()
