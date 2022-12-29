BattleCommand_Curse:
; curse

	ld de, wBattleMonType1
	ld bc, wPlayerStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .go
	ld de, wEnemyMonType1
	ld bc, wEnemyStatLevels

.go

; If no stats can be increased, don't.

; Defense
    ; bc (wPlayerStatLevels) starts with Attack
    inc bc ; changes to Defense
	ld a, [bc]
	cp MAX_STAT_LEVEL
	jr c, .raise

; Sp. Defense
	inc bc ; changes to Speed
	inc bc ; changes to Sp. Atk
	inc bc ; changes to Sp. Def
	ld a, [bc]
	cp MAX_STAT_LEVEL
	jr nc, .cantraise

.raise

; Lower Attack, Sp.Atk, and Speed. Raise Defense x2 and Sp. Def x2.

	ld a, $1
	ld [wKickCounter], a
	call AnimateCurrentMove
	ld a, ATTACK
	call LowerStat
	call BattleCommand_SwitchTurn
	call BattleCommand_StatDownMessage
	call ResetMiss
	call BattleCommand_SwitchTurn
    ld a, SP_ATTACK
	call LowerStat
	call BattleCommand_SwitchTurn
	call BattleCommand_StatDownMessage
	call ResetMiss
	call BattleCommand_SwitchTurn
    ld a, SPEED
	call LowerStat
	call BattleCommand_SwitchTurn
	call BattleCommand_StatDownMessage
	call ResetMiss
	call BattleCommand_SwitchTurn
	call BattleCommand_DefenseUp2
	call BattleCommand_StatUpMessage
	call ResetMiss
	call BattleCommand_SpecialDefenseUp2
	jp BattleCommand_StatUpMessage

.failed
	call AnimateFailedMove
	jp PrintButItFailed

.cantraise

; Can't raise any stat.

	ld b, ABILITY + 1
	call GetStatName
	call AnimateFailedMove
	ld hl, WontRiseAnymoreText
	jp StdBattleTextbox
