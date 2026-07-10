class_name Meta
extends Node
## Run/meta systems kept separate from room combat.

const ALT_GUNS := ["default", "fanfare", "tuba", "metronome"]
var active_gun := "default"
var daily_seed := 0
var dissonance := 0
var run_motifs := 0

func _ready() -> void:
	PersistentSaveData.load_data()

func begin_run(date_string := "") -> int:
	var date := date_string if not date_string.is_empty() else Time.get_date_string_from_system()
	daily_seed = hash(date)
	run_motifs = 0
	return daily_seed

func select_gun(gun: String) -> bool:
	PersistentSaveData.load_data()
	if not ALT_GUNS.has(gun) or not PersistentSaveData.data.unlocked_guns.has(gun):
		return false
	active_gun = gun
	return true

func award_run_motifs(amount: int) -> void:
	run_motifs += amount
	PersistentSaveData.add_motifs(amount)

func set_dissonance(tier: int) -> bool:
	if tier < 0 or tier > 3:
		return false
	if tier > 0 and not PersistentSaveData.data.first_win:
		return false
	dissonance = tier
	return true
