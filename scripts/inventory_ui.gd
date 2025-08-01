extends CanvasLayer

@onready var container := $Panel/VBoxContainer

func _ready():
	update_inventory()

func update_inventory():
	# Usuń wszystkie istniejące dzieci (np. stare Label'e)
	for child in container.get_children():
		child.queue_free()

	# Dodaj nowe Label'e z przedmiotami
	for item in Global.inventory.keys():
		var label = Label.new()
		label.text = "- " + item.capitalize()
		container.add_child(label)


func _process(_delta):
	if Input.is_action_just_pressed("ui_inventory"):
		visible = !visible
		if visible:
			update_inventory()
