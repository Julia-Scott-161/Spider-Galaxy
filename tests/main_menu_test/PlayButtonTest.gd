extends Node2D

signal test_passed
signal test_failed

signal play_button

var main_menu_visible:bool
@onready var main_menu:Node3D = $MainGameScene/MainMenu
@onready var main_game:Node3D = $MainGameScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	run_test()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func run_test() -> void:
	if main_game.has_node("/root/PlayButtonTest/MainGameScene/MainMenu"):
		main_menu_visible = true
	else:
		main_menu_visible = false
		test_failed.emit()
		return
	
	if main_menu.has_signal("play_game"):
		main_menu.emit_signal("play_game")
		
		await get_tree().create_timer(0.5).timeout
		
		if not main_game.has_node("/root/PlayButtonTest/MainGameScene/MainMenu"):
			main_menu_visible = false
		else:
			test_failed.emit()
			return
	
	if not main_menu_visible:
		print("test passed")
		test_passed.emit()
		return
