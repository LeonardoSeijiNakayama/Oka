extends CenterContainer
@onready var Credits = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	await get_tree().create_timer(2.0).timeout
	Credits.text = "Creditos:\nLeonardo Seiji Nakayama Prado\n João Henrique V. do Carmo\nThiago Antonio Costa do Nascimento\n Ana Laura Oliveira"
	if get_tree():
		await get_tree().create_timer(4.0).timeout
		get_tree().change_scene_to_file("res://ui/Menu.tscn")
	pass
