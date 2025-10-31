# Bugs and Glitches

These are documented bugs and glitches in the original Pokémon Trading Card Game.

Fixes are written in the `diff` format.

```diff
 this is some code
-delete red - lines
+add green + lines
```

## Graphics

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
