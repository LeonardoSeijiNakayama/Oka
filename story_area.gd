extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_entered(_area: Area2D) -> void:
	get_tree().change_scene_to_file("res://EndStory.tscn")
	pass 
