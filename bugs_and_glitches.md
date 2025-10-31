# Bugs and Glitches

These are documented bugs and glitches in the original Pokémon Trading Card Game.

Fixes are written in the `diff` format.

```diff
 this is some code
-delete red - lines
+add green + lines
```

## Game engine

### AI does not use Shift properly

The AI misuses the Shift Pkmn Power. It reads garbage data if there is a Clefairy Doll or Mysterious Fossil in play and also does not account for already changed types (including its own Shift effect).

**Fix:** Edit `HandleAIShift` in [src/engine/duel/ai/pkmn_powers.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/pkmn_powers.asm):
```diff
HandleAIShift:
	...
.CheckWhetherTurnDuelistHasColor
	ld a, [wAIDefendingPokemonWeakness]
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
+	ld c, PLAY_AREA_ARENA
.loop_play_area
	ld a, [hli]
	cp $ff
	jr z, .false
	push bc
-	call GetCardIDFromDeckIndex
-	call GetCardType ; bug, this could be a Trainer card
+	ld a, c
+	call GetPlayAreaCardColor
	call TranslateColorToWR
	pop bc
	and b
-	jr z, .loop_play_area
+	jr nz, .true
+	inc c
+	jr .loop_play_area
-; true
+.true
	scf
	ret
.false
	or a
	ret
	...
```

### AI does not use Cowardice properly

The AI does not respect the rule in Cowardice which states it cannot be used on the same turn as when Tentacool was played.

**Fix:** Edit `HandleAICowardice` in [src/engine/duel/ai/pkmn_powers.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/pkmn_powers.asm):
```diff
; handles AI logic for Cowardice
HandleAICowardice:
	...
.CheckWhetherToUseCowardice
	ld a, c
	ldh [hTemp_ffa0], a
	ld e, a
+	add DUELVARS_ARENA_CARD_FLAGS
+	call GetTurnDuelistVariable
+	and CAN_EVOLVE_THIS_TURN
+	ret z ; return if was played this turn
	...
```

### Phantom Venusaur will never be obtained through Card Pop!

