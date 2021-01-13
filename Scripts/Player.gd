extends Node2D


onready var animation = $Animation

var center
var offset
var game
var right = true

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent()
	center = get_viewport_rect().size.x / 2
	offset = abs(position.x - center)
	connect("area_entered", self, "_onAreaEntered")
	
func _onAreaEntered(area):
	if area.is_in_group("Axes"):
		game.die()

func _input(event):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		if event.position.x < center:
			position.x = center - offset
			scale.x = -abs(scale.x)
			right = false
		else:
			position.x = center + offset
			scale.x = abs(scale.x)
			right = true
		animation.play("punch")
		game.punchTree(right)