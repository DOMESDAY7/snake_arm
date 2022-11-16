	;; RK - Evalbot (Cortex M3 de Texas Instrument)
; programme - Pilotage 2 Moteurs Evalbot par PWM tout en ASM (Evalbot tourne sur lui même)



		AREA    |.text|, CODE, READONLY
		ENTRY
		EXPORT _ main

__main
; INIT des gpios
; # et inititalisation du LCD
	bl LCD_gpio_init # init des gpio pour piloter le LCD
	bl LCD_init s le cursseur est au debut de la premiere ligne

	bl cursoff

		BL RSdr
		LDR R2, =m1
loop 	LDR Ri, [R2]
		CMP Ri, #0x00
		BEQ floop
		BL WriteLcD
		add x2, #1
		b loop

floop 	BL RSir ; on choisit le registre d'instructions de LCD
		LDR x1, =0xCO ; pour placer le curseur au debut de la 2ieme R1 = ?????
		BL WriteLCD ; on envoit cette donnée vers le LCD
		MOV rl, #DSOus ; il faut attendre >38us
		BL wait
		BL RSdr
		LDR R2, =m2
loop1	LDR Ri, [R2]
		CMP Ri, #0x00
		BEQ floop1
		BL WriteLcD
		add r2, #1
		b loop1

floop1



		AREA CONST, DATA,
m1		dcb "Bonjour !",0
m2		dcb "& tous

		AREA CONST, DATA, READWRITE
ms1		space 10
ms2		space 4