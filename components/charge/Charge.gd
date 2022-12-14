extends Area2D
class_name Charge

enum CHARGE_TYPE { POSITIVE_CHARGE = 1, NO_CHARGE = 0, NEGATIVE_CHARGE = -1}

export (CHARGE_TYPE) var CHARGE = CHARGE_TYPE.POSITIVE_CHARGE
export (float) var STRENGTH = 1
