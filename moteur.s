	;; RK - Evalbot (Cortex M3 de Texas Instrument)
; programme - Pilotage 2 Moteurs Evalbot par PWM tout en ASM (Evalbot tourne sur lui m?me)



		AREA    |.text|, CODE, READONLY
		ENTRY
		EXPORT	__main
		
		;; The IMPORT command specifies that a symbol is defined in a shared object at runtime.
		IMPORT	MOTEUR_INIT					; initialise les moteurs (configure les pwms + GPIO)
		
		IMPORT	MOTEUR_DROIT_ON				; activer le moteur droit
		IMPORT  MOTEUR_DROIT_OFF			; d?activer le moteur droit
		IMPORT  MOTEUR_DROIT_AVANT			; moteur droit tourne vers l'avant
		IMPORT  MOTEUR_DROIT_ARRIERE		; moteur droit tourne vers l'arri?re
		IMPORT  MOTEUR_DROIT_INVERSE		; inverse le sens de rotation du moteur droit
		
		IMPORT	MOTEUR_GAUCHE_ON			; activer le moteur gauche
		IMPORT  MOTEUR_GAUCHE_OFF			; d?activer le moteur gauche
		IMPORT  MOTEUR_GAUCHE_AVANT			; moteur gauche tourne vers l'avant
		IMPORT  MOTEUR_GAUCHE_ARRIERE		; moteur gauche tourne vers l'arri?re
		IMPORT  MOTEUR_GAUCHE_INVERSE		; inverse le sens de rotation du moteur gauche
		
		; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

; The GPIODATA register is the data register
GPIO_PORTF_BASE		EQU		0x40025000	; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de lm3s9B92.pdf)

; The GPIODATA register is the data register
GPIO_PORTD_BASE		EQU		0x40007000		; GPIO Port D (APB) base: 0x4000.7000 (p416 datasheet de lm3s9B92.pdf)

; The GPIODATA register is the data register
GPIO_PORTE_BASE		EQU		0x40024000		; GPIO Port E (APB) base: 0x4002.4000 (p416 datasheet de lm3s9B92.pdf)



; configure the corresponding pin to be an output
; all GPIO pins are inputs by default
GPIO_O_DIR   		EQU 	0x00000400  ; GPIO Direction (p417 datasheet de lm3s9B92.pdf)

; The GPIODR2R register is the 2-mA drive control register
; By default, all GPIO pins have 2-mA drive.
GPIO_O_DR2R   		EQU 	0x00000500  ; GPIO 2-mA Drive Select (p428 datasheet de lm3s9B92.pdf)

; Digital enable register
; To use the pin as a digital input or output, the corresponding GPIODEN bit must be set.
GPIO_O_DEN  		EQU 	0x0000051C  ; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

; Pull_up
GPIO_I_PUR   		EQU 	0x00000510  ; GPIO Pull-Up (p432 datasheet de lm3s9B92.pdf)

; Broches select
BROCHE4_5			EQU		0x30		; led1 & led2 sur broche 4 et 5 

BROCHE4				EQU		0x20		; led1 & led2 sur broche 4 et 5 
	
BROCHE5				EQU		0x10		; led1 & led2 sur broche 4 et 5 

BROCHE6				EQU 	0x40		; bouton poussoir 1

BROCHE6_7			EQU 	0xC0		; bouton poussoir 1

BROCHE0_1			EQU		0x03

	
VITESSE   			EQU     0x1B2
VITESSE2   			EQU     0x100
VITESSE3   			EQU     0x050

; blinking frequency
DUREE   			EQU     0x001A0000
DUREE2  			EQU     0x00050000
DUREE3   			EQU     0x00030000

DUREE90				EQU		0xAFFFFFF

PWM_BASE		EQU		0x040028000 	   ;BASE des Block PWM p.1138
PWM0CMPA		EQU		PWM_BASE+0x058


