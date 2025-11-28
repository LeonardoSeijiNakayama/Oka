extends CenterContainer

@onready var StoryLabel: Label = $Label

func _ready() -> void:
	# Começa a sequência da história
	start_story()


func start_story() -> void:
	await get_tree().create_timer(2.0).timeout
	
	await type_text("Sua jornada ainda nao acabou...", 1.0)
	await get_tree().create_timer(2.0).timeout
	
	await type_text("Mantenha sua brasa acesa.", 1.0)
	await get_tree().create_timer(2.0).timeout
	
	
	if get_tree():
		get_tree().change_scene_to_file("res://World.tscn")


func type_text(text: String, time: float) -> void:
	StoryLabel.text = text
	StoryLabel.visible_characters = 0

	var tween = create_tween()
	tween.tween_property(
		StoryLabel,
		"visible_characters",
		StoryLabel.get_total_character_count(),
		time # duração em segundos
	)
	await tween.finished
