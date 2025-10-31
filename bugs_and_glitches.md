# Bugs and Glitches

These are documented bugs and glitches in the original Pokémon Trading Card Game.

Fixes are written in the `diff` format.

```diff
 this is some code
-delete red - lines
+add green + lines
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
