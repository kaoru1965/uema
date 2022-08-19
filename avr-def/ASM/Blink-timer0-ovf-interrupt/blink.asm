.include "tn85def.inc"

.def temp = R16
.def const1 = R1
.def LED = R2
.def flag = R3
.equ f1ms=1<<0
.macro outp
	ldi temp, @1
	out @0, temp
.endmacro
.macro ldix
	ldi temp, @1
	mov @0, temp
.endmacro
.macro andix
	ldi temp, @1
	and @0, temp
.endmacro
.macro orix
	ldi temp, @1
	or @0, temp
.endmacro
.macro eorix
	ldi temp, @1
	eor @0, temp
.endmacro
.macro cpix
	ldi temp, @1
	cp @0, temp
.endmacro
.macro cpi16x        ; usage: cpi16x registerH, registerL, 1000
	ldi temp, LOW( @2 )
	cp @1, temp
	ldi temp, HIGH( @2 )
	cpc @0, temp
.endmacro
.macro inccounter1000
	adiw R26, 1    ; inc R27:R26
.endmacro

.ORG 0
rjmp RESET              ;各種リセット
rjmp INT0_ISR           ;外部割り込み要求0
rjmp PCINT0_ISR         ;ピン変化割り込み要求
rjmp TIM1_COMPA_ISR     ;タイマ/カウンタ1比較A一致
rjmp TIM1_OVF_ISR       ;タイマ/カウンタ1溢れ
rjmp TIM0_OVF_ISR       ;タイマ/カウンタ0溢れ
rjmp EE_RDY_ISR         ;EEPROM操作可
rjmp ANA_COMP_ISR       ;アナログ比較器出力遷移
rjmp ADC_ISR            ;A/D変換完了
rjmp TIM1_COMPB_ISR     ;タイマ/カウンタ1比較B一致
rjmp TIM0_COMPA_ISR     ;タマi/カウンタ0比較A一致
rjmp TIM0_COMPB_ISR     ;タイiマ/カウンタ0比較B一致
rjmp WDT_OVF_ISR        ;ウォッチドッグ計時完了
rjmp USI_START_ISR      ;USI開始条件検出
rjmp USI_OVF_ISR        ;USI計数器溢れ
;;;

RESET:             ;各種リセット
	outp SPH, HIGH( RAMEND )
	outp SPL, LOW( RAMEND )
	ldi temp, 0xff
	out DDRB, temp
	outp TCCR0B, 0b011<<CS00   ; ck/64
	outp TIMSK, 1<<TOIE0
	outp TCNT0, 8000000/64/1000-1
	ldix const1, 1
	sei
MAIN:                ;;; 1[ms] wait
	cpix flag, f1ms  ;;; 1[ms] wait
	brne MAIN        ;;; 1[ms] wait
	andix flag, ~f1ms       ;;; flag reset
	inccounter1000         ;;; R27:R26 increment
	cpi16x R27, R26, 1000  ;;; 1000[ms] check?
	brne MAIN9             ;;; if not 1000[ms] goto MAIN9
	clr R27            ;;; if 1000[ms]  clear R27
	clr R26            ;;; if 1000[ms]  clear R26
	eorix LED, 1<<PB0  ;;; if 1000[ms]  LED toggle
	out PORTB, LED     ;;; if 1000[ms]  LED toggle
MAIN9:
	rjmp MAIN



INT0_ISR: reti          ;外部割り込み要求0
PCINT0_ISR: reti        ;ピン変化割り込み要求
TIM1_COMPA_ISR: reti    ;タイマ/カウンタ1比較A一致
TIM1_OVF_ISR: reti      ;タイマ/カウンタ1溢れ
TIM0_OVF_ISR:           ;タイマ/カウンタ0溢れ
	outp TCNT0, 8000000/64/1000-1
	orix flag, f1ms
	reti

EE_RDY_ISR: reti        ;EEPROM操作可
ANA_COMP_ISR: reti      ;アナログ比較器出力遷移
ADC_ISR: reti           ;A/D変換完了
TIM1_COMPB_ISR: reti    ;タイマ/カウンタ1比較B一致
TIM0_COMPA_ISR: reti    ;タマi/カウンタ0比較A一致
TIM0_COMPB_ISR: reti    ;タイiマ/カウンタ0比較B一致
WDT_OVF_ISR: reti       ;ウォッチドッグ計時完了
USI_START_ISR: reti     ;USI開始条件検出
USI_OVF_ISR: reti       ;USI計数器溢れ
