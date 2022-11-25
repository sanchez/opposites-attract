extends Area2D


export (Charge.CHARGE_TYPE) var CHARGE = Charge.CHARGE_TYPE.NEGATIVE_CHARGE


const PositiveIcon := preload("res://components/magnet/positive.png")
const NegativeIcon := preload("res://components/magnet/negative.png")


func unlocked():
	return false
