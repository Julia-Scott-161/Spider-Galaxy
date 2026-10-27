extends Node3D

#signals to emit when play or controls button pressed
signal play_game
signal show_controls

@onready var control_screen: Node3D = $MainMenuCanvas/Controls
@onready var control_canvas: CanvasLayer = $MainMenuCanvas/Controls/ControlsCanvas

func _ready() -> void:
	#set this instance as the global main_menu
	Global.main_menu = self
	
	#connect the show_controls signal to the show_control_screen func
	show_controls.connect(show_control_screen)
	
	#ensure close_controls exists and connect it to close_control_screen
	if control_screen.has_signal("close_controls"):
		control_screen.close_controls.connect(close_control_screen)
	
	#initially hide the control_canvas
	control_canvas.hide()

#Signal to catch when the play button is pressed
func _on_play_button_pressed() -> void:
	play_game.emit()

#Signal to catch when the controls button is pressed
func _on_controls_button_pressed() -> void:
	show_controls.emit()

#show the control screen when the control button is pressed
func show_control_screen() -> void:
	control_canvas.show()

#hide the control screen when the close_controls signal is emitted
func close_control_screen() -> void:
	control_canvas.hide()
