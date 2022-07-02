extends Node

const splash_screen_res = preload("res://scenes/splash_screen/splash_screen.tscn")
const main_menu_res = preload("res://scenes/main_menu/main_menu.tscn")
# Окно соглашения
const send_data_question_res = preload("res://scenes/quiz/secondary/send_data_question/send_data_question.tscn")
const game_res = preload("res://scenes/quiz/game/game.tscn")

const achievements_res = preload("res://scenes/achievements/achievements.tscn")
const settings_res = preload("res://scenes/settings/settings.tscn")
const about_res = preload("res://scenes/about/about.tscn")

const enter_nickname_res = preload("res://scenes/quiz/secondary/enter_nickname/enter_nickname.tscn")
const info_res = preload("res://scenes/quiz/secondary/info/info.tscn")
const testing_res = preload("res://scenes/quiz/secondary/testing/testing.tscn")
const ending_res = preload("res://scenes/quiz/ending/ending.tscn")

enum GAME_STATE { ENTER_NICKNAME, TEST1, TEST2, TEST3, ENDING }
enum TEST_STAGE { NONE, ONE, TWO, THREE }

const abandoned_houses: Array = [
	preload("res://resourses/images/abandoned_houses/1_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/2_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/3_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/4_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/5_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/6_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/7_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/8_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/9_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/10_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/11_1080p.jpg"),
	preload("res://resourses/images/abandoned_houses/12_1080p.jpg"),
]

const illuminating_spaces: Array = [
	preload("res://resourses/images/illuminating_spaces/abstract_psychedelic_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/liminal_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/liminal_2_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/liminal_3_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/liminal_4_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/dark_room_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/dark_room_2_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/forest_top_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/hallway_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/school_room_1080p.jpg"),
	preload("res://resourses/images/illuminating_spaces/waiting_room_1080p.png"),
	preload("res://resourses/images/illuminating_spaces/water_maze_1080p.jpg"),
]

const abstraction: Array = [
	preload("res://resourses/images/abstraction/1_1080p.jpg"),
	preload("res://resourses/images/abstraction/2_1080p.jpg"),
	preload("res://resourses/images/abstraction/3_1080p.jpg"),
	preload("res://resourses/images/abstraction/4_1080p.jpg"),
	preload("res://resourses/images/abstraction/5_1080p.jpg"),
	preload("res://resourses/images/abstraction/6_1080p.jpg"),
	preload("res://resourses/images/abstraction/7_1080p.jpg"),
	preload("res://resourses/images/abstraction/8_1080p.jpg"),
	preload("res://resourses/images/abstraction/9_1080p.jpg"),
	preload("res://resourses/images/abstraction/10_1080p.jpg"),
	preload("res://resourses/images/abstraction/11_1080p.jpg"),
	preload("res://resourses/images/abstraction/12_1080p.jpg"),
]

const animals: Array = [
	preload("res://resourses/images/animals/10_1080p.jpg"),
	preload("res://resourses/images/animals/3_1080p.jpg"),
	preload("res://resourses/images/animals/6_1080p.jpg"),
	preload("res://resourses/images/animals/caracal_1080p.jpg"),
	preload("res://resourses/images/animals/caracal_2_1080p.jpg"),
	preload("res://resourses/images/animals/cougar_1080p.jpg"),
	preload("res://resourses/images/animals/fox_1080p.jpg"),
	preload("res://resourses/images/animals/fox_2_1080p.jpg"),
	preload("res://resourses/images/animals/fox_3_1080p.jpg"),
	preload("res://resourses/images/animals/fox_4_1080p.jpg"),
	preload("res://resourses/images/animals/lynx_1080p.jpg"),
	preload("res://resourses/images/animals/wolf_1080p.jpg"),
]

