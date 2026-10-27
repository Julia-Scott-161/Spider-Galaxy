extends Node3D

signal play_button_selected
@onready var main_menu:Node3D = $MainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#assign the main game scene as the node creation parent
	Global.node_creation_parent = self
	
	#connect the play_game button to the close_main_menu func
	main_menu.play_game.connect(close_main_menu)
	#pause the entire tree and wait for the play button to be pressed
	get_tree().paused = true
	await play_button_selected

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Close the main menu and resume the game to be played
func close_main_menu() -> void:
	#free the main menu from the tree as it is not needed until the tree is reloaded
	main_menu.queue_free()
	get_tree().paused = false
	play_button_selected.emit()
