extends Node2D

signal test_passed
signal test_failed

signal controls_button_pressed

var controls_screen_visible:bool
@onready var main_menu:Node3D = $MainMenu
@onready var controls_screen:Node3D = $MainMenu/MainMenuCanvas/Controls
@onready var controls_canvas:CanvasLayer = $MainMenu/MainMenuCanvas/Controls/ControlsCanvas

var checkpoint_one:bool = false
var checkpoint_two:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	run_test()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func run_test() -> void:
	controls_screen_visible = controls_canvas.visible
	
	await get_tree().create_timer(0.5).timeout
	
	if main_menu.has_signal("show_controls"):
		main_menu.emit_signal("show_controls")
		
		if controls_canvas.visible:
			controls_screen_visible = true
			checkpoint_one = true
		else:
			test_failed.emit()
			return
	
	await get_tree().create_timer(0.5).timeout
	
	if controls_screen.has_signal("close_controls"):
		controls_screen.emit_signal("close_controls")
		
		await get_tree().create_timer(0.5).timeout
		
		if not controls_canvas.visible:
			controls_screen_visible = false
			checkpoint_two = true
		else:
			test_failed.emit()
			return
	
	if checkpoint_one:
		if checkpoint_two:
			print("Test Passed!")
			test_passed.emit()
			await get_tree().create_timer(1).timeout
			return
