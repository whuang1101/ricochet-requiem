class_name PersistentSaveData
extends Node
## Versioned persistent meta state. Tests set readonly so disk is never touched.

const PATH := "user://ricochet_requiem_save.json"
static var data: Dictionary = {}
static var readonly := false

static func load_data() -> void:
	if not data.is_empty():
		return
	data = {"version": 1, "motifs": 0, "first_win": false, "unlocked_guns": ["default"], "dissonance": 0}
	if FileAccess.file_exists(PATH):
		var parsed = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		if parsed is Dictionary:
			data.merge(parsed, true)

static func save() -> void:
	if readonly:
		return
	load_data()
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

static func add_motifs(amount: int) -> void:
	load_data()
	data.motifs += amount
	save()

static func unlock_gun(gun: String) -> void:
	load_data()
	if not data.unlocked_guns.has(gun):
		data.unlocked_guns.append(gun)
		save()
