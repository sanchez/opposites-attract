extends Node2D

const NegativeIcon := preload("res://components/magnet/negative.png")
const PositiveIcon := preload("res://components/magnet/positive.png")

export (Charge.CHARGE_TYPE) var CHARGE = Charge.CHARGE_TYPE.POSITIVE_CHARGE
export (float) var STRENGTH = 1

onready var BodyNode := $Body
onready var MaggedNode := $Body/Magged
onready var ChargeIconNode := $ChargeIcon

func _ready():
	MaggedNode.CHARGE = CHARGE
	MaggedNode.STRENGTH = STRENGTH
	
	if CHARGE == Charge.CHARGE_TYPE.NEGATIVE_CHARGE:
		ChargeIconNode.texture = NegativeIcon
		
	if CHARGE == Charge.CHARGE_TYPE.POSITIVE_CHARGE:
		ChargeIconNode.texture = PositiveIcon


func get_mag_forces():
	var force_total = Vector2.ZERO
	var current_charge = MaggedNode.CHARGE
	
	var test = MaggedNode.get_overlapping_areas()
	for x in MaggedNode.get_overlapping_areas():
		if x is Charge:
			var dir = global_position - x.global_position
			var dist = dir.length_squared()
			var power = clamp(1_000_000 / dist, 0, 5_000) * x.STRENGTH
			var charge_type = x.CHARGE
			var charge_power = power * charge_type * current_charge
			var force = (dir / dist) * charge_power
			force_total += force
			
	return force_total


func _physics_process(delta):
	BodyNode.apply_central_impulse(get_mag_forces())
