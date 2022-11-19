

 
		         

SYSCTL         equ   0x400FE000  ; System Control base address
SYSCTL_RCGC2   equ   0x400FE108  ; Run Mode Clock Gating Control Register 2   p292
                                 ; pour enable clock des GPIOs
RCGC1          equ   0x104
RCGC2          equ   0x108

SRCR1          equ   0x44     ; Software Reset Control 1 p303
SRCR2          equ   0x44     ; Software Reset Control 2 p306


SYSCTL_PERIPH	EQU	0x400FE108	; SYSCTL_RCGC2_R : pour enable clock (p291 datasheet de lm3s9b92.pdf)
							         	; voir chap.8 "GPIO": page 416 de lm3s9B92.pdf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GPIO Register MAP page 413-414 du lm3s9b92.pdf
; les adresses :
;
GPIO_PORTA_BASE   EQU	0x40004000  
GPIO_PORTB_BASE   EQU	0x40005000
GPIO_PORTC_BASE   EQU	0x40006000
GPIO_PORTD_BASE   EQU	0x40007000	; GPIO Port D (APB) base: 0x4000.7000 (p416 datasheet de lm3s9B92.pdf)
GPIO_PORTE_BASE   EQU	0x40024000
GPIO_PORTF_BASE	EQU	0x40025000	; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de lm3s9B92.pdf)
GPIO_PORTG_BASE   EQU	0x40026000
GPIO_PORTH_BASE   EQU   0x40027000
GPIO_PORTJ_BASE	EQU	0x4003D000  ; GPIO Port J (APB) base: 0x4003.D000

GPIODATA    equ   0x000 ; GPIO Data       p416
GPIODIR     equ   0x400 ; GPIO Direction  p417 

GPIOIS      equ   0x404 ; GPIO Interrupt Sense        p418
GPIOIBE     equ   0x408 ; GPIO Interrupt Both Edges   p419
GPIOIEV     equ   0x40C ; GPIO Interrupt Event        p420

GPIOIM      equ 0x410   ; R/W 0x0000.0000 GPIO Interrupt Mask           p421
GPIORIS     equ 0x414   ; RO  0x0000.0000 GPIO Raw Interrupt Status     p422
GPIOMIS     equ 0x418   ; RO  0x0000.0000 GPIO Masked Interrupt Status  p423
GPIOICR     equ 0x41C   ; W1C 0x0000.0000 GPIO Interrupt Clear          p425

GPIOAFSEL   equ 0x420   ; R/W - GPIO Alternate Function Select          p426

GPIODR2R    equ 0x500   ; R/W 0x0000.00FF GPIO 2-mA Drive Select        p428
GPIODR4R    equ 0x504   ; R/W 0x0000.0000 GPIO 4-mA Drive Select        p429
GPIODR8R    equ 0x508   ; R/W 0x0000.0000 GPIO 8-mA Drive Select        p430

GPIOODR     equ 0x50C   ; R/W 0x0000.0000 GPIO Open Drain Select        p431
GPIOPUR     equ 0x510   ; R/W - GPIO Pull-Up Select                     p432
GPIOPDR     equ 0x514   ; R/W 0x0000.0000 GPIO Pull-Down Select         p434
GPIOSLR     equ 0x518   ; R/W 0x0000.0000 GPIO Slew Rate Control Select p436

GPIODEN     equ 0x51C   ; R/W - GPIO Digital Enable                     p437

GPIOLOCK    equ 0x520   ; R/W 0x0000.0001 GPIO Lock                     p439
GPIOCR      equ 0x524   ; - - GPIO Commit                               p440
GPIOAMSEL   equ 0x528   ; R/W 0x0000.0000 GPIO Analog Mode Select       p442
GPIOPCTL    equ 0x52C   ; R/W - GPIO Port Control                       p444

GPIOPeriphID4 equ  0xFD0  ; RO 0x0000.0000 GPIO Peripheral Identification 4 p446
GPIOPeriphID5 equ  0xFD4  ; RO 0x0000.0000 GPIO Peripheral Identification 5 p447
GPIOPeriphID6 equ  0xFD8  ; RO 0x0000.0000 GPIO Peripheral Identification 6 p448
GPIOPeriphID7 equ  0xFDC  ; RO 0x0000.0000 GPIO Peripheral Identification 7 p449
GPIOPeriphID0 equ  0xFE0  ; RO 0x0000.0061 GPIO Peripheral Identification 0 p450
GPIOPeriphID1 equ  0xFE4  ; RO 0x0000.0000 GPIO Peripheral Identification 1 p451
GPIOPeriphID2 equ  0xFE8  ; RO 0x0000.0018 GPIO Peripheral Identification 2 p452
GPIOPeriphID3 equ  0xFEC  ; RO 0x0000.0001 GPIO Peripheral Identification 3 p453

GPIOPCellID0 equ  0xFF0   ; RO 0x0000.000D GPIO PrimeCell Identification 0 p454
GPIOPCellID1 equ  0xFF4   ; RO 0x0000.00F0 GPIO PrimeCell Identification 1 p455
GPIOPCellID2 equ  0xFF8   ; RO 0x0000.0005 GPIO PrimeCell Identification 2 p456
GPIOPCellID3 equ  0xFFC   ; RO 0x0000.00B1 GPIO PrimeCell Identification 3 p457

