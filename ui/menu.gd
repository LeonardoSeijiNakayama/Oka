extends GridContainer

@onready var BtnPlay : Button = $BtnPlay
@onready var BtnExit : Button = $BtnExit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BtnPlay.pressed.connect(on_BtnPlay_Pressed)
	BtnExit.pressed.connect(on_BtnExit_Pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_BtnPlay_Pressed()->void:
	get_tree().change_scene_to_file("res://ui/Story.tscn")
func on_BtnExit_Pressed()->void:
	get_tree().quit()
