class_name LabelBehaviour

extends Label

@export var options : Array[string]
@onready var index : int = options.find(self.text)

#func _ready():
#    index = options.find(text)

func next():
    if index < options.size - 1:
        index += 1
        text = options[index]

fund back():
    if index > 0:
        index -= 1
        text = options[index]
