extends StaticBody2D

const DoorClosedTexture := preload("res://components/door/door.png")
const DoorOpenTexture := preload("res://components/door/door-open.png")


onready var SpriteNode := $Sprite
onready var ClosedShapeNode := $ClosedShape


export (NodePath) var SWITCH

onready var SwitchNode = get_node(SWITCH)


func _process(delta):
	if SwitchNode.unlocked():
		SpriteNode.texture = DoorOpenTexture
		ClosedShapeNode.disabled = true
	else:
		SpriteNode.texture = DoorClosedTexture
		ClosedShapeNode.disabled = false
