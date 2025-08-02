extends Button
 
@export var category:String

func sendEventToTeeth():
	var teethNode = self.get_parent().get_child(1)
	if teethNode.name == "teeth":
		teethNode.switchCollectingCategory(category)
func _ready() -> void:
	self.pressed.connect(sendEventToTeeth)