([Video](https://youtu.be/vr8MZwW6gpI?si=qZuMBGRSrMyoGVJj&t=60))

The routine used by Card Pop! to generate what card the player will receive is flawed, preventing one from ever receiving the Venusaur Phantom Card.

**Fix:** TODO

## Graphics

### Water Club master room uses the wrong void color

The bottom of Amy's room uses the incorrect void color, causing parts of it to appear black instead of dark blue.

**Fix:** Edit [water_club.bin](https://github.com/pret/poketcg/blob/master/src/data/maps/tiles/cgb/water_club.bin):
- Open the file with [Tilemap Studio](https://github.com/Rangi42/tilemap-studio).
- Select the `GBC tiles + attributes` option, and set the map to have a width of `28`.
- In `Tileset`, use `Add` on the [waterclub.png](https://github.com/pret/poketcg/blob/master/src/gfx/tilesets/waterclub.png) tileset, then enter `080` in the "Start at ID" field.
- Lastly, go to the `Palettes` tab, and replace the instances of palette `0` with palette `1`.

### Club entrances use incorrect medal emblem tiling
Each club entrance features a medal emblem, though all but the Fighting Club use incorrect/inconsistent tiling when compared to the actual medals the player can obtain. Despite this, all the required tiles exist, though a handful [ends up unused](https://tcrf.net/Pokémon_Trading_Card_Game/Unused_Graphics#Tileset_03).

![image](https://raw.githubusercontent.com/pret/poketcg/master/src/gfx/medals.png)

**Fix:** Edit the [XXX_club_entrance.bin](https://github.com/pret/poketcg/blob/master/src/data/maps/tiles/cgb) files with Tilemap Studio, using this chart as a guide for which emblem graphics to replace:
```diff
Lightning Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:CB, $0:CC, $0:9F
	$0:AC, $0:CE, $0:CF, $0:AF
-	$0:BC, $0:C9, $0:CA, $0:BF
+	$0:BC, $0:B9, $0:CA, $0:BF

Rock Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:D6, $0:D7, $0:9F
	$0:AC, $0:D8, $0:D9, $0:AF
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:B9, $0:DA, $0:BF

Psychic Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:DB, $0:DC, $0:9F
	$0:AC, $0:DD, $0:DE, $0:DF
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:C9, $0:CA, $0:BF

Fire Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:C5, $0:C6, $0:9F
	$0:AC, $0:C7, $0:C8, $0:C3
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:C9, $0:CA, $0:BF

Science Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:BB, $0:C0, $0:9F
	$0:AC, $0:C1, $0:C2, $0:C3
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:BD, $0:C4, $0:BF

Grass Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:A6, $0:A7, $0:9F
-	$0:AC, $0:B6, $0:B7, $0:AF
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:AC, $0:B6, $0:B7, $0:B8
+	$0:BC, $0:B9, $0:BA, $0:BF

Water Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:D0, $0:D1, $0:D2
	$0:AC, $0:D3, $0:D4, $0:D5
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:C9, $0:CA, $0:BF
```

### Green NPCs have incorrect frame data

Characters that are assigned the green NPC palette have incorrect profile frame data. Talking to the from either the left or right will not draw the correct tiles for the upper corner of their head.

**Fix:** Edit `AnimFrameTable7` in [src/data/duel/animations/anims1.asm](https://github.com/pret/poketcg/blob/master/src/data/duel/animations/anims1.asm):
```diff
.data_a9459
	db 4 ; size
-	db 0, 0, 6, %011 | (1 << OAM_OBP_NUM)
+	db 0, 0, 12, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 13, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 14, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 15, %011 | (1 << OAM_OBP_NUM)

.data_a946a
	db 4 ; size
-	db 0, 0, 8, %011 | (1 << OAM_OBP_NUM)
+	db 0, 0, 16, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 17, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 18, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 19, %011 | (1 << OAM_OBP_NUM)

...


.data_a94ae
	db 4 ; size
	db 0, 0, 13, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 15, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
-	db 0, 8, 6, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
+	db 0, 8, 12, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 14, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a94bf
	db 4 ; size
	db 0, 0, 17, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 19, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
-	db 0, 8, 8, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
+	db 0, 8, 16, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 18, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
```

### Big Lightning animation has incorrect frame data

One of the bolts from the "big lightning" duel animation has its topmost row of tiles accidentally shifted one tile to the left.

**Fix:** Edit `AnimFrameTable29` in [data/duel/animations/anims1.asm](https://github.com/pret/poketcg/blob/master/src/data/duel/animations/anims1.asm):
```diff
.data_ab5fd
	db 28 ; size
-	db -72, -8, 0, (1 << OAM_X_FLIP)
+	db -72, 0, 0, (1 << OAM_X_FLIP)
	db -16, 32, 27, $0
	...
	db -56, 10, 42, $0
```

The base of the lightning being cut-off is addressed below, though that specific fix will cause a byte overflow, forcing one to rearrange `anim1.asm`.

```diff
.data_ab5fd
-	db 28 ; size
-	db -72, -8, 0, (1 << OAM_X_FLIP)
+	db 29 ; size
+	db -72, 0, 0, (1 << OAM_X_FLIP)
+	db -72, -8, 1, (1 << OAM_X_FLIP)
	db -16, 32, 27, $0
	...
	db -56, 10, 42, $0
```

### Dive Bomb animation has incorrect frame data

The fire blasts from Dive Bomb's duel animation mistakenly reuse the same tile twice, causing one tile to go unused, and the animation itself to look less refined.

**Fix:** Edit `AnimFrameTable32` in [data/duel/animations/anims2.asm](https://github.com/pret/poketcg/blob/master/src/data/duel/animations/anims2.asm):
```diff
.data_ac685
	db 19 ; size
	...
	db -8, 8, 11, (1 << OAM_X_FLIP)
	db -8, 16, 10, (1 << OAM_X_FLIP)
-	db 0, 24, 10, (1 << OAM_X_FLIP)
+	db 0, 24, 12, (1 << OAM_X_FLIP)
	db 0, 16, 13, (1 << OAM_X_FLIP)
	db 0, 8, 14, (1 << OAM_X_FLIP)
	db 8, 8, 17, (1 << OAM_X_FLIP)
	db 8, 16, 16, (1 << OAM_X_FLIP)
	db 8, 24, 15, (1 << OAM_X_FLIP)
	db 16, 24, 18, (1 << OAM_X_FLIP)

.data_ac6d2
	db 19 ; size
	...
	db -8, -16, 11, $0
	db -8, -24, 10, $0
-	db 0, -32, 10, $0
+	db 0, -32, 12, $0
	db 0, -24, 13, $0
	db 0, -16, 14, $0
	db 8, -16, 17, $0
	db 8, -24, 16, $0
	db 8, -32, 15, $0
	db 16, -32, 18, $0

.data_ac71f
	db 29 ; size
	...
	db -8, 8, 11, (1 << OAM_X_FLIP)
	db -8, 16, 10, (1 << OAM_X_FLIP)
-	db 0, 24, 10, (1 << OAM_X_FLIP)
+	db 0, 24, 12, (1 << OAM_X_FLIP)
	db 0, 16, 13, (1 << OAM_X_FLIP)
	db 0, 8, 14, (1 << OAM_X_FLIP)
	db 8, 8, 17, (1 << OAM_X_FLIP)
	db 8, 16, 16, (1 << OAM_X_FLIP)
	db 8, 24, 15, (1 << OAM_X_FLIP)
	db 16, 24, 18, (1 << OAM_X_FLIP)
```

The flames of one of the blasts being cut-off is addressed below, though that specific fix will cause a byte overflow, forcing one to rearrange `anim2.asm`.

```diff
.data_ac685
-	db 19 ; size
+	db 20 ; size
	...
	db -8, 8, 11, (1 << OAM_X_FLIP)
	db -8, 16, 10, (1 << OAM_X_FLIP)
-	db 0, 24, 10, (1 << OAM_X_FLIP)
+	db 0, 24, 12, (1 << OAM_X_FLIP)
	db 0, 16, 13, (1 << OAM_X_FLIP)
	db 0, 8, 14, (1 << OAM_X_FLIP)
	db 8, 8, 17, (1 << OAM_X_FLIP)
	db 8, 16, 16, (1 << OAM_X_FLIP)
	db 8, 24, 15, (1 << OAM_X_FLIP)
+	db 16, 16, 19, (1 << OAM_X_FLIP)
	db 16, 24, 18, (1 << OAM_X_FLIP)

.data_ac6d2
-	db 19 ; size
+	db 20 ; size
	...
	db -8, -16, 11, $0
	db -8, -24, 10, $0
-	db 0, -32, 10, $0
+	db 0, -32, 12, $0
	db 0, -24, 13, $0
	db 0, -16, 14, $0
	db 8, -16, 17, $0
	db 8, -24, 16, $0
	db 8, -32, 15, $0
+	db 16, -24, 19, $0
	db 16, -32, 18, $0

.data_ac71f
	db 29 ; size
	...
	db -8, 8, 11, (1 << OAM_X_FLIP)
	db -8, 16, 10, (1 << OAM_X_FLIP)
-	db 0, 24, 10, (1 << OAM_X_FLIP)
+	db 0, 24, 12, (1 << OAM_X_FLIP)
	db 0, 16, 13, (1 << OAM_X_FLIP)
	db 0, 8, 14, (1 << OAM_X_FLIP)
	db 8, 8, 17, (1 << OAM_X_FLIP)
	db 8, 16, 16, (1 << OAM_X_FLIP)
	db 8, 24, 15, (1 << OAM_X_FLIP)
	db 16, 24, 18, (1 << OAM_X_FLIP)
```

## Text

### Challenge host uses wrong name for the first rival

([Video](https://www.youtube.com/watch?v=1igDbNxRfUw&t=17310s))

When playing the challenge cup, player name is used instead of rival name before the first fight.

**Fix:** Edit `Clerk12ChallengeCupContenderText` in [src/text/text6.asm](https://github.com/pret/poketcg/blob/master/src/text/text6.asm):
```diff
-	text "Presently, <RAMNAME> is still"
+	text "Presently, <RAMTEXT> is still"
```

### Both Ninetales cards misspell its name
The name string used for both NinetalesLv32 and NinetalesLv35 misspells the Pokémon's name as "Ninetails".

**Fix:** Edit `NinetalesName` in [src/text/text10.asm](https://github.com/pret/poketcg/blob/master/src/text/text10.asm):
```diff
NinetalesName:
-	text "Ninetails"
+	text "Ninetales"
	done
```
