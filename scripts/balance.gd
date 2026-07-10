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
