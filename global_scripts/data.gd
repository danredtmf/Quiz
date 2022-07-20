extends Node

# Показывался ли splash_screen
var splash_screen_is_appeared: bool = false
# Играл ли игрок после запуска
# | Нужно для того, чтобы лишний раз не появлялось окно demo_win |
var is_playing: bool = false

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
var data_player: DataPlayer = DataPlayer.new()
# - Настройки
var data_settings: DataSettings = DataSettings.new()
# - Достижения
var data_achievements: DataAchievements = DataAchievements.new()
# - Секретные слова
var secret_words: Array = ["secret", "haggy", "minecraft", "gachi", "floppa", "ben"]
# - Названия особенных звуков
var special_sounds: Array = [
	"are_you_playing",
	"aughhhhh",
	"blue_hg",
	"bruh",
	"connect",
	"cool_dude",
	"disconnect",
	"ha",
	"hello",
	"joke",
]
# - Названия секретных звуков
var secret_sounds: Array = [
	"ben",
	"yes",
	"no",
	"laugh",
	"ughhh",
]

func _ready():
	data_player.loading()
	data_settings.loading()
	data_achievements.loading()
	
	data_settings.change_locale()
	data_settings.set_volume()

func clear_data():
	Core.used_images.clear()
	is_playing = false
	data_player.clear_quiz()
	data_achievements.is_chapter_two_opened = false

func clear_player():
	data_player = DataPlayer.new().duplicate()
	data_player.saving()

func clear_settings():
	data_settings = DataSettings.new().duplicate()
	data_settings.change_locale()
	data_settings.reset_volume()
	data_settings.saving()

func clear_achievements():
	data_achievements = DataAchievements.new().duplicate()
	data_achievements.saving()