const unusual_people: Array = [
	preload("res://resourses/images/unusual_people/1_1080p.jpg"),
	preload("res://resourses/images/unusual_people/2_1080p.jpg"),
	preload("res://resourses/images/unusual_people/3_1080p.jpg"),
	preload("res://resourses/images/unusual_people/4_1080p.jpg"),
	preload("res://resourses/images/unusual_people/5_1080p.jpg"),
	preload("res://resourses/images/unusual_people/6_1080p.jpg"),
	preload("res://resourses/images/unusual_people/7_1080p.jpg"),
	preload("res://resourses/images/unusual_people/8_1080p.jpg"),
	preload("res://resourses/images/unusual_people/9_1080p.jpg"),
	preload("res://resourses/images/unusual_people/10_1080p.jpg"),
	preload("res://resourses/images/unusual_people/11_1080p.jpg"),
	preload("res://resourses/images/unusual_people/12_1080p.jpeg"),
]

const structures: Array = [
	preload("res://resourses/images/structures/1_1080p.jpg"),
	preload("res://resourses/images/structures/2_1080p.jpg"),
	preload("res://resourses/images/structures/3_1080p.jpg"),
	preload("res://resourses/images/structures/4_1080p.jpg"),
	preload("res://resourses/images/structures/5_1080p.jpg"),
	preload("res://resourses/images/structures/6_1080p.jpg"),
	preload("res://resourses/images/structures/7_1080p.jpg"),
	preload("res://resourses/images/structures/8_1080p.jpg"),
	preload("res://resourses/images/structures/9_1080p.jpg"),
	preload("res://resourses/images/structures/10_1080p.jpg"),
	preload("res://resourses/images/structures/11_1080p.jpg"),
	preload("res://resourses/images/structures/12_1080p.jpg"),
]

const secret_images: Array = [
	preload("res://resourses/images/secret_images/secret.jpg"),
	preload("res://resourses/images/secret_images/haggy.jpg"),
	preload("res://resourses/images/secret_images/minecraft.jpg"),
	preload("res://resourses/images/secret_images/gachi.jpg"),
	preload("res://resourses/images/secret_images/floppa.jpeg"),
]

const special_images: Array = [
	preload("res://resourses/images/special_images/question_mark_1080p.jpg"),
	preload("res://resourses/images/special_images/question_mark_2_1080p.png"),
	preload("res://resourses/images/special_images/question_mark_3_1080p.jpg"),
]

const special_sounds: Array = [
	preload("res://resourses/audio/special_sounds/are_you_playing.ogg"),
	preload("res://resourses/audio/special_sounds/aughhhhh.ogg"),
	preload("res://resourses/audio/special_sounds/blue_hg.ogg"),
	preload("res://resourses/audio/special_sounds/bruh.ogg"),
	preload("res://resourses/audio/special_sounds/connect.ogg"),
	preload("res://resourses/audio/special_sounds/cool_dude.ogg"),
	preload("res://resourses/audio/special_sounds/disconnect.ogg"),
	preload("res://resourses/audio/special_sounds/ha.ogg"),
	preload("res://resourses/audio/special_sounds/hello.ogg"),
	preload("res://resourses/audio/special_sounds/joke.ogg"),
]

var used_images: Array = []

func load_scene(scene_name: String, scene: PackedScene):
	var err = get_tree().change_scene_to(scene)
	if err == OK:
		print("Status load \"{0}\": OK".format([scene_name]))
	elif err == ERR_CANT_CREATE:
		print("Status load \"{0}\": ERR_CANT_CREATE".format([scene_name]))

func get_audio_name(audio: AudioStreamOGGVorbis) -> String:
	var name = Data.special_sounds[special_sounds.rfind(audio)]
	
	return name

func get_audio(name: String) -> AudioStreamOGGVorbis:
	var audio: AudioStreamOGGVorbis = special_sounds[Data.special_sounds.rfind(name)]
	
	return audio

func get_rand_screen_position() -> Vector2:
	randomize()
	return Vector2(rand_range(0, get_viewport().size.x / 3), rand_range(0, get_viewport().size.y))

func get_rand_chance() -> float:
	randomize()
	return rand_range(0, 100)

func shuffle_images():
	abandoned_houses.shuffle()
	illuminating_spaces.shuffle()
	abstraction.shuffle()
	animals.shuffle()
	unusual_people.shuffle()
	structures.shuffle()

func image_is_used(image: Image) -> bool:
	if used_images.find(image) != -1: return true
	else: return false