__main	
		
		
		; ;; Enable the Port F & D peripheral clock 		(p291 datasheet de lm3s9B96.pdf)
		; ;;									
		ldr r9, = SYSCTL_PERIPH_GPIO  			;; RCGC2
        mov r4, #0x00000038  					;; Enable clock sur GPIO D et F o? sont branch?s les leds (0x28 == 0b101000)
		; ;;														 									      (GPIO::FEDCBA)
        str r4, [r9]
                                                ;; Enable clock sur GPIO E o? est branch? le bouton poussoir (0x10 == 0b10000)
                                                ;; (GPIO::FEDCBA)

		; ;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
		nop	   									;; tres tres important....
		nop	   
		nop	   									;; pas necessaire en simu ou en debbug step by step...
	
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION LED

        ldr r9, = GPIO_PORTF_BASE+GPIO_O_DIR    ;; 1 Pin du portF en sortie (broche 4 : 00010000)
        ldr r4, = BROCHE4_5 	; 0x30 = 0b 0011 0000 
        str r4, [r9]
		
		ldr r9, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r4, = BROCHE4_5		
        str r4, [r9]
		
		ldr r9, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensit? de sortie (2mA)
        ldr r4, = BROCHE4_5			
        str r4, [r9]
		
		
		
		mov r2, #0x000       					;; pour eteindre LED
     
		; allumer la led broche 4 (BROCHE4_5)
		mov r3, #BROCHE4_5		;; Allume LED1&2 portF broche 4&5 : 00110000		
				
		
		ldr r9, = GPIO_PORTF_BASE + (BROCHE4_5<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
			 
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration LED 

		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION Switcher 1
		
		ldr r7, = GPIO_PORTD_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r4, = BROCHE6_7	
        str r4, [r7]  

		ldr r7, = GPIO_PORTD_BASE+GPIO_I_PUR	;; Pull_up
        ldr r4, = BROCHE6_7		
        str r4, [r7]

		ldr r7, = GPIO_PORTD_BASE + (BROCHE6_7<<2)  ;; @data Register = @base + (mask<<2) ==> Switcher
		
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration Switcher 
		
		
			
		
				;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION Bumper 1
		
		ldr r8, = GPIO_PORTE_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r4, = BROCHE0_1	
        str r4, [r8]  

		ldr r8, = GPIO_PORTE_BASE+GPIO_I_PUR	;; Pull_up
        ldr r4, = BROCHE0_1		
        str r4, [r8]

		ldr r8, = GPIO_PORTE_BASE + (BROCHE0_1<<2)  ;; @data Register = @base + (mask<<2) ==> Switcher
		
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration Switcher 
		



		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CLIGNOTTEMENT

		str r3, [r9]  							;; Allume LED1&2 portF broche 4&5 : 00110000 (contenu de r3)

;--------------------------------------------------------------------------------------------------------------------
		;; BL Branchement vers un lien (sous programme)
		mov r5, #1
		ldr r13, =VITESSE
		BL	MOTEUR_INIT	   		   
		
		; Activer les deux moteurs droit et gauche
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON

		; Boucle de pilotage des 2 Moteurs (Evalbot tourne sur lui m?me)
loop	
		BL conditions
		; Evalbot avance droit devant
		;BL	WAIT	; BL (Branchement vers le lien WAIT); possibilit? de retour ? la suite avec (BX LR)
		B loop
		
;;;;;;;;;;;;;;;;;		DIRECTIONS		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
gauche
		BL MOTEUR_GAUCHE_ARRIERE
		BL MOTEUR_DROIT_AVANT
		mov r11, #BROCHE4 ; POUR LES LED 
		BL WAIT ; ROTATION
		B loop
		
droite
		BL MOTEUR_DROIT_ARRIERE
		BL MOTEUR_GAUCHE_AVANT
		mov r11, #BROCHE5
		BL WAIT
		B loop
		
avance
		str r3, [r9]
		BL MOTEUR_GAUCHE_AVANT
		BL MOTEUR_DROIT_AVANT
		B loop
;;;;;;;;;;;;;;;;;		VITESSE			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
speed
		mov r5, #1
		ldr r13, =VITESSE
		B resetspeed

speed2
		mov r5, #2
		ldr r13, =VITESSE2
		B resetspeed

speed3
		mov r5, #3
		ldr r13, =VITESSE3
		B resetspeed


resetspeed
		BL MOTEUR_INIT
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON
		BL MOTEUR_GAUCHE_AVANT
		BL MOTEUR_DROIT_AVANT
		
		NOP
		NOP
		NOP
		B conditions

vitesse
		CMP R5, #1  
		BEQ speed2
		CMP R5, #2  
		BEQ speed3
		CMP R5, #3  
		BEQ speed

		
		BNE gameover
;;;;;;;;;;;;;		DUR??E DE ROTATION = 3 fois (DUREE LED_ON + DUREE LED_ON)	;;;;;;;;;;
; DUREE TOTAL = 6* DUREE

; Mes delays en fonction de la vitesse il adapte la dur??e de rotation de rotation
delay1
		CMP R5, #1  
		MOVEQ r1, #DUREE
		CMP R5, #2  
		MOVEQ r1, #DUREE2
		CMP R5, #3  
		MOVEQ r1, #DUREE3
		B led_off
		
delay2
		CMP R5, #1  
		MOVEQ r1, #DUREE
		CMP R5, #2  
		MOVEQ r1, #DUREE2
		CMP R5, #3  
		MOVEQ r1, #DUREE3
		B led_on
		
;;;;;;;;;;;;;		CONDITIONS		;;;;;;;;;;;;;


conditions
		ldr r10,[r7]
		CMP r10,#0x00 ; switch // CHANGEMENT DE VITESSE
        BEQ vitesse
		
		ldr r10,[r8]
		CMP r10,#0x01 ; collision gauche // BUMPER GAUCHE
        BEQ gauche
		
		ldr r10,[r8]
		CMP r10,#0x02 ; collision droite // BUMPER DROITE
        BEQ droite
		
		ldr r10,[r8]
		CMP r10,#0x03 ; pas de collision
        BEQ avance
		BX	LR

;; Boucle d'attante		
WAIT	MOV R12	,#3
		
		
clignotte
        str r2, [r9]    						;; Eteint LED car r2 = 0x00      
        B delay1						;; pour la duree de la boucle d'attente1 (wait1)

led_off	ldr r10,[r8]  
		CMP r10,#0x00 ; les deux 
        BEQ gameover
		subs r1, #1
        bne led_off

        str r11, [r9]  							;; Allume LED1&2 portF broche 4&5 : 00110000 (contenu de r3)
        B delay2						;; pour la duree de la boucle d'attente2 (wait2)

led_on	ldr r10,[r8]  
		CMP r10,#0x00 ; les deux 
        BEQ gameover
		subs r1, #1
		bne led_on
		
		SUBS R12, R12, #1 
		BNE clignotte
        BX LR  ; pour WAIT
		
gameover BL MOTEUR_GAUCHE_OFF
		 BL MOTEUR_DROIT_OFF
		 mov r11, #BROCHE4_5
		 BL WAIT
		 str r2, [r9]
		 NOP
         END

			

			

		