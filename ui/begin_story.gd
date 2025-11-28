extends CenterContainer

@onready var StoryLabel: Label = $StoryLabel

func _ready() -> void:
	# Começa a sequência da história
	start_story()


func start_story() -> void:
	await get_tree().create_timer(2.0).timeout
	
	await type_text("As vezes, a esperanca e a ultima \n coisa que nos resta.")
	await get_tree().create_timer(2.0).timeout
	
	await type_text("A ultima brasa de uma fogueira extinguida.")
	await get_tree().create_timer(2.0).timeout
	
	await type_text("Sera que vale a pena lutar por ela?")
	await get_tree().create_timer(2.0).timeout
	
	if get_tree():
		get_tree().change_scene_to_file("res://World.tscn")


func type_text(text: String) -> void:
	StoryLabel.text = text
	StoryLabel.visible_characters = 0

	var tween = create_tween()
	tween.tween_property(
		StoryLabel,
		"visible_characters",
		StoryLabel.get_total_character_count(),
		2.0 # duração em segundos
	)
	await tween.finished
