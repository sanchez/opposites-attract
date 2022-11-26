extends Area2D


export (Charge.CHARGE_TYPE) var CHARGE = Charge.CHARGE_TYPE.NEGATIVE_CHARGE


const PositiveIcon := preload("res://components/magnet/positive.png")
const NegativeIcon := preload("res://components/magnet/negative.png")


onready var ChargeIconNode := $ChargeIcon


func get_total_charge():
	var charge_total = 0.0
	
	for x in get_overlapping_areas():
		if x is Charge:
			var dir = global_position - x.global_position
			var dist = dir.length_squared()
			var power = clamp(1_000_000 / dist, 0, 5_000) * x.STRENGTH
			var charge_type = x.CHARGE
			var charge_power = power * charge_type * CHARGE
			charge_total += charge_power
	
	return charge_total


func unlocked():
	var charge_total = get_total_charge()
	return charge_total <= -1


func _process(delta):
	if CHARGE == Charge.CHARGE_TYPE.NEGATIVE_CHARGE:
		ChargeIconNode.texture = NegativeIcon
	elif CHARGE == Charge.CHARGE_TYPE.POSITIVE_CHARGE:
		ChargeIconNode.texture = PositiveIcon
	else:
		ChargeIconNode.texture = null
