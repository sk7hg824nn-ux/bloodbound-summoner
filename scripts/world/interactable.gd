extends Area2D
class_name Interactable

@export var interact_id: String = ""
@export var title: String = "Examine"
@export var prompt: String = "Inspect"

signal activated(id: String)


func _ready() -> void:
	collision_layer = 16
	collision_mask = 1
	monitoring = true


func try_activate() -> void:
	activated.emit(interact_id)
