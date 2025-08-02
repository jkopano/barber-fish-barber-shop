extends Button
 
func switchCategory():
	self.get_parent().setCategory(name)
func _ready() -> void:
	self.pressed.connect(switchCategory)
