extends SceneTree

const DeckScript := preload("res://scripts/deck.gd")
var failures: Array[String] = []

func _init() -> void:
	_check(DeckScript.CARDS.size() >= 15, "Act 1 must expose at least 15 cards")
	for card_id in DeckScript.CARDS:
		var deck := DeckScript.new()
		deck.apply_card(card_id)
		_check(deck.chosen_cards.has(card_id), "%s must register as chosen" % card_id)
		deck.free()
	var split_deck := DeckScript.new()
	split_deck.apply_card("split_chime")
	_check(split_deck.modifiers.split_chime, "Split Chime must enable bounce-2 split")
	split_deck.free()
	var echo_deck := DeckScript.new()
	echo_deck.apply_card("long_echo")
	_check(echo_deck.modifiers.extra_bounces == 2 and is_equal_approx(echo_deck.modifiers.extra_lifetime, 1.0), "Long Echo must change slug lifespan and cap")
	echo_deck.free()
	var encore_deck := DeckScript.new()
	_check(encore_deck.choose_encore(0) and encore_deck.encore_boons.has("max_hp"), "Encore must offer a boon choice")
	encore_deck.free()
	if failures.is_empty():
		print("PASS test_deck_cards: all card effects register through Deck.modifiers")
		quit(0)
	for failure in failures:
		push_error(failure)
	quit(1)

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
