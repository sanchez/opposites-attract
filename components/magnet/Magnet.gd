extends Charge

const NegativeIcon := preload("res://components/magnet/negative.png")
const PositiveIcon := preload("res://components/magnet/positive.png")

onready var ChargeNode := $Charge

func _ready():
	if CHARGE == CHARGE_TYPE.NEGATIVE_CHARGE:
		ChargeNode.texture = NegativeIcon
		
	if CHARGE == CHARGE_TYPE.POSITIVE_CHARGE:
		ChargeNode.texture = PositiveIcon
