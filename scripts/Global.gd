extends Node

# Prosty ekwipunek jako słownik
var inventory := {}

func add_item(item_name: String) -> void:
	inventory[item_name] = true
	print("Dodano do ekwipunku:", item_name)

func has_item(item_name: String) -> bool:
	return inventory.has(item_name)