PORT0	   EQU	0x01	;  
PORT1 	EQU	0x02	;
PORT2	   EQU	0x04	;
PORT3  	EQU	0x08	;
PORT4 	EQU	0x10	;
PORT5 	EQU	0x20	;
PORT6    EQU	0x40	;
PORT7	   EQU	0x80  ;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; les constantes de durée 
; calculés apres mesure sur l'oscillo
;
D1s      equ   0x002FFFFF  ; en réalité 1.2s	
D5ms     equ   26600
D2ms     equ   10640
D150us   equ   (800*50)
D75us    equ   (400*50)
D50us    equ   (266*100)
D15us    equ   (80*100)
D10us    equ   (53*100)
D500ns   equ   (3*100)           ; en réalité 563ns
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NVIC Register MAP pages 136-149 du lm3s9b92.pdf
;

NVIC_BASE   equ   0xe000e000  ; adresse de base du NVIC

EN0         equ   0x100    ; Interrupt 0-31 Set Enable   p137
EN1         equ   0x104    ; Interrupt 32-54 Set Enable  p138

DIS0        equ   0x180    ; Interrupt 0-31 Clear Enable   p139
DIS1        equ   0x184    ; Interrupt 32-54 Clear Enable  p140

PEND0       equ   0x200    ; Interrupt 0-31 Set Pending   p141
PEND1       equ   0x204    ; Interrupt 32-54 Set Pending  p142

UNPEND0     equ   0x280    ; Interrupt 0-31 Clear Pending   p143
UNPEND1     equ   0x284    ; Interrupt 32-54 Clear Pending  p144

ACTIV0      equ   0x300    ; Interrupt 0-31 Active Bit   p145
ACTIV1      equ   0x304    ; Interrupt 32-54 Active Bit  p146

PRI0        equ   0x400    ; Interrupt 0-3 Priority  p147
PRI1        equ   0x404    ; Interrupt 4-7 Priority  p147
PRI2        equ   0x408    ; ...
PRI3        equ   0x40C
PRI4        equ   0x410
PRI5        equ   0x414
PRI6        equ   0x418
PRI7        equ   0x41C
PRI8        equ   0x420
PRI9        equ   0x424
PRI10       equ   0x428
PRI11       equ   0x42C
PRI12       equ   0x430
PRI13       equ   0x434

SWTRIG      equ   0xf00    ; Software Trigger Interrupt  p149

SCB         equ   0x008    ; Auxiliary Control p150
INCTRL      equ   0xD04    ; Interrupt Control and State  p153
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Timers register MAP p546 du lm3s9b92.pdf
;
TIMER0   equ   0x40030000
TIMER1   equ   0x40031000
TIMER2   equ   0x40032000
TIMER3   equ   0x40033000

GPTMCFG        equ   0x000 ; R/W 0x0000.0000 GPTM Configuration            p548

GPTMTAMR       equ   0x004 ; R/W 0x0000.0000 GPTM Timer A Mode             p549
GPTMTBMR       equ   0x008 ; R/W 0x0000.0000 GPTM Timer B Mode             p551

GPTMCTL        equ   0x00C ; R/W 0x0000.0000 GPTM Control                  p553
GPTMIMR        equ   0x018 ; R/W 0x0000.0000 GPTM Interrupt Mask           p556
GPTMRIS        equ   0x01C ; RO  0x0000.0000 GPTM Raw Interrupt Status     p558
GPTMMIS        equ   0x020 ; RO  0x0000.0000 GPTM Masked Interrupt Status  p561
GPTMICR        equ   0x024 ; W1C 0x0000.0000 GPTM Interrupt Clear          p564

GPTMTAILR      equ   0x028 ; R/W 0xFFFF.FFFF GPTM Timer A Interval Load    p566
GPTMTBILR      equ   0x02C ; R/W 0x0000.FFFF GPTM Timer B Interval Load    p567

GPTMTAMATCHR   equ   0x030 ; R/W 0xFFFF.FFFF GPTM Timer A Match            p568
GPTMTBMATCHR   equ   0x034 ; R/W 0x0000.FFFF GPTM Timer B Match            p569

GPTMTAPR       equ   0x038 ; R/W 0x0000.0000 GPTM Timer A Prescale         p570
GPTMTBPR       equ   0x03C ; R/W 0x0000.0000 GPTM Timer B Prescale         p571

GPTMTAPMR      equ   0x040 ; R/W 0x0000.0000 GPTM TimerA Prescale Match    p572
GPTMTBPMR      equ   0x044 ; R/W 0x0000.0000 GPTM TimerB Prescale Match    p573

GPTMTAR        equ   0x048 ; RO 0xFFFF.FFFF GPTM Timer A                   p574
GPTMTBR        equ   0x04C ; RO 0x0000.FFFF GPTM Timer B                   p575

GPTMTAV        equ   0x050 ; RW 0xFFFF.FFFF GPTM Timer A Value             p576
GPTMTBV        equ   0x054 ; RW 0x0000.FFFF GPTM Timer B Value             p577

            end