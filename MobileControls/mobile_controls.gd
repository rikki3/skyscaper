extends CanvasLayer

@onready var keyInInventory = get_node("invKey")
@onready var gameControls = get_node("Controls")

func _process(delta: float) -> void:
	if PlayerVariables.invKey:
		keyInInventory.show()
	else:
		keyInInventory.hide()
	if PlayerVariables.initialLand && PlayerVariables.playerExists:
		gameControls.show()
	else:
		gameControls.hide()
