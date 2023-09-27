extends HBoxContainer

@export var Fieldname : String = "{ fieldname }"
@export var Value : String = "{ value }"
@export var SpacerSize : int = 10


func _ready():
	$Fieldname.text = str(Fieldname, ":")
	$Value.text = Value
	$Spacer.custom_minimum_size.x = SpacerSize

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
