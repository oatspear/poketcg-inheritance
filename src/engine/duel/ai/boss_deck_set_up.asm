; sets up the initial hand of boss deck.
; always draws at least 2 Basic Pokemon cards and 2 Energy cards.
; also sets up so that the next cards to be drawn have
; some minimum number of Basic Pokemon and Energy cards.
SetUpBossStartingHandAndDeck:
; shuffle all hand cards in deck
	ld a, DUELVARS_HAND
	call GetTurnDuelistVariable
	ld b, STARTING_HAND_SIZE
.loop_hand
	ld a, [hl]
	call RemoveCardFromHand
	call ReturnCardToDeck
	dec b
	jr nz, .loop_hand
	; fallthrough

.ensure_active
	ld a, [wAICardListArenaPriority + 1]
	or a
	jr z, .ensure_basic  ; null
	ld h, a
	ld a, [wAICardListArenaPriority]
	ld l, a

	ld b, 6  ; 70% chance of going with the first entry
.loop_active_priority
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	or d
	jr z, .ensure_basic  ; reached end of list
; increment chance for the next entry
	inc b
	ld a, 10
	call Random
	cp b
	jr nc, .loop_active_priority
; found card ID to ensure as active
	ld a, CARD_LOCATION_DECK
	call LookForCardIDInLocation_Bank5
	jr nc, .ensure_basic  ; not found in deck
; add card to hand
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	jr .ensure_energy

.ensure_basic
	ld a, DUELVARS_DECK_CARDS + DECK_SIZE - 1  ; last card
	call GetTurnDuelistVariable
	ld b, DECK_SIZE
.loop_deck_1
	ld a, [hld]
	push bc
	call LoadCardDataToBuffer1_FromDeckIndex
	pop bc
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr c, .pokemon_card
.next_card_deck_1
	dec b
	jr nz, .loop_deck_1
	ret  ; failure

.pokemon_card
	ld a, [wLoadedCard1Stage]
	or a  ; cp BASIC
	jr nz, .next_card_deck_1 ; not basic
; found a Basic Pokémon
	inc hl
	ld a, [hl]
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	; fallthrough

.ensure_energy
	ld a, DUELVARS_DECK_CARDS + DECK_SIZE - 1  ; last card
	call GetTurnDuelistVariable
	ld b, DECK_SIZE - 1
.loop_deck_2
	ld a, [hld]
	push bc
	call LoadCardDataToBuffer1_FromDeckIndex
	pop bc
	ld a, [wLoadedCard1Type]
	and TYPE_ENERGY
	jr nz, .energy_card
.next_card_deck_2
	dec b
	jr nz, .loop_deck_2
	ret  ; failure

.energy_card
	inc hl
	ld a, [hl]
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	; fallthrough

; draw new set of hand cards (from the bottom of deck to optimize search function)
	ld l, DUELVARS_DECK_CARDS + DECK_SIZE - 1  ; last card
	ld b, STARTING_HAND_SIZE - 2
.draw_loop
	ld a, [hl]
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	dec b
	jr nz, .draw_loop

; point to top of deck again
	ld a, DECK_SIZE
	ld l, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	sub [hl]
	ld a, DUELVARS_DECK_CARDS
	add [hl]
	ld l, a ; hl = DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
	jr .avoid_prize_check

.shuffle_deck
	call ShuffleDeck

; now check the following 6 cards (prize cards).
; re-shuffle deck if any of these cards is listed in wAICardListAvoidPrize.
.avoid_prize_check
	ld b, 6
.check_card_ids
	ld a, [hli]
	push bc
	call .CheckIfIDIsInList
	pop bc
	jr c, .shuffle_deck
	dec b
	jr nz, .check_card_ids
	ret

; return carry if card ID corresponding
; to the input deck index is listed in wAICardListAvoidPrize;
; input:
;	- a = deck index of card to check
.CheckIfIDIsInList
	ld b, a
	ld a, [wAICardListAvoidPrize + 1]
	or a
	ret z ; null
	push hl
	ld h, a
	ld a, [wAICardListAvoidPrize]
	ld l, a
	ld a, b
	call GetCardIDFromDeckIndex
.loop_id_list
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	or c
	jr z, .false
	call CompareDEtoBC
	jr nz, .loop_id_list
	pop hl
	scf
	ret

.false
	pop hl
	or a
	ret
