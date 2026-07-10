extends Node
## The single source of truth for gameplay tuning. Keep gameplay numbers here.

const ROOM_SIZE := Vector2(1120.0, 560.0)
const PLAYER_SPEED := 300.0
const DASH_SPEED := 750.0
const DASH_DURATION := 0.15
const DASH_COOLDOWN := 0.8
const DASH_IFRAMES := 0.25
const FIRE_RATE := 2.5
const MAX_SLUGS := 4
const SLUG_SPEED := 520.0
const SLUG_BOUNCE_SPEED_MULTIPLIER := 1.15
const SLUG_LIFETIME := 2.5
const MAX_BOUNCES := 5
const DAMAGE_TIERS := [0, 1, 2, 4, 6, 9]
const PLAYER_RADIUS := 16.0
const SLUG_RADIUS := 6.0
const WALL_THICKNESS := 24.0
const PLAYER_MAX_HP := 10
const SELF_DAMAGE_FRACTION := 0.25
const ENEMY_CONTACT_DAMAGE := 1
const WAILER_FIRE_INTERVAL := 1.8
const WAILER_SHOT_SPEED := 260.0
const WAILER_SHOT_DAMAGE := 1
const REQUIEM_CADENZA_NOTES := 12
const REQUIEM_BANK_CAP := 24
const REQUIEM_DECAY_INTERVAL := 3.0
const CADENZA_DURATION := 3.0
const GRAND_CADENZA_DURATION := 5.0
const CADENZA_TIME_SCALE := 0.2
const TUNING_DURATION := 2.5
const RESONANCE_HEAL := 2
const RESONANCE_LIFETIME := 8.0
const RESONANCE_PICKUP_RADIUS := 28.0
const ENEMY_RADIUS := 18.0
const ENEMY_SPEED := {
	"chorister": 72.0,
	"sidler": 96.0,
	"wailer": 60.0,
}
const ENEMY_HP := {
	"chorister": 3,
	"sidler": 4,
	"wailer": 3,
}
