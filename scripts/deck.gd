class_name Deck
extends Node
## All card effects resolve through this dictionary; Shooter and Slug consume it.

signal card_chosen(card_id: String)

const CARDS := {
	"split_chime": {"title": "Split Chime", "description": "Bounce 2 splits the slug in two."},
	"dead_weight": {"title": "Dead Weight", "description": "Dead slugs shove targets."},
	"long_echo": {"title": "Long Echo", "description": "+2 bounces, +1s lifetime."},
	"sanctified_floor": {"title": "Sanctified Floor", "description": "Dash leaves a light wall."},
	"last_note": {"title": "Last Note", "description": "Cadenza exit detonates live slugs."},
	"sympathetic_string": {"title": "Sympathetic String", "description": "Tuned kills chain to tuned targets."},
	"tuning_fork": {"title": "Tuning Fork", "description": "Tuning lasts longer."},
	"glass_crescendo": {"title": "Glass Crescendo", "description": "Live slugs gain one speed tier."},
	"mirror_chord": {"title": "Mirror Chord", "description": "Tuned targets stay tuned after a hit."},
	"quickened_step": {"title": "Quickened Step", "description": "Dash cooldown is shorter."},
	"resonant_skin": {"title": "Resonant Skin", "description": "Resonance notes heal one extra."},
	"overdrive": {"title": "Overdrive", "description": "Fire rate rises while Cadenza is ready."},
	"hollow_point": {"title": "Hollow Point", "description": "Dead slugs push harder."},
	"choir_memory": {"title": "Choir Memory", "description": "The first card repeats on room clear."},
	"finale": {"title": "Finale", "description": "The last room starts with 3 notes."},
}

var modifiers := {
	"split_chime": false,
	"dead_weight": false,
	"extra_bounces": 0,
	"extra_lifetime": 0.0,
	"sanctified_floor": false,
	"last_note": false,
	"sympathetic_string": false,
	"tuning_duration_bonus": 0.0,
	"live_speed_bonus": 0.0,
	"mirror_chord": false,
	"quickened_step": false,
	"resonant_skin": false,
	"overdrive": false,
	"hollow_point": false,
	"choir_memory": false,
	"finale": false,
}
var chosen_cards: Array[String] = []
var start_offers := ["split_chime", "long_echo", "dead_weight"]
var start_chosen := false
var encore_boons: Array[String] = []

func _ready() -> void:
	add_to_group("deck")

func choose_start(index: int) -> bool:
	if start_chosen or index < 0 or index >= start_offers.size():
		return false
	start_chosen = true
	apply_card(start_offers[index])
	return true

func apply_card(card_id: String) -> void:
	if not CARDS.has(card_id):
		return
	chosen_cards.append(card_id)
	match card_id:
		"split_chime": modifiers.split_chime = true
		"dead_weight": modifiers.dead_weight = true
		"long_echo":
			modifiers.extra_bounces += 2
			modifiers.extra_lifetime += 1.0
		"sanctified_floor": modifiers.sanctified_floor = true
		"last_note": modifiers.last_note = true
		"sympathetic_string": modifiers.sympathetic_string = true
		"tuning_fork": modifiers.tuning_duration_bonus += 1.0
		"glass_crescendo": modifiers.live_speed_bonus += 0.15
		"mirror_chord": modifiers.mirror_chord = true
		"quickened_step": modifiers.quickened_step = true
		"resonant_skin": modifiers.resonant_skin = true
		"overdrive": modifiers.overdrive = true
		"hollow_point": modifiers.hollow_point = true
		"choir_memory": modifiers.choir_memory = true
		"finale": modifiers.finale = true
	card_chosen.emit(card_id)

func choose_encore(index: int) -> bool:
	var choices := ["max_hp", "free_reroll"]
	if index < 0 or index >= choices.size():
		return false
	encore_boons.append(choices[index])
	return true
