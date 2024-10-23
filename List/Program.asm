
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Release
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 1
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _hitung=R4
	.DEF _hitung_msb=R5
	.DEF _mulai=R6
	.DEF _mulai_msb=R7
	.DEF _nadc7=R8
	.DEF _nadc7_msb=R9
	.DEF _nilai_warna=R10
	.DEF _nilai_warna_msb=R11
	.DEF _lowM=R12
	.DEF _lowM_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0xE3,0x0

_0x6:
	.DB  0xE4
_0x7:
	.DB  0xA3
_0x8:
	.DB  0xB9
_0x9:
	.DB  0xCF
_0xA:
	.DB  0xD0
_0xB:
	.DB  0xBC
_0xC:
	.DB  0xC7
_0xD:
	.DB  0xE6
_0xE:
	.DB  0xE6
_0xF:
	.DB  0x1
_0x0:
	.DB  0x43,0x45,0x4B,0x20,0x53,0x45,0x4E,0x53
	.DB  0x4F,0x52,0x20,0x20,0x0,0x25,0x64,0x25
	.DB  0x64,0x25,0x64,0x25,0x64,0x25,0x64,0x25
	.DB  0x64,0x25,0x64,0x0,0x42,0x61,0x63,0x61
	.DB  0x20,0x4C,0x69,0x6E,0x65,0x0,0x73,0x65
	.DB  0x6E,0x73,0x6F,0x72,0x3A,0x25,0x64,0x20
	.DB  0x3D,0x20,0x25,0x64,0x20,0x20,0x0,0x42
	.DB  0x61,0x63,0x61,0x20,0x42,0x61,0x63,0x6B
	.DB  0x67,0x72,0x6F,0x75,0x6E,0x64,0x0,0x43
	.DB  0x65,0x6E,0x74,0x65,0x72,0x20,0x50,0x6F
	.DB  0x69,0x6E,0x74,0x20,0x20,0x20,0x20,0x0
	.DB  0x73,0x65,0x6E,0x73,0x6F,0x72,0x3A,0x25
	.DB  0x64,0x20,0x2D,0x2D,0x3E,0x20,0x25,0x64
	.DB  0x20,0x20,0x0,0x64,0x61,0x74,0x61,0x20
	.DB  0x6B,0x65,0x20,0x3D,0x20,0x25,0x64,0x20
	.DB  0x0,0x73,0x65,0x6E,0x73,0x69,0x6E,0x67
	.DB  0x20,0x3D,0x20,0x25,0x64,0x20,0x20,0x0
	.DB  0x25,0x64,0x20,0x20,0x20,0x0,0x4B,0x55
	.DB  0x4E,0x49,0x4E,0x47,0x20,0x20,0x20,0x0
	.DB  0x42,0x49,0x52,0x55,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x4D,0x45,0x52,0x41,0x48,0x20
	.DB  0x20,0x20,0x20,0x0,0x48,0x49,0x4A,0x41
	.DB  0x55,0x20,0x20,0x20,0x20,0x0,0x46,0x46
	.DB  0x20,0x4F,0x6E,0x6C,0x69,0x6E,0x65,0x53
	.DB  0x68,0x6F,0x70,0x0,0x52,0x6F,0x62,0x6F
	.DB  0x74,0x20,0x41,0x54,0x4D,0x65,0x67,0x61
	.DB  0x31,0x36,0x41,0x0,0x6D,0x75,0x6C,0x61
	.DB  0x69,0x20,0x63,0x65,0x6B,0x20,0x70,0x6F
	.DB  0x69,0x6E,0x74,0x3A,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _highM
	.DW  _0x6*2

	.DW  0x01
	.DW  _lowK
	.DW  _0x7*2

	.DW  0x01
	.DW  _highK
	.DW  _0x8*2

	.DW  0x01
	.DW  _lowH
	.DW  _0x9*2

	.DW  0x01
	.DW  _highH
	.DW  _0xA*2

	.DW  0x01
	.DW  _lowB
	.DW  _0xB*2

	.DW  0x01
	.DW  _highB
	.DW  _0xC*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void scanX(int brpkali,int kec1);
;void scan(int kec);
;void konvert_logic();
;void logika();
;void cek_sensor();
;void lcd_kedip(int ulangi);
;void maju(unsigned char ki,unsigned char ka);
;void mundur(unsigned char ki,unsigned char ka);
;void kanan(unsigned char ki,unsigned char ka);
;void kiri(unsigned char ki,unsigned char ka);
;void scan_garis(int kec);
;void scan_back(int kec);
;void hit_tengah(int kec);
;void scan2(int kec);
;void belki(int ki, int ka);
;void belki2(int ki, int ka);
;void belka2(int ki, int ka);
;void belka(int ki ,int ka);
;void scanmundur(int ki ,int ka);
;void scan7ki(int brpkali,int kec1);
;void scan7ki2(int brpkali,int kec1);
;void scan7ka(int brpkali,int kec1);
;void scan7ka2(int brpkali,int kec1);
;void scan0(int brpkali,int kec1);
;void scan0rem(int kec1);
;void parkir();
;void maju_cari_garis(int brpkali,int kec1);
;void ambil();
;void siapambil();
;void letakkan();
;int bacawarna();
;void rem(int nilai_rem);
;void arah2();
;void arahbawah();
;void arah2new();
;void copy();
;void scantime(int waktu,int kec1);
;void arahbawah2();
;void buang();
;void arah2hijau();
;void arah2merah();
;void arah2kuningkecil();
   .equ __lcd_port=0x18 ;PORTB
; 0000 005F #endasm
;unsigned char read_adc(unsigned char adc_input)
; 0000 0067 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0068 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0069 // Start the AD conversion
; 0000 006A ADCSRA|=0x40;
	SBI  0x6,6
; 0000 006B // Wait for the AD conversion to complete
; 0000 006C while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 006D ADCSRA|=0x10;
	SBI  0x6,4
; 0000 006E return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 006F }
; .FEND
;int hitung=0,mulai=0;
;unsigned int nadc7=0,nilai_warna=0;
;unsigned int lowM=  227;
;unsigned int highM= 228;

	.DSEG
;unsigned int lowK= 163;
;unsigned int highK=185;
;unsigned int lowH=207;
;unsigned int highH=208;
;unsigned int lowB= 188;
;unsigned int highB= 199;
;char buff[33], hasilwarna;
;int i,j,k,rka=0,rki=0;
;bit x,kondisi;
;unsigned char kecepatanki=230,kecepatanka=230;
;unsigned char pos_servo1,pos_servo2,a,pos_led1,pos_led2;
;char simpan;
;int capit=0,angkat=0,_maju=0,_mundur=0;
;char arr[16],irr[16];
;int push=1;
;eeprom int garis[10],back[10],tengah[10];
;unsigned char sen[10],sensor;
;void ambil()
; 0000 008D {  capit_ambil;  delay_ms(500); bacawarna(); lengan_atas;    }

	.CSEG
_ambil:
; .FSTART _ambil
	LDI  R30,LOW(233)
	CALL SUBOPT_0x0
	RCALL _bacawarna
	LDI  R30,LOW(226)
	STS  _pos_servo2,R30
	RET
; .FEND
;void siapambil()
; 0000 008F { capit_lepas; delay_ms(500); lengan_bawah; delay_ms(500);  }
;void letakkan()   //248 226
; 0000 0091 { //lengan_bawah;
; 0000 0092 for(i=226;i<=248;i++){
; 0000 0093 pos_servo2=i;
; 0000 0094 delay_ms(25);
; 0000 0095 
; 0000 0096 }
; 0000 0097 }
;void buang()   //248 226
; 0000 0099 { lengan_bawah;
_buang:
; .FSTART _buang
	LDI  R30,LOW(247)
	CALL SUBOPT_0x1
; 0000 009A 
; 0000 009B delay_ms(200);  capit_lepas;  delay_ms(500);  lengan_atas; delay_ms(200); capit_ ...
	LDI  R30,LOW(243)
	CALL SUBOPT_0x0
	LDI  R30,LOW(226)
	CALL SUBOPT_0x1
	LDI  R30,LOW(233)
	STS  _pos_servo1,R30
; 0000 009C }
	RET
; .FEND
;void arah2()
; 0000 009F {
; 0000 00A0 scanX(1,185);
; 0000 00A1 rem(500);
; 0000 00A2 ambil();
; 0000 00A3 scan0(3,185);
; 0000 00A4 scan0rem(170);
; 0000 00A5 rem(100);
; 0000 00A6 scanmundur(160,160);
; 0000 00A7 rem(100);
; 0000 00A8 belki2(170,170);
; 0000 00A9 scan7ki2(3,200);
; 0000 00AA rem(100);
; 0000 00AB belka2(190,190);
; 0000 00AC rem(100);
; 0000 00AD buang();
; 0000 00AE ambil();
; 0000 00AF rem(100);
; 0000 00B0 mundur(160,160);
; 0000 00B1 delay_ms(100);
; 0000 00B2 belka(160,160);
; 0000 00B3 scan7ki2(1,200);
; 0000 00B4 belka(160,160);
; 0000 00B5 ///belka(170,170);
; 0000 00B6 scanX(1,200);
; 0000 00B7 //rem(500);
; 0000 00B8 
; 0000 00B9 scan0(2,190);
; 0000 00BA //rem(100);
; 0000 00BB 
; 0000 00BC scanX(1,220);
; 0000 00BD lcd_kedip(3);
; 0000 00BE scan0rem(180);
; 0000 00BF rem(100);
; 0000 00C0 }
;void arah2kuningkecil()
; 0000 00C2 {
_arah2kuningkecil:
; .FSTART _arah2kuningkecil
; 0000 00C3 scanX(1,185);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 00C4 rem(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _rem
; 0000 00C5 ambil();
	RCALL _ambil
; 0000 00C6 scan0(3,185);
	CALL SUBOPT_0x4
	LDI  R26,LOW(185)
	CALL SUBOPT_0x5
; 0000 00C7 scan0rem(170);
; 0000 00C8 rem(100);
; 0000 00C9 scanmundur(160,160);
; 0000 00CA rem(100);
; 0000 00CB belki2(170,170);
	CALL SUBOPT_0x6
	RCALL _belki2
; 0000 00CC scan7ki2(3,200);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
; 0000 00CD rem(100);
	CALL SUBOPT_0x8
; 0000 00CE belka2(190,190);
	CALL SUBOPT_0x9
	RCALL _belka2
; 0000 00CF rem(100);
	CALL SUBOPT_0x8
; 0000 00D0 buang();
	RCALL _buang
; 0000 00D1 rem(100);
	CALL SUBOPT_0x8
; 0000 00D2 mundur(160,160);
	CALL SUBOPT_0xA
; 0000 00D3 delay_ms(100);
; 0000 00D4 belka(160,160);
	CALL SUBOPT_0xB
; 0000 00D5 scan7ki2(1,200);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x7
; 0000 00D6 belka(160,160);
	CALL SUBOPT_0xB
; 0000 00D7 ///belka(170,170);
; 0000 00D8 scanX(1,200);
	RJMP _0x20C0007
; 0000 00D9 //rem(500);
; 0000 00DA 
; 0000 00DB scan0(2,190);
; 0000 00DC //rem(100);
; 0000 00DD 
; 0000 00DE scanX(1,220);
; 0000 00DF lcd_kedip(3);
; 0000 00E0 scan0rem(180);
; 0000 00E1 rem(100);
; 0000 00E2 }
; .FEND
;void copy()
; 0000 00E4 {   belka(170,170);
; 0000 00E5 scan7ki2(3,170);
; 0000 00E6 }
;void arah2new()
; 0000 00E8 {
_arah2new:
; .FSTART _arah2new
; 0000 00E9 scanX(1,185);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 00EA rem(100);
	CALL SUBOPT_0x8
; 0000 00EB //ambil();
; 0000 00EC scan0(3,190);
	CALL SUBOPT_0x4
	LDI  R26,LOW(190)
	CALL SUBOPT_0x5
; 0000 00ED scan0rem(170);
; 0000 00EE rem(100);
; 0000 00EF scanmundur(160,160);
; 0000 00F0 rem(100);
; 0000 00F1 buang();
	RCALL _buang
; 0000 00F2 belka2(160,160);
	CALL SUBOPT_0xC
; 0000 00F3 belka2(160,160);
	CALL SUBOPT_0xC
; 0000 00F4 ///belka(170,170);
; 0000 00F5 scanX(1,200);
	RJMP _0x20C0007
; 0000 00F6 //rem(500);
; 0000 00F7 
; 0000 00F8 scan0(2,190);
; 0000 00F9 //rem(100);
; 0000 00FA 
; 0000 00FB scanX(1,220);
; 0000 00FC lcd_kedip(3);
; 0000 00FD scan0rem(180);
; 0000 00FE rem(100);
; 0000 00FF }
; .FEND
;void arahbawah()
; 0000 0103 {
; 0000 0104 ///belka(170,170);
; 0000 0105 scanX(1,200);
; 0000 0106 //rem(500);
; 0000 0107 
; 0000 0108 scan0(2,190);
; 0000 0109 //rem(100);
; 0000 010A 
; 0000 010B scanX(1,220);
; 0000 010C lcd_kedip(3);
; 0000 010D scan0rem(180);
; 0000 010E rem(100);
; 0000 010F }
;void arahbawah2()
; 0000 0111 {
; 0000 0112 belki(170,170);
; 0000 0113 scanX(1,200);
; 0000 0114 lcd_kedip(2);
; 0000 0115 rem(500);
; 0000 0116 scan0(2,200);
; 0000 0117 rem(100);
; 0000 0118 
; 0000 0119 scan0rem(180);
; 0000 011A }
;void scanX(int brpkali,int kec1)
; 0000 011C {      cek_sensor();
_scanX:
; .FSTART _scanX
	CALL SUBOPT_0xD
;	brpkali -> Y+2
;	kec1 -> Y+0
; 0000 011D while (hitung<brpkali) {
_0x13:
	CALL SUBOPT_0xE
	BRGE _0x15
; 0000 011E while ((sensor & 0b00011100)!=0b00011100)
_0x16:
	CALL SUBOPT_0xF
	BREQ _0x18
; 0000 011F {cek_sensor();
	CALL SUBOPT_0x10
; 0000 0120 scan(kec1);
; 0000 0121 }
	RJMP _0x16
_0x18:
; 0000 0122 
; 0000 0123 while ((sensor & 0b00011100)==0b00011100)
_0x19:
	CALL SUBOPT_0xF
	BRNE _0x1B
; 0000 0124 {    cek_sensor();
	CALL SUBOPT_0x11
; 0000 0125 lampu=0;
; 0000 0126 
; 0000 0127 scan(kec1);
; 0000 0128 if ((sensor & 0b00011100)!=0b00011100) {
	CALL SUBOPT_0xF
	BREQ _0x1E
; 0000 0129 hitung++;
	CALL SUBOPT_0x12
; 0000 012A lampu=1;
; 0000 012B };
_0x1E:
; 0000 012C }
	RJMP _0x19
_0x1B:
; 0000 012D }
	RJMP _0x13
_0x15:
; 0000 012E hitung=0;
	RJMP _0x20C0005
; 0000 012F 
; 0000 0130 }
; .FEND
;void rem(int nilai_rem)
; 0000 0133 {
_rem:
; .FSTART _rem
; 0000 0134 PORTD.4=1;
	ST   -Y,R27
	ST   -Y,R26
;	nilai_rem -> Y+0
	SBI  0x12,4
; 0000 0135 PORTD.5=1;
	SBI  0x12,5
; 0000 0136 PORTD.2=0;
	CBI  0x12,2
; 0000 0137 PORTD.3=0;
	CBI  0x12,3
; 0000 0138 PORTD.6=0;
	CBI  0x12,6
; 0000 0139 PORTD.7=0;
	CBI  0x12,7
; 0000 013A delay_ms(nilai_rem);
	CALL SUBOPT_0x13
; 0000 013B }
	RJMP _0x20C0008
; .FEND
;void konvert_logic()
; 0000 013E { for(i=0;i<7;i++)
_konvert_logic:
; .FSTART _konvert_logic
	CALL SUBOPT_0x14
_0x2E:
	CALL SUBOPT_0x15
	SBIW R26,7
	BRGE _0x2F
; 0000 013F { if(read_adc(i)>tengah[i]) { sen[i]=1; }
	CALL SUBOPT_0x16
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x30
	CALL SUBOPT_0x17
	LDI  R26,LOW(1)
	RJMP _0x198
; 0000 0140 else if(read_adc(i)<tengah[i]){sen[i]=0;}
_0x30:
	CALL SUBOPT_0x16
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x32
	CALL SUBOPT_0x17
	LDI  R26,LOW(0)
_0x198:
	STD  Z+0,R26
; 0000 0141 }
_0x32:
	CALL SUBOPT_0x18
	RJMP _0x2E
_0x2F:
; 0000 0142 }
	RET
; .FEND
;void logika()
; 0000 0144 {   sensor=(sen[6]*64)+(sen[5]*32)+(sen[4]*16)+(sen[3]*8)+(sen[2]*4)+(sen[1]*2)+ ...
_logika:
; .FSTART _logika
	__GETB1MN _sen,6
	LDI  R26,LOW(64)
	MULS R30,R26
	MOV  R22,R0
	__GETB1MN _sen,5
	LDI  R26,LOW(32)
	MULS R30,R26
	MOVW R30,R0
	ADD  R22,R30
	__GETB1MN _sen,4
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R22
	ADD  R26,R30
	__GETB1MN _sen,3
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R26,R30
	__GETB1MN _sen,2
	LSL  R30
	LSL  R30
	ADD  R26,R30
	__GETB1MN _sen,1
	LSL  R30
	ADD  R30,R26
	LDS  R26,_sen
	ADD  R30,R26
	STS  _sensor,R30
; 0000 0145 }
	RET
; .FEND
;void cek_sensor()
; 0000 0147 {   konvert_logic();
_cek_sensor:
; .FSTART _cek_sensor
	RCALL _konvert_logic
; 0000 0148 logika();
	RCALL _logika
; 0000 0149 lcd_gotoxy(0,0);
	CALL SUBOPT_0x19
; 0000 014A lcd_putsf("CEK SENSOR  ");
	__POINTW2FN _0x0,0
	CALL SUBOPT_0x1A
; 0000 014B lcd_gotoxy(0,1);
; 0000 014C sprintf(buff,"%d%d%d%d%d%d%d",sen[0],sen[1],sen[2],sen[3],sen[4],sen[5],sen[6]);
	__POINTW1FN _0x0,13
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_sen
	CALL SUBOPT_0x1B
	__GETB1MN _sen,1
	CALL SUBOPT_0x1B
	__GETB1MN _sen,2
	CALL SUBOPT_0x1B
	__GETB1MN _sen,3
	CALL SUBOPT_0x1B
	__GETB1MN _sen,4
	CALL SUBOPT_0x1B
	__GETB1MN _sen,5
	CALL SUBOPT_0x1B
	__GETB1MN _sen,6
	CALL SUBOPT_0x1B
	LDI  R24,28
	CALL _sprintf
	ADIW R28,32
; 0000 014D lcd_puts(buff);
	CALL SUBOPT_0x1C
; 0000 014E }
	RET
; .FEND
;void lcd_kedip(int ulangi)
; 0000 0151 {  for(i=0;i<ulangi;i++)
_lcd_kedip:
; .FSTART _lcd_kedip
	CALL SUBOPT_0x1D
;	ulangi -> Y+0
_0x34:
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x15
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x35
; 0000 0152 {
; 0000 0153 lampu=0;
	CBI  0x18,3
; 0000 0154 delay_ms(100);
	CALL SUBOPT_0x1E
; 0000 0155 lampu=1;
	SBI  0x18,3
; 0000 0156 delay_ms(100);
	CALL SUBOPT_0x1E
; 0000 0157 }
	CALL SUBOPT_0x18
	RJMP _0x34
_0x35:
; 0000 0158 }
	RJMP _0x20C0008
; .FEND
;void maju(unsigned char ki,unsigned char ka)
; 0000 015A {
_maju:
; .FSTART _maju
; 0000 015B pwmka=ka;
	CALL SUBOPT_0x1F
;	ki -> Y+1
;	ka -> Y+0
; 0000 015C pwmki=ki;
; 0000 015D 
; 0000 015E //dir kiri
; 0000 015F PORTD.2=1;
	SBI  0x12,2
; 0000 0160 PORTD.3=0;
	CBI  0x12,3
; 0000 0161 
; 0000 0162 //dir kanan
; 0000 0163 PORTD.6=0;
	CBI  0x12,6
; 0000 0164 PORTD.7=1;
	SBI  0x12,7
; 0000 0165 }
	RJMP _0x20C0008
; .FEND
;void mundur(unsigned char ki,unsigned char ka)
; 0000 0168 {
_mundur:
; .FSTART _mundur
; 0000 0169 pwmka=ka;
	CALL SUBOPT_0x1F
;	ki -> Y+1
;	ka -> Y+0
; 0000 016A pwmki=ki;
; 0000 016B 
; 0000 016C //dir kiri
; 0000 016D PORTD.2=0;
	CBI  0x12,2
; 0000 016E PORTD.3=1;
	SBI  0x12,3
; 0000 016F 
; 0000 0170 //dir kanan
; 0000 0171 PORTD.6=1;
	SBI  0x12,6
; 0000 0172 PORTD.7=0;
	CBI  0x12,7
; 0000 0173 }
	RJMP _0x20C0008
; .FEND
;void kanan(unsigned char ki,unsigned char ka)
; 0000 0176 {
_kanan:
; .FSTART _kanan
; 0000 0177 pwmka=ka;
	CALL SUBOPT_0x1F
;	ki -> Y+1
;	ka -> Y+0
; 0000 0178 pwmki=ki;
; 0000 0179 
; 0000 017A //dir kiri
; 0000 017B PORTD.2=0;
	CBI  0x12,2
; 0000 017C PORTD.3=1;
	SBI  0x12,3
; 0000 017D 
; 0000 017E //dir kanan
; 0000 017F PORTD.6=0;
	CBI  0x12,6
; 0000 0180 PORTD.7=1;
	SBI  0x12,7
; 0000 0181 }
	RJMP _0x20C0008
; .FEND
;void kiri(unsigned char ki,unsigned char ka)
; 0000 0184 {
_kiri:
; .FSTART _kiri
; 0000 0185 pwmka=ka;
	CALL SUBOPT_0x1F
;	ki -> Y+1
;	ka -> Y+0
; 0000 0186 pwmki=ki;
; 0000 0187 
; 0000 0188 //dir kiri
; 0000 0189 PORTD.2=1;
	SBI  0x12,2
; 0000 018A PORTD.3=0;
	CBI  0x12,3
; 0000 018B 
; 0000 018C //dir kanan
; 0000 018D PORTD.6=1;
	SBI  0x12,6
; 0000 018E PORTD.7=0;
	CBI  0x12,7
; 0000 018F }
	RJMP _0x20C0008
; .FEND
;void scan_garis(int kec)
; 0000 0191 {
_scan_garis:
; .FSTART _scan_garis
; 0000 0192 for(i=0;i<7;i++)
	CALL SUBOPT_0x1D
;	kec -> Y+0
_0x5B:
	CALL SUBOPT_0x15
	SBIW R26,7
	BRGE _0x5C
; 0000 0193 {
; 0000 0194 garis[i]=read_adc(i);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDS  R26,_i
	RCALL _read_adc
	POP  R26
	POP  R27
	LDI  R31,0
	CALL SUBOPT_0x22
; 0000 0195 lcd_gotoxy(0,0);
; 0000 0196 lcd_putsf("Baca Line");
	__POINTW2FN _0x0,28
	CALL SUBOPT_0x1A
; 0000 0197 lcd_gotoxy(0,1);
; 0000 0198 sprintf(buff,"sensor:%d = %d  ",i,garis[i]);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
; 0000 0199 lcd_puts(buff);
; 0000 019A lampu=0;
	CBI  0x18,3
; 0000 019B delay_ms(kec);
	CALL SUBOPT_0x13
; 0000 019C lampu=1;
	SBI  0x18,3
; 0000 019D 
; 0000 019E }
	CALL SUBOPT_0x18
	RJMP _0x5B
_0x5C:
; 0000 019F }
	RJMP _0x20C0008
; .FEND
;void scan_back(int kec)
; 0000 01A2 {
_scan_back:
; .FSTART _scan_back
; 0000 01A3 for(i=0;i<7;i++)
	CALL SUBOPT_0x1D
;	kec -> Y+0
_0x62:
	CALL SUBOPT_0x15
	SBIW R26,7
	BRGE _0x63
; 0000 01A4 {
; 0000 01A5 back[i]=read_adc(i);
	CALL SUBOPT_0x25
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDS  R26,_i
	RCALL _read_adc
	POP  R26
	POP  R27
	LDI  R31,0
	CALL SUBOPT_0x22
; 0000 01A6 lcd_gotoxy(0,0);
; 0000 01A7 lcd_putsf("Baca Background");
	__POINTW2FN _0x0,55
	CALL SUBOPT_0x1A
; 0000 01A8 lcd_gotoxy(0,1);
; 0000 01A9 sprintf(buff,"sensor:%d = %d  ",i,back[i]);
	CALL SUBOPT_0x23
	LDI  R26,LOW(_back)
	LDI  R27,HIGH(_back)
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x24
; 0000 01AA lcd_puts(buff);
; 0000 01AB lampu=0;
	CBI  0x18,3
; 0000 01AC delay_ms(kec);
	CALL SUBOPT_0x13
; 0000 01AD lampu=1;
	SBI  0x18,3
; 0000 01AE 
; 0000 01AF }
	CALL SUBOPT_0x18
	RJMP _0x62
_0x63:
; 0000 01B0 }
	RJMP _0x20C0008
; .FEND
;void hit_tengah(int kec)
; 0000 01B4 {
_hit_tengah:
; .FSTART _hit_tengah
; 0000 01B5 for(i=0;i<7;i++)
	CALL SUBOPT_0x1D
;	kec -> Y+0
_0x69:
	CALL SUBOPT_0x15
	SBIW R26,7
	BRGE _0x6A
; 0000 01B6 {
; 0000 01B7 tengah[i]=(back[i]+garis[i])/2;
	CALL SUBOPT_0x26
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x25
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R0,R30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R26,R22
	CALL SUBOPT_0x22
; 0000 01B8 lcd_gotoxy(0,0);
; 0000 01B9 lcd_putsf("Center Point    ");
	__POINTW2FN _0x0,71
	CALL SUBOPT_0x1A
; 0000 01BA lcd_gotoxy(0,1);
; 0000 01BB sprintf(buff,"sensor:%d --> %d  ",i,tengah[i]);
	__POINTW1FN _0x0,88
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x20
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x26
	CALL SUBOPT_0x24
; 0000 01BC lcd_puts(buff);
; 0000 01BD lampu=0;
	CBI  0x18,3
; 0000 01BE delay_ms(kec);
	CALL SUBOPT_0x13
; 0000 01BF lampu=1;
	SBI  0x18,3
; 0000 01C0 }
	CALL SUBOPT_0x18
	RJMP _0x69
_0x6A:
; 0000 01C1 }
_0x20C0008:
	ADIW R28,2
	RET
; .FEND
;void belki(int ki, int ka)
; 0000 01C4 {  cek_sensor();
_belki:
; .FSTART _belki
	CALL SUBOPT_0xD
;	ki -> Y+2
;	ka -> Y+0
; 0000 01C5 while ((sensor & 0b0000001)!=0b0000001)
_0x6F:
	CALL SUBOPT_0x27
	BREQ _0x71
; 0000 01C6 {cek_sensor();
	CALL SUBOPT_0x28
; 0000 01C7 kiri(ki,ka);
; 0000 01C8 }
	RJMP _0x6F
_0x71:
; 0000 01C9 
; 0000 01CA }
	RJMP _0x20C0006
; .FEND
;void belki2(int ki, int ka)
; 0000 01CC {
_belki2:
; .FSTART _belki2
; 0000 01CD cek_sensor();
	CALL SUBOPT_0xD
;	ki -> Y+2
;	ka -> Y+0
; 0000 01CE while ((sensor & 0b0000001)!=0b0000001)
_0x72:
	CALL SUBOPT_0x27
	BREQ _0x74
; 0000 01CF {cek_sensor();
	CALL SUBOPT_0x28
; 0000 01D0 kiri(ki,ka);
; 0000 01D1 }
	RJMP _0x72
_0x74:
; 0000 01D2 while ((sensor & 0b0000001)==0b0000001)
_0x75:
	CALL SUBOPT_0x27
	BRNE _0x77
; 0000 01D3 {cek_sensor();
	CALL SUBOPT_0x28
; 0000 01D4 kiri(ki,ka);
; 0000 01D5 }
	RJMP _0x75
_0x77:
; 0000 01D6 rem(100);
	CALL SUBOPT_0x8
; 0000 01D7 lcd_kedip(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _lcd_kedip
; 0000 01D8 }
	RJMP _0x20C0006
; .FEND
;void belka2(int ki, int ka)
; 0000 01DA {
_belka2:
; .FSTART _belka2
; 0000 01DB cek_sensor();
	CALL SUBOPT_0xD
;	ki -> Y+2
;	ka -> Y+0
; 0000 01DC while ((sensor & 0b01000000)!=0b01000000)
_0x78:
	CALL SUBOPT_0x29
	BREQ _0x7A
; 0000 01DD {cek_sensor();
	CALL SUBOPT_0x2A
; 0000 01DE kanan(ki,ka);
; 0000 01DF }
	RJMP _0x78
_0x7A:
; 0000 01E0 while ((sensor & 0b01000000)==0b01000000)
_0x7B:
	CALL SUBOPT_0x29
	BRNE _0x7D
; 0000 01E1 {cek_sensor();
	CALL SUBOPT_0x2A
; 0000 01E2 kanan(ki,ka);
; 0000 01E3 }
	RJMP _0x7B
_0x7D:
; 0000 01E4 while ((sensor & 0b00000001)!=0b00000001)
_0x7E:
	CALL SUBOPT_0x27
	BREQ _0x80
; 0000 01E5 {cek_sensor();
	CALL SUBOPT_0x2A
; 0000 01E6 kanan(ki,ka);
; 0000 01E7 }
	RJMP _0x7E
_0x80:
; 0000 01E8 rem(100);
	CALL SUBOPT_0x8
; 0000 01E9 lcd_kedip(3);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _lcd_kedip
; 0000 01EA }
	RJMP _0x20C0006
; .FEND
;void belka(int ki ,int ka)
; 0000 01EE {
_belka:
; .FSTART _belka
; 0000 01EF cek_sensor();       //ka......ki
	CALL SUBOPT_0xD
;	ki -> Y+2
;	ka -> Y+0
; 0000 01F0 while ((sensor & 0b01000000)!=0b01000000)
_0x81:
	CALL SUBOPT_0x29
	BREQ _0x83
; 0000 01F1 {
; 0000 01F2 cek_sensor();
	CALL SUBOPT_0x2A
; 0000 01F3 kanan(ki,ka);
; 0000 01F4 }
	RJMP _0x81
_0x83:
; 0000 01F5 }
	RJMP _0x20C0006
; .FEND
;void scanmundur(int ki ,int ka)
; 0000 01F7 {
_scanmundur:
; .FSTART _scanmundur
; 0000 01F8 cek_sensor();       //ka......ki
	CALL SUBOPT_0xD
;	ki -> Y+2
;	ka -> Y+0
; 0000 01F9 while ((sensor & 0b01000000)!=0b01000000)
_0x84:
	CALL SUBOPT_0x29
	BREQ _0x86
; 0000 01FA {
; 0000 01FB cek_sensor();
	CALL SUBOPT_0x2B
; 0000 01FC mundur(ki,ka);
; 0000 01FD }
	RJMP _0x84
_0x86:
; 0000 01FE while ((sensor & 0b01000000)==0b01000000)
_0x87:
	CALL SUBOPT_0x29
	BRNE _0x89
; 0000 01FF {
; 0000 0200 cek_sensor();
	CALL SUBOPT_0x2B
; 0000 0201 mundur(ki,ka);
; 0000 0202 }
	RJMP _0x87
_0x89:
; 0000 0203 }
	RJMP _0x20C0006
; .FEND
;void arah2hijau()
; 0000 0205 {
_arah2hijau:
; .FSTART _arah2hijau
; 0000 0206 scanX(1,185);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0207 rem(100);
	CALL SUBOPT_0x8
; 0000 0208 //ambil();
; 0000 0209 scan0(3,190);
	CALL SUBOPT_0x4
	LDI  R26,LOW(190)
	CALL SUBOPT_0x5
; 0000 020A scan0rem(170);
; 0000 020B rem(100);
; 0000 020C scanmundur(160,160);
; 0000 020D rem(100);
; 0000 020E belka(170,170);
	CALL SUBOPT_0x6
	RCALL _belka
; 0000 020F scan7ki2(1,200);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x7
; 0000 0210 belki2(190,190);
	CALL SUBOPT_0x9
	RCALL _belki2
; 0000 0211 rem(100);
	CALL SUBOPT_0x8
; 0000 0212 buang();
	RCALL _buang
; 0000 0213 rem(100);
	CALL SUBOPT_0x8
; 0000 0214 mundur(160,160);
	CALL SUBOPT_0xA
; 0000 0215 delay_ms(100);
; 0000 0216 belki2(180,180);
	CALL SUBOPT_0x2C
; 0000 0217 scan7ka2(1,200);
	CALL SUBOPT_0x2
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _scan7ka2
; 0000 0218 belki(160,160);
	CALL SUBOPT_0x2D
; 0000 0219 ///belka(170,170);
; 0000 021A scanX(1,200);
	RJMP _0x20C0007
; 0000 021B //rem(500);
; 0000 021C 
; 0000 021D scan0(2,190);
; 0000 021E //rem(100);
; 0000 021F 
; 0000 0220 scanX(1,220);
; 0000 0221 lcd_kedip(3);
; 0000 0222 scan0rem(180);
; 0000 0223 rem(100);
; 0000 0224 }
; .FEND
;void arah2merah()
; 0000 0226 {
_arah2merah:
; .FSTART _arah2merah
; 0000 0227 scanX(1,185);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0228 rem(100);
	CALL SUBOPT_0x8
; 0000 0229 //ambil();
; 0000 022A scan0(3,190);
	CALL SUBOPT_0x4
	LDI  R26,LOW(190)
	CALL SUBOPT_0x5
; 0000 022B scan0rem(170);
; 0000 022C rem(100);
; 0000 022D scanmundur(160,160);
; 0000 022E rem(100);
; 0000 022F kiri(180,180);
	LDI  R30,LOW(180)
	ST   -Y,R30
	LDI  R26,LOW(180)
	RCALL _kiri
; 0000 0230 delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 0231 rem(100);
	CALL SUBOPT_0x8
; 0000 0232 buang();
	RCALL _buang
; 0000 0233 belki2(180,180);
	CALL SUBOPT_0x2C
; 0000 0234 belki2(170,170);
	CALL SUBOPT_0x6
	RCALL _belki2
; 0000 0235 ///belka(170,170);
; 0000 0236 scanX(1,200);
_0x20C0007:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _scanX
; 0000 0237 //rem(500);
; 0000 0238 
; 0000 0239 scan0(2,190);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(190)
	LDI  R27,0
	RCALL _scan0
; 0000 023A //rem(100);
; 0000 023B 
; 0000 023C scanX(1,220);
	CALL SUBOPT_0x2
	LDI  R26,LOW(220)
	LDI  R27,0
	RCALL _scanX
; 0000 023D lcd_kedip(3);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _lcd_kedip
; 0000 023E scan0rem(180);
	LDI  R26,LOW(180)
	LDI  R27,0
	RCALL _scan0rem
; 0000 023F rem(100);
	CALL SUBOPT_0x8
; 0000 0240 }
	RET
; .FEND
;void scan(int kec)
; 0000 0243 {       cek_sensor();
_scan:
; .FSTART _scan
	CALL SUBOPT_0xD
;	kec -> Y+0
; 0000 0244 sensor=sensor & 0b01111111;
	LDS  R30,_sensor
	ANDI R30,0x7F
	STS  _sensor,R30
; 0000 0245 switch(sensor)          //  1=kiri 8=kanan
	LDI  R31,0
; 0000 0246 {          //  7......1
; 0000 0247 case 0b00000001: maju(kec-100,kec);   x=1;     break;//DOMINAN KANAN
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8D
	LD   R30,Y
	SUBI R30,LOW(100)
	CALL SUBOPT_0x2E
	RJMP _0x8C
; 0000 0248 case 0b00000011: maju(kec-70,kec);   x=1;      break;
_0x8D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8E
	CALL SUBOPT_0x2F
	RJMP _0x8C
; 0000 0249 case 0b00000111: maju(kec-70,kec);   x=1;      break;
_0x8E:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x8F
	CALL SUBOPT_0x2F
	RJMP _0x8C
; 0000 024A case 0b00000010: maju(kec-40,kec);   x=1;      break;
_0x8F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x90
	CALL SUBOPT_0x30
	RJMP _0x8C
; 0000 024B case 0b00000110: maju(kec-40,kec);   x=1;      break;
_0x90:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x91
	CALL SUBOPT_0x30
	RJMP _0x8C
; 0000 024C case 0b00001110: maju(kec-40,kec);   x=1;      break;
_0x91:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x92
	CALL SUBOPT_0x30
	RJMP _0x8C
; 0000 024D case 0b00000100: maju(kec-20,kec);   x=1;      break;
_0x92:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x93
	LD   R30,Y
	SUBI R30,LOW(20)
	CALL SUBOPT_0x2E
	RJMP _0x8C
; 0000 024E case 0b00001100: maju(kec-10,kec);   x=1;      break;
_0x93:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x94
	LD   R30,Y
	SUBI R30,LOW(10)
	CALL SUBOPT_0x2E
	RJMP _0x8C
; 0000 024F case 0b00001000: maju(kec,kec);                break;
_0x94:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x95
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _maju
	RJMP _0x8C
; 0000 0250 case 0b00011000: maju(kec,kec-10);   x=0;      break;
_0x95:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x96
	CALL SUBOPT_0x31
	RJMP _0x8C
; 0000 0251 case 0b00010000: maju(kec,kec-20);   x=0;      break;
_0x96:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x97
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	RJMP _0x8C
; 0000 0252 case 0b00111000: maju(kec,kec-40);   x=0;      break;
_0x97:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x98
	CALL SUBOPT_0x34
	RJMP _0x8C
; 0000 0253 case 0b00110000: maju(kec,kec-40);   x=0;      break;
_0x98:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x99
	CALL SUBOPT_0x34
	RJMP _0x8C
; 0000 0254 case 0b00100000: maju(kec,kec-40);   x=0;      break;
_0x99:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x9A
	CALL SUBOPT_0x34
	RJMP _0x8C
; 0000 0255 case 0b01110000: maju(kec,kec-70);   x=0;      break;
_0x9A:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x9B
	CALL SUBOPT_0x35
	RJMP _0x8C
; 0000 0256 case 0b01100000: maju(kec,kec-70);   x=0;      break;
_0x9B:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x9C
	CALL SUBOPT_0x35
	RJMP _0x8C
; 0000 0257 case 0b01000000: maju(kec,kec-100);   x=0;     break;// DOMINAN KIRI
_0x9C:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x9D
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
	SUBI R26,LOW(100)
	CALL SUBOPT_0x33
	RJMP _0x8C
; 0000 0258 case 0b00000000:
_0x9D:
	SBIW R30,0
	BRNE _0x8C
; 0000 0259 if(x==1) {
	SBRS R2,0
	RJMP _0x9F
; 0000 025A kiri(kec-20,kec);
	LD   R30,Y
	SUBI R30,LOW(20)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _kiri
; 0000 025B break;}
	RJMP _0x8C
; 0000 025C else  {
_0x9F:
; 0000 025D kanan(kec,kec-20);
	CALL SUBOPT_0x32
	RCALL _kanan
; 0000 025E break;}
; 0000 025F }
_0x8C:
; 0000 0260 }
	JMP  _0x20C0003
; .FEND
;void scan2(int kec)
; 0000 0262 {       cek_sensor();
_scan2:
; .FSTART _scan2
	CALL SUBOPT_0xD
;	kec -> Y+0
; 0000 0263 sensor=sensor & 0b00111110;
	LDS  R30,_sensor
	ANDI R30,LOW(0x3E)
	STS  _sensor,R30
; 0000 0264 switch(sensor)          //  1=kiri 8=kanan
	LDI  R31,0
; 0000 0265 {          //  7......1
; 0000 0266 case 0b00000010: maju(kec-140,kec);  x=1;      break;
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA4
	LD   R30,Y
	SUBI R30,LOW(140)
	CALL SUBOPT_0x2E
	RJMP _0xA3
; 0000 0267 case 0b00000110: maju(kec-70,kec);   x=1;      break;
_0xA4:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xA5
	CALL SUBOPT_0x2F
	RJMP _0xA3
; 0000 0268 case 0b00001110: maju(kec-40,kec);   x=1;      break;
_0xA5:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xA6
	CALL SUBOPT_0x30
	RJMP _0xA3
; 0000 0269 case 0b00000100: maju(kec-20,kec);   x=1;      break;
_0xA6:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xA7
	LD   R30,Y
	SUBI R30,LOW(20)
	CALL SUBOPT_0x2E
	RJMP _0xA3
; 0000 026A case 0b00001100: maju(kec-10,kec);   x=1;      break;
_0xA7:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xA8
	LD   R30,Y
	SUBI R30,LOW(10)
	CALL SUBOPT_0x2E
	RJMP _0xA3
; 0000 026B case 0b00011100: maju(kec,kec+3);              break;
_0xA8:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xA9
	CALL SUBOPT_0x36
	RJMP _0x199
; 0000 026C case 0b00001000: maju(kec,kec+3);              break;
_0xA9:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xAA
	CALL SUBOPT_0x36
	RJMP _0x199
; 0000 026D case 0b00011000: maju(kec,kec-10);   x=0;      break;
_0xAA:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xAB
	CALL SUBOPT_0x31
	RJMP _0xA3
; 0000 026E case 0b00010000: maju(kec,kec-20);   x=0;      break;
_0xAB:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xAC
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	RJMP _0xA3
; 0000 026F case 0b00111000: maju(kec,kec-40);   x=0;      break;
_0xAC:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xAD
	CALL SUBOPT_0x34
	RJMP _0xA3
; 0000 0270 case 0b00110000: maju(kec,kec-70);   x=0;      break;
_0xAD:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xAE
	CALL SUBOPT_0x35
	RJMP _0xA3
; 0000 0271 case 0b00100000: maju(kec,kec-140);  x=0;      break;
_0xAE:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xAF
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
	SUBI R26,LOW(140)
	CALL SUBOPT_0x33
	RJMP _0xA3
; 0000 0272 case 0b01111111: maju(kec,kec);            break;
_0xAF:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BREQ _0x19A
; 0000 0273 case 0b00000000: maju(kec,kec+3);              break;
	SBIW R30,0
	BRNE _0xB1
	CALL SUBOPT_0x36
	RJMP _0x199
; 0000 0274 case 0b01101101: maju(kec,kec);            break;
_0xB1:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BREQ _0x19A
; 0000 0275 case 0b01111011: maju(kec,kec);            break;
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BREQ _0x19A
; 0000 0276 case 0b01011011: maju(kec,kec);            break;
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0xA3
_0x19A:
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
_0x199:
	RCALL _maju
; 0000 0277 
; 0000 0278 }
_0xA3:
; 0000 0279 }
	JMP  _0x20C0003
; .FEND
;void scan7ki(int brpkali,int kec1)
; 0000 027B {       cek_sensor();
;	brpkali -> Y+2
;	kec1 -> Y+0
; 0000 027C while (hitung<brpkali)
; 0000 027D {
; 0000 027E while ((sensor & 0b00000001)!=0b00000001)
; 0000 027F {cek_sensor();
; 0000 0280 scan2(kec1);
; 0000 0281 }
; 0000 0282 
; 0000 0283 while ((sensor & 0b00000001)==0b00000001)
; 0000 0284 {    cek_sensor();
; 0000 0285 lampu=0;
; 0000 0286 scan2(kec1);
; 0000 0287 if ((sensor & 0b00000001)!=0b00000001) {
; 0000 0288 hitung++;
; 0000 0289 lampu=1;
; 0000 028A };
; 0000 028B }
; 0000 028C };
; 0000 028D hitung=0;
; 0000 028E }
;void scan7ka(int brpkali,int kec1)
; 0000 0290 {      cek_sensor();
;	brpkali -> Y+2
;	kec1 -> Y+0
; 0000 0291 while (hitung<brpkali)
; 0000 0292 {
; 0000 0293 while ((sensor & 0b00100000)!=0b00100000)
; 0000 0294 {cek_sensor();
; 0000 0295 scan2(kec1);
; 0000 0296 }
; 0000 0297 
; 0000 0298 while ((sensor & 0b00100000)==0b00100000)
; 0000 0299 {    cek_sensor();
; 0000 029A lampu=0;
; 0000 029B scan2(kec1);
; 0000 029C if ((sensor & 0b00100000)!=0b00100000) {
; 0000 029D hitung++;
; 0000 029E lampu=1;
; 0000 029F };
; 0000 02A0 }
; 0000 02A1 };
; 0000 02A2 hitung=0;
; 0000 02A3 }
;void scan7ka2(int brpkali,int kec1)
; 0000 02A5 {       cek_sensor();
_scan7ka2:
; .FSTART _scan7ka2
	CALL SUBOPT_0xD
;	brpkali -> Y+2
;	kec1 -> Y+0
; 0000 02A6 while (hitung<brpkali)
_0xD1:
	CALL SUBOPT_0xE
	BRGE _0xD3
; 0000 02A7 {
; 0000 02A8 while ((sensor & 0b00100000)!=0b00100000)
_0xD4:
	CALL SUBOPT_0x37
	BREQ _0xD6
; 0000 02A9 {cek_sensor();
	CALL SUBOPT_0x10
; 0000 02AA scan(kec1);
; 0000 02AB }
	RJMP _0xD4
_0xD6:
; 0000 02AC 
; 0000 02AD while ((sensor & 0b00100000)==0b00100000)
_0xD7:
	CALL SUBOPT_0x37
	BRNE _0xD9
; 0000 02AE {    cek_sensor();
	CALL SUBOPT_0x11
; 0000 02AF lampu=0;
; 0000 02B0 scan(kec1);
; 0000 02B1 if ((sensor & 0b00100000)!=0b00100000) {
	CALL SUBOPT_0x37
	BREQ _0xDC
; 0000 02B2 hitung++;
	CALL SUBOPT_0x12
; 0000 02B3 lampu=1;
; 0000 02B4 };
_0xDC:
; 0000 02B5 }
	RJMP _0xD7
_0xD9:
; 0000 02B6 };
	RJMP _0xD1
_0xD3:
; 0000 02B7 hitung=0;
	RJMP _0x20C0005
; 0000 02B8 }
; .FEND
;void scan0(int brpkali,int kec1)
; 0000 02BA {      cek_sensor();
_scan0:
; .FSTART _scan0
	CALL SUBOPT_0xD
;	brpkali -> Y+2
;	kec1 -> Y+0
; 0000 02BB while (hitung<brpkali)
_0xDF:
	CALL SUBOPT_0xE
	BRGE _0xE1
; 0000 02BC {
; 0000 02BD while ((sensor & 0b01111111)!=0b00000000)
_0xE2:
	CALL SUBOPT_0x38
	BREQ _0xE4
; 0000 02BE {cek_sensor();
	CALL SUBOPT_0x39
; 0000 02BF scan2(kec1);
; 0000 02C0 }
	RJMP _0xE2
_0xE4:
; 0000 02C1 
; 0000 02C2 while ((sensor & 0b01111111)==0b00000000)
_0xE5:
	CALL SUBOPT_0x38
	BRNE _0xE7
; 0000 02C3 {    cek_sensor();
	RCALL _cek_sensor
; 0000 02C4 lampu=0;
	CBI  0x18,3
; 0000 02C5 scan2(kec1);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _scan2
; 0000 02C6 if ((sensor & 0b01111111)!=0b00000000) {
	CALL SUBOPT_0x38
	BREQ _0xEA
; 0000 02C7 hitung++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 02C8 lampu=1;
	SBI  0x18,3
; 0000 02C9 };
_0xEA:
; 0000 02CA }
	RJMP _0xE5
_0xE7:
; 0000 02CB };
	RJMP _0xDF
_0xE1:
; 0000 02CC hitung=0;
	RJMP _0x20C0005
; 0000 02CD }
; .FEND
;void scan0rem(int kec1)
; 0000 02CF {   cek_sensor();
_scan0rem:
; .FSTART _scan0rem
	CALL SUBOPT_0xD
;	kec1 -> Y+0
; 0000 02D0 while ((sensor & 0b01111111)!=0b00000000)
_0xED:
	CALL SUBOPT_0x38
	BREQ _0xEF
; 0000 02D1 {cek_sensor();
	CALL SUBOPT_0x39
; 0000 02D2 scan2(kec1);
; 0000 02D3 }
	RJMP _0xED
_0xEF:
; 0000 02D4 rem(100);
	CALL SUBOPT_0x8
; 0000 02D5 }
	JMP  _0x20C0003
; .FEND
;void scan7ki2(int brpkali,int kec1)
; 0000 02D8 {      cek_sensor();
_scan7ki2:
; .FSTART _scan7ki2
	CALL SUBOPT_0xD
;	brpkali -> Y+2
;	kec1 -> Y+0
; 0000 02D9 while (hitung<brpkali)
_0xF0:
	CALL SUBOPT_0xE
	BRGE _0xF2
; 0000 02DA {
; 0000 02DB while ((sensor & 0b00000001)!=0b00000001)
_0xF3:
	CALL SUBOPT_0x27
	BREQ _0xF5
; 0000 02DC {cek_sensor();
	CALL SUBOPT_0x10
; 0000 02DD scan(kec1);
; 0000 02DE }
	RJMP _0xF3
_0xF5:
; 0000 02DF 
; 0000 02E0 while ((sensor & 0b00000001)==0b00000001)
_0xF6:
	CALL SUBOPT_0x27
	BRNE _0xF8
; 0000 02E1 {    cek_sensor();
	CALL SUBOPT_0x11
; 0000 02E2 lampu=0;
; 0000 02E3 scan(kec1);
; 0000 02E4 if ((sensor & 0b00000001)!=0b00000001) {
	CALL SUBOPT_0x27
	BREQ _0xFB
; 0000 02E5 hitung++;
	CALL SUBOPT_0x12
; 0000 02E6 lampu=1;
; 0000 02E7 };
_0xFB:
; 0000 02E8 }
	RJMP _0xF6
_0xF8:
; 0000 02E9 };
	RJMP _0xF0
_0xF2:
; 0000 02EA hitung=0;
_0x20C0005:
	CLR  R4
	CLR  R5
; 0000 02EB }
_0x20C0006:
	ADIW R28,4
	RET
; .FEND
;void cekdatasensor()
; 0000 02EE {
; 0000 02EF for(i=0;i<7;i++)
; 0000 02F0 {
; 0000 02F1 lcd_gotoxy(0,0);
; 0000 02F2 sprintf(buff,"data ke = %d ",i);
; 0000 02F3 lcd_puts(buff);
; 0000 02F4 
; 0000 02F5 lcd_gotoxy(0,1);
; 0000 02F6 sprintf(buff,"sensing = %d  ",read_adc(i));
; 0000 02F7 lcd_puts(buff);
; 0000 02F8 delay_ms(1000);
; 0000 02F9 }
; 0000 02FA }
;void parkir()
; 0000 02FD {  lampu=0; while(1){rem(100);} }
_parkir:
; .FSTART _parkir
	CBI  0x18,3
_0x103:
	CALL SUBOPT_0x8
	RJMP _0x103
; .FEND
;void maju_cari_garis(int brpkali,int kec1)
; 0000 0300 {
; 0000 0301 cek_sensor(); maju(kec1,kec1);
;	brpkali -> Y+2
;	kec1 -> Y+0
; 0000 0302 while (hitung<brpkali) {
; 0000 0303 while ((sensor & 0b0011100)!=0b0011100)
; 0000 0304 {cek_sensor();
; 0000 0305 maju(kec1,kec1);
; 0000 0306 }
; 0000 0307 while ((sensor & 0b0011100)==0b0011100)
; 0000 0308 {    cek_sensor();
; 0000 0309 lampu=0;
; 0000 030A maju(kec1,kec1);
; 0000 030B if ((sensor & 0b0011100)!=0b0011100) {
; 0000 030C hitung++;
; 0000 030D lampu=1;
; 0000 030E };
; 0000 030F }
; 0000 0310 };
; 0000 0311 hitung=0;
; 0000 0312 }
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0319 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 031A TCNT0=0x96; //BE
	LDI  R30,LOW(150)
	OUT  0x32,R30
; 0000 031B a++;
	LDS  R30,_a
	SUBI R30,-LOW(1)
	STS  _a,R30
; 0000 031C if    (a<=pos_servo1)      {servo1=0;}
	LDS  R30,_pos_servo1
	LDS  R26,_a
	CP   R30,R26
	BRLO _0x114
	CBI  0x15,6
; 0000 031D else                      {servo1=1; }
	RJMP _0x117
_0x114:
	SBI  0x15,6
_0x117:
; 0000 031E if    (a<=pos_servo2)      {servo2=0;}
	LDS  R30,_pos_servo2
	LDS  R26,_a
	CP   R30,R26
	BRLO _0x11A
	CBI  0x15,7
; 0000 031F else                      {servo2=1; }
	RJMP _0x11D
_0x11A:
	SBI  0x15,7
_0x11D:
; 0000 0320 
; 0000 0321 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;int bacawarna()
; 0000 0323 {
_bacawarna:
; .FSTART _bacawarna
; 0000 0324 nilai_warna=read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	MOV  R10,R30
	CLR  R11
; 0000 0325 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0326 sprintf(buff,"%d   ",nadc7);
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,136
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x3A
; 0000 0327 lcd_puts(buff);
; 0000 0328 delay_ms(100);
	CALL SUBOPT_0x1E
; 0000 0329 
; 0000 032A if(nilai_warna>=lowK &&  nilai_warna<=highK){
	LDS  R30,_lowK
	LDS  R31,_lowK+1
	CP   R10,R30
	CPC  R11,R31
	BRLO _0x121
	LDS  R30,_highK
	LDS  R31,_highK+1
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x122
_0x121:
	RJMP _0x120
_0x122:
; 0000 032B lcd_gotoxy(0,0);lcd_putsf("KUNING   ");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,142
	CALL _lcd_putsf
; 0000 032C hasilwarna='K';
	LDI  R30,LOW(75)
	RJMP _0x19B
; 0000 032D }
; 0000 032E 
; 0000 032F else if(nilai_warna>=lowB &&  nilai_warna<=highB){
_0x120:
	LDS  R30,_lowB
	LDS  R31,_lowB+1
	CP   R10,R30
	CPC  R11,R31
	BRLO _0x125
	LDS  R30,_highB
	LDS  R31,_highB+1
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x126
_0x125:
	RJMP _0x124
_0x126:
; 0000 0330 lcd_gotoxy(0,0);lcd_putsf("BIRU     ");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,152
	CALL _lcd_putsf
; 0000 0331 hasilwarna='B';
	LDI  R30,LOW(66)
	RJMP _0x19B
; 0000 0332 }
; 0000 0333 
; 0000 0334 else if(nilai_warna>=lowM &&  nilai_warna<=highM){
_0x124:
	__CPWRR 10,11,12,13
	BRLO _0x129
	LDS  R30,_highM
	LDS  R31,_highM+1
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x12A
_0x129:
	RJMP _0x128
_0x12A:
; 0000 0335 lcd_gotoxy(0,0);lcd_putsf("MERAH    ");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,162
	CALL _lcd_putsf
; 0000 0336 hasilwarna='M';
	LDI  R30,LOW(77)
	RJMP _0x19B
; 0000 0337 }
; 0000 0338 
; 0000 0339 else if(nilai_warna>=lowH &&  nilai_warna<=highH){
_0x128:
	LDS  R30,_lowH
	LDS  R31,_lowH+1
	CP   R10,R30
	CPC  R11,R31
	BRLO _0x12D
	LDS  R30,_highH
	LDS  R31,_highH+1
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x12E
_0x12D:
	RJMP _0x12C
_0x12E:
; 0000 033A lcd_gotoxy(0,0);lcd_putsf("HIJAU    ");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,172
	CALL _lcd_putsf
; 0000 033B hasilwarna='H';
	LDI  R30,LOW(72)
	RJMP _0x19B
; 0000 033C }
; 0000 033D else { hasilwarna='X';}
_0x12C:
	LDI  R30,LOW(88)
_0x19B:
	STS  _hasilwarna,R30
; 0000 033E return(hasilwarna);
	LDI  R31,0
	RET
; 0000 033F }
; .FEND
;void scantime(int waktu,int kec1)
; 0000 0341 {      cek_sensor();
;	waktu -> Y+2
;	kec1 -> Y+0
; 0000 0342 
; 0000 0343 while (hitung<waktu) {
; 0000 0344 scan(kec1);
; 0000 0345 hitung++;
; 0000 0346 delay_ms(10);
; 0000 0347 }
; 0000 0348 hitung=0;
; 0000 0349 }
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 034C {
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
; 0000 034D // Place your code here
; 0000 034E }
	RETI
; .FEND
;void main(void)
; 0000 0350 {
_main:
; .FSTART _main
; 0000 0351 // Declare your local variables here
; 0000 0352 
; 0000 0353 // Input/Output Ports initialization
; 0000 0354 // Port A initialization
; 0000 0355 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0356 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0357 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0358 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0359 
; 0000 035A // Port B initialization
; 0000 035B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 035C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 035D PORTB=0x08;
	LDI  R30,LOW(8)
	OUT  0x18,R30
; 0000 035E DDRB=0Xff;//0x08;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 035F 
; 0000 0360 // Port C initialization
; 0000 0361 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0362 // State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P
; 0000 0363 PORTC=0xFF;
	OUT  0x15,R30
; 0000 0364 DDRC=0xF0; //C0
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 0365 
; 0000 0366 // Port D initialization
; 0000 0367 // Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0368 // State7=T State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0369 PORTD=0x01;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 036A DDRD=0xFE; //3F
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 036B 
; 0000 036C // Timer/Counter 0 initialization
; 0000 036D TCCR0=0x4A;
	LDI  R30,LOW(74)
	OUT  0x33,R30
; 0000 036E TCNT0=0x96;
	LDI  R30,LOW(150)
	OUT  0x32,R30
; 0000 036F OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0370 
; 0000 0371 // Timer/Counter 1 initialization
; 0000 0372 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0373 TCCR1B=0x09;
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 0374 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0375 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0376 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0377 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0378 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0379 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 037A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 037B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 037C 
; 0000 037D // Timer/Counter 2 initialization
; 0000 037E // Clock source: System Clock
; 0000 037F // Clock value: Timer 2 Stopped
; 0000 0380 // Mode: Normal top=FFh
; 0000 0381 // OC2 output: Disconnected
; 0000 0382 ASSR=0x00;
	OUT  0x22,R30
; 0000 0383 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0384 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0385 OCR2=0x00;
	OUT  0x23,R30
; 0000 0386 
; 0000 0387 // External Interrupt(s) initialization
; 0000 0388 // INT0: Off
; 0000 0389 // INT1: Off
; 0000 038A // INT2: Off
; 0000 038B MCUCR=0x00;
	OUT  0x35,R30
; 0000 038C MCUCSR=0x00;
	OUT  0x34,R30
; 0000 038D 
; 0000 038E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 038F TIMSK=0x03;
	LDI  R30,LOW(3)
	OUT  0x39,R30
; 0000 0390 
; 0000 0391 // Analog Comparator initialization
; 0000 0392 // Analog Comparator: Off
; 0000 0393 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0394 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0395 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0396 
; 0000 0397 
; 0000 0398 
; 0000 0399 MCUCR=0x00;
	OUT  0x35,R30
; 0000 039A MCUCSR=0x00;
	OUT  0x34,R30
; 0000 039B 
; 0000 039C ////USART, UNTUK KOMUNIKASI BLUETOOTH
; 0000 039D //UCSRA=0x00;
; 0000 039E //UCSRB=0x18;
; 0000 039F //UCSRC=0x86;
; 0000 03A0 //UBRRH=0x00;
; 0000 03A1 //UBRRL=0x47;
; 0000 03A2 // USART initialization
; 0000 03A3 // USART disabled
; 0000 03A4 UCSRB=0x00;
	OUT  0xA,R30
; 0000 03A5 
; 0000 03A6 // ADC initialization
; 0000 03A7 // ADC Clock frequency: 691.200 kHz
; 0000 03A8 // ADC Voltage Reference: AVCC pin
; 0000 03A9 // ADC Auto Trigger Source: None
; 0000 03AA // Only the 8 most significant bits of
; 0000 03AB // the AD conversion result are used
; 0000 03AC ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 03AD ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 03AE //ADCSRA=0xA6;
; 0000 03AF SFIOR&=0x1F;
	IN   R30,0x30
	ANDI R30,LOW(0x1F)
	OUT  0x30,R30
; 0000 03B0 
; 0000 03B1 // LCD module initialization
; 0000 03B2 lcd_init(16); //
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 03B3 lcd_clear();//
	CALL _lcd_clear
; 0000 03B4 lampu=0;    //
	CBI  0x18,3
; 0000 03B5 //k,b
; 0000 03B6 lcd_gotoxy(0,0);
	CALL SUBOPT_0x19
; 0000 03B7 lcd_putsf("FF OnlineShop");
	__POINTW2FN _0x0,182
	CALL _lcd_putsf
; 0000 03B8 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 03B9 lcd_putsf("Robot ATMega16A");
	__POINTW2FN _0x0,196
	CALL _lcd_putsf
; 0000 03BA delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 03BB lcd_clear();
	CALL _lcd_clear
; 0000 03BC 
; 0000 03BD 
; 0000 03BE // PROGRAM UTAMA
; 0000 03BF // Global enable interrupts
; 0000 03C0 #asm("sei")
	SEI
; 0000 03C1 if(t1==0)
	SBIC 0x13,0
	RJMP _0x135
; 0000 03C2 {    scan_garis(10); delay_ms(1500); maju(160,160); delay_ms(200); rem(100);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _scan_garis
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
	LDI  R30,LOW(160)
	ST   -Y,R30
	LDI  R26,LOW(160)
	RCALL _maju
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x8
; 0000 03C3 scan_back(10); hit_tengah(10); lcd_clear();
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _scan_back
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _hit_tengah
	CALL _lcd_clear
; 0000 03C4 }
; 0000 03C5 lengan_atas;
_0x135:
	LDI  R30,LOW(226)
	STS  _pos_servo2,R30
; 0000 03C6 capit_lepas;
	LDI  R30,LOW(243)
	STS  _pos_servo1,R30
; 0000 03C7 
; 0000 03C8 while (1)
_0x136:
; 0000 03C9 {
; 0000 03CA 
; 0000 03CB 
; 0000 03CC if(t1==0)
	SBIC 0x13,0
	RJMP _0x139
; 0000 03CD {
; 0000 03CE ///PORGRAM TES BACA WARNA
; 0000 03CF lengan_bawah;
	LDI  R30,LOW(247)
	STS  _pos_servo2,R30
; 0000 03D0 while(1){
_0x13A:
; 0000 03D1 bacawarna();
	RCALL _bacawarna
; 0000 03D2 if(hasilwarna=='K'){
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x4B)
	BRNE _0x13D
; 0000 03D3 lcd_gotoxy(0,0);lcd_putsf("KUNING   ");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,142
	RJMP _0x19C
; 0000 03D4 
; 0000 03D5 }
; 0000 03D6 
; 0000 03D7 else if(hasilwarna=='B'){
_0x13D:
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x42)
	BRNE _0x13F
; 0000 03D8 lcd_gotoxy(0,0);lcd_putsf("BIRU     ");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,152
	RJMP _0x19C
; 0000 03D9 //progam biru
; 0000 03DA }
; 0000 03DB 
; 0000 03DC else if(hasilwarna=='M'){
_0x13F:
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x4D)
	BRNE _0x141
; 0000 03DD lcd_gotoxy(0,0);lcd_putsf("MERAH    ");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,162
	RJMP _0x19C
; 0000 03DE //progam merah
; 0000 03DF }
; 0000 03E0 
; 0000 03E1 else if(hasilwarna=='H'){
_0x141:
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x48)
	BRNE _0x143
; 0000 03E2 lcd_gotoxy(0,0);lcd_putsf("HIJAU    ");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,172
_0x19C:
	CALL _lcd_putsf
; 0000 03E3 //progam hijau
; 0000 03E4 }
; 0000 03E5 }
_0x143:
	RJMP _0x13A
; 0000 03E6 
; 0000 03E7 
; 0000 03E8 
; 0000 03E9 }
; 0000 03EA 
; 0000 03EB if(t2==0)
_0x139:
	SBIC 0x13,1
	RJMP _0x144
; 0000 03EC { mulai=mulai+1; delay_ms(200); lampu=0;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x18,3
; 0000 03ED lcd_gotoxy(0,0);lcd_putsf("mulai cek point:");
	CALL SUBOPT_0x19
	__POINTW2FN _0x0,212
	CALL SUBOPT_0x1A
; 0000 03EE lcd_gotoxy(0,1); sprintf(buff,"%d  ",mulai); lcd_puts(buff);
	__POINTW1FN _0x0,50
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CALL __CWD1
	CALL SUBOPT_0x3A
; 0000 03EF if (mulai>=20)mulai=0;}
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x147
	CLR  R6
	CLR  R7
_0x147:
; 0000 03F0 
; 0000 03F1 if(t3==0)
_0x144:
	SBIC 0x13,2
	RJMP _0x148
; 0000 03F2 {  lcd_clear(); lampu=1;
	CALL _lcd_clear
	SBI  0x18,3
; 0000 03F3 while(1)
_0x14B:
; 0000 03F4 {   switch(mulai)
	MOVW R30,R6
; 0000 03F5 {
; 0000 03F6 case 1: goto satu3; break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x152
; 0000 03F7 case 2: goto dua3; break;
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x153
	RJMP _0x154
; 0000 03F8 case 3: goto tiga3; break;
_0x153:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x155
	RJMP _0x156
; 0000 03F9 case 4: goto empat3; break;
_0x155:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x157
	RJMP _0x158
; 0000 03FA case 5: goto lima3; break;
_0x157:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x159
	RJMP _0x15A
; 0000 03FB case 6: goto enam3; break;
_0x159:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x15B
	RJMP _0x15C
; 0000 03FC case 7: goto tujuh3; break;
_0x15B:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x15D
	RJMP _0x15E
; 0000 03FD case 8: goto delapan3; break;
_0x15D:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x15F
	RJMP _0x160
; 0000 03FE case 9: goto sembilan3; break;
_0x15F:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x161
	RJMP _0x162
; 0000 03FF case 10: goto sepuluh3; break;
_0x161:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ _0x164
; 0000 0400 }
; 0000 0401 
; 0000 0402 
; 0000 0403 satu3:
_0x152:
; 0000 0404 scanX(1, 180);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3B
; 0000 0405 rem(1000);
; 0000 0406 belki(170,170);
	CALL SUBOPT_0x3C
; 0000 0407 rem(1000);
; 0000 0408 scanX(5, 180);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3B
; 0000 0409 rem(1000);
; 0000 040A belka(170,170);
	CALL SUBOPT_0x3D
; 0000 040B rem(1000);
; 0000 040C scanX(5, 180);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(180)
	LDI  R27,0
	RCALL _scanX
; 0000 040D rem(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _rem
; 0000 040E mundur(150,1000);
	LDI  R30,LOW(150)
	ST   -Y,R30
	LDI  R26,LOW(232)
	RCALL _mundur
; 0000 040F belka(170,170);
	CALL SUBOPT_0x6
	CALL SUBOPT_0x3D
; 0000 0410 rem(1000);
; 0000 0411 scanX(3, 180);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x3B
; 0000 0412 rem(1000);
; 0000 0413 belki(170,170);
	CALL SUBOPT_0x3C
; 0000 0414 rem(1000);
; 0000 0415 scanX(3, 180);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x3B
; 0000 0416 rem(1000);
; 0000 0417 belka(170,170);
	CALL SUBOPT_0x3D
; 0000 0418 rem(1000);
; 0000 0419 belki(170,170);
	CALL SUBOPT_0x6
	CALL SUBOPT_0x3C
; 0000 041A rem(1000);
; 0000 041B scanX(2, 180);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3B
; 0000 041C rem(1000);
; 0000 041D belka(170,170);
	CALL SUBOPT_0x3D
; 0000 041E rem(1000);
; 0000 041F scanX(1, 100);
	CALL SUBOPT_0x2
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _scanX
; 0000 0420 parkir();
	RCALL _parkir
; 0000 0421 
; 0000 0422 
; 0000 0423 dua3:
_0x154:
; 0000 0424 
; 0000 0425 tiga3:
_0x156:
; 0000 0426 
; 0000 0427 empat3:
_0x158:
; 0000 0428 
; 0000 0429 lima3:
_0x15A:
; 0000 042A 
; 0000 042B enam3:
_0x15C:
; 0000 042C 
; 0000 042D tujuh3:
_0x15E:
; 0000 042E 
; 0000 042F delapan3:
_0x160:
; 0000 0430 
; 0000 0431 sembilan3:
_0x162:
; 0000 0432 
; 0000 0433 sepuluh3:
_0x164:
; 0000 0434 
; 0000 0435 }
	RJMP _0x14B
; 0000 0436 }
; 0000 0437 
; 0000 0438 if(t4==0)  //start BIRU
_0x148:
	SBIC 0x13,3
	RJMP _0x165
; 0000 0439 {
; 0000 043A 
; 0000 043B lcd_clear(); lampu=1;
	CALL _lcd_clear
	SBI  0x18,3
; 0000 043C while(1)
_0x168:
; 0000 043D {   switch(mulai)
	MOVW R30,R6
; 0000 043E {
; 0000 043F case 1: cek_sensor(); goto satu4;  break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x16E
	RCALL _cek_sensor
	RJMP _0x16F
; 0000 0440 case 2: cek_sensor(); goto dua4; break;
_0x16E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x170
	RCALL _cek_sensor
	RJMP _0x171
; 0000 0441 case 3: cek_sensor(); goto tiga4;  break;
_0x170:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x172
	RCALL _cek_sensor
	RJMP _0x173
; 0000 0442 case 4: cek_sensor(); goto empat4;  break;
_0x172:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x174
	RCALL _cek_sensor
	RJMP _0x175
; 0000 0443 case 5: cek_sensor(); goto lima4;  break;
_0x174:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x176
	RCALL _cek_sensor
	RJMP _0x177
; 0000 0444 case 6: cek_sensor(); goto enam4;  break;
_0x176:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x16D
	RCALL _cek_sensor
	RJMP _0x179
; 0000 0445 }
_0x16D:
; 0000 0446 
; 0000 0447 satu4:
_0x16F:
; 0000 0448 while(1)
_0x17A:
; 0000 0449 {
; 0000 044A lampu=0;
	CBI  0x18,3
; 0000 044B mundur(190,190);
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(190)
	RCALL _mundur
; 0000 044C delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 044D scanmundur(195,195);
	LDI  R30,LOW(195)
	LDI  R31,HIGH(195)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(195)
	LDI  R27,0
	RCALL _scanmundur
; 0000 044E belki(160,160);
	CALL SUBOPT_0x2D
; 0000 044F rem(100);
	CALL SUBOPT_0x8
; 0000 0450 scanX(1,220);
	CALL SUBOPT_0x2
	LDI  R26,LOW(220)
	LDI  R27,0
	RCALL _scanX
; 0000 0451 rem(100);
	CALL SUBOPT_0x8
; 0000 0452 
; 0000 0453 enam4:
_0x179:
; 0000 0454 stepx:
; 0000 0455 ///////////////program misi
; 0000 0456 
; 0000 0457 belki(160,160);
	CALL SUBOPT_0x2D
; 0000 0458 //akhir
; 0000 0459 goto kirimx;
	RJMP _0x180
; 0000 045A 
; 0000 045B 
; 0000 045C ///////////////program lain
; 0000 045D stepz:
_0x181:
; 0000 045E lcd_kedip(10); parkir();
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _lcd_kedip
	RCALL _parkir
; 0000 045F 
; 0000 0460 
; 0000 0461 tiga4:
_0x173:
; 0000 0462 
; 0000 0463 
; 0000 0464 lima4:
_0x177:
; 0000 0465 
; 0000 0466 
; 0000 0467 
; 0000 0468 
; 0000 0469 dua4:
_0x171:
; 0000 046A 
; 0000 046B 
; 0000 046C empat4:
_0x175:
; 0000 046D 
; 0000 046E 
; 0000 046F }
	RJMP _0x17A
; 0000 0470 
; 0000 0471 nilai_warna=bacawarna();
; 0000 0472 //nilai berikut bukan ketentuan, disesuaikan dengan robot masing-masing
; 0000 0473 //hijau  204
; 0000 0474 //kuning   10
; 0000 0475 //kosong   156
; 0000 0476 //merah   51
; 0000 0477 if(nilai_warna>225 && nilai_warna<235){//jika kuning
; 0000 0478 //program warna kuning
; 0000 0479 
; 0000 047A scanX(1,180);
; 0000 047B rem(500);
; 0000 047C parkir();
; 0000 047D 
; 0000 047E }
; 0000 047F 
; 0000 0480 
; 0000 0481 if(nilai_warna>150 && nilai_warna<160){
; 0000 0482 
; 0000 0483 
; 0000 0484 }
; 0000 0485 
; 0000 0486 
; 0000 0487 if(nilai_warna>5 && nilai_warna<25){  //Jika Hijau
; 0000 0488 //program ketika warna hijau
; 0000 0489 
; 0000 048A }
; 0000 048B 
; 0000 048C 
; 0000 048D 
; 0000 048E while(1){
_0x18B:
; 0000 048F scanX(1,150);
	CALL SUBOPT_0x2
	LDI  R26,LOW(150)
	LDI  R27,0
	RCALL _scanX
; 0000 0490 parkir();
	RCALL _parkir
; 0000 0491 }
	RJMP _0x18B
; 0000 0492 
; 0000 0493 
; 0000 0494 
; 0000 0495 
; 0000 0496 kirimx:
_0x180:
; 0000 0497 if(hasilwarna=='K'){
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x4B)
	BRNE _0x18E
; 0000 0498 arah2kuningkecil();
	RCALL _arah2kuningkecil
; 0000 0499 goto stepz;
	RJMP _0x181
; 0000 049A }
; 0000 049B 
; 0000 049C else if(hasilwarna=='B'){
_0x18E:
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x42)
	BRNE _0x190
; 0000 049D arah2new();
	RCALL _arah2new
; 0000 049E goto stepz;
	RJMP _0x181
; 0000 049F }
; 0000 04A0 
; 0000 04A1 else if(hasilwarna=='M'){
_0x190:
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x4D)
	BRNE _0x192
; 0000 04A2 arah2merah();
	RCALL _arah2merah
; 0000 04A3 goto stepz;
	RJMP _0x181
; 0000 04A4 }
; 0000 04A5 
; 0000 04A6 else if(hasilwarna=='H'){
_0x192:
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x48)
	BRNE _0x194
; 0000 04A7 arah2hijau();
	RCALL _arah2hijau
; 0000 04A8 goto stepz;
	RJMP _0x181
; 0000 04A9 }
; 0000 04AA else if(hasilwarna=='X'){
_0x194:
	LDS  R26,_hasilwarna
	CPI  R26,LOW(0x58)
	BRNE _0x196
; 0000 04AB bacawarna();  //ulangi
	RCALL _bacawarna
; 0000 04AC arah2hijau(); //mencoba mengirim barang dengan mendapatkan minimal poin
	RCALL _arah2hijau
; 0000 04AD goto stepz;
	RJMP _0x181
; 0000 04AE }
; 0000 04AF 
; 0000 04B0 }
_0x196:
	RJMP _0x168
; 0000 04B1 
; 0000 04B2 }
; 0000 04B3 
; 0000 04B4 }
_0x165:
	RJMP _0x136
; 0000 04B5 
; 0000 04B6 }
_0x197:
	RJMP _0x197
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x3E
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x3E
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x3F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x40
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x41
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x41
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x3F
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x3F
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x3E
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x40
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x40
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G103:
; .FSTART __lcd_delay_G103
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G103
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
; .FEND
__lcd_read_nibble_G103:
; .FSTART __lcd_read_nibble_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G103:
; .FSTART _lcd_read_byte0_G103
	CALL __lcd_delay_G103
	RCALL __lcd_read_nibble_G103
    mov   r26,r30
	RCALL __lcd_read_nibble_G103
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0003:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060005
_0x2060007:
	RJMP _0x20C0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G103:
; .FSTART __long_delay_G103
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G103:
; .FSTART __lcd_init_write_G103
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	CALL SUBOPT_0x42
	CALL SUBOPT_0x42
	CALL SUBOPT_0x42
	RCALL __long_delay_G103
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R26,LOW(40)
	CALL SUBOPT_0x43
	LDI  R26,LOW(4)
	CALL SUBOPT_0x43
	LDI  R26,LOW(133)
	CALL SUBOPT_0x43
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G103
	CPI  R30,LOW(0x5)
	BREQ _0x206000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x206000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_highM:
	.BYTE 0x2
_lowK:
	.BYTE 0x2
_highK:
	.BYTE 0x2
_lowH:
	.BYTE 0x2
_highH:
	.BYTE 0x2
_lowB:
	.BYTE 0x2
_highB:
	.BYTE 0x2
_buff:
	.BYTE 0x21
_hasilwarna:
	.BYTE 0x1
_i:
	.BYTE 0x2
_pos_servo1:
	.BYTE 0x1
_pos_servo2:
	.BYTE 0x1
_a:
	.BYTE 0x1

	.ESEG
_garis:
	.BYTE 0x14
_back:
	.BYTE 0x14
_tengah:
	.BYTE 0x14

	.DSEG
_sen:
	.BYTE 0xA
_sensor:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	STS  _pos_servo1,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	STS  _pos_servo2,R30
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(185)
	LDI  R27,0
	JMP  _scanX

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x5:
	LDI  R27,0
	CALL _scan0
	LDI  R26,LOW(170)
	LDI  R27,0
	CALL _scan0rem
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _rem
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(160)
	LDI  R27,0
	CALL _scanmundur
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _rem

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(170)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _scan7ki2

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _rem

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(190)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(160)
	ST   -Y,R30
	LDI  R26,LOW(160)
	CALL _mundur
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(160)
	LDI  R27,0
	JMP  _belka

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(160)
	LDI  R27,0
	JMP  _belka2

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xD:
	ST   -Y,R27
	ST   -Y,R26
	JMP  _cek_sensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R4,R30
	CPC  R5,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R30,_sensor
	ANDI R30,LOW(0x1C)
	CPI  R30,LOW(0x1C)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	CALL _cek_sensor
	LD   R26,Y
	LDD  R27,Y+1
	JMP  _scan

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	CALL _cek_sensor
	CBI  0x18,3
	LD   R26,Y
	LDD  R27,Y+1
	JMP  _scan

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
	SBI  0x18,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LD   R26,Y
	LDD  R27,Y+1
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x16:
	LDS  R26,_i
	CALL _read_adc
	MOV  R0,R30
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(_tengah)
	LDI  R27,HIGH(_tengah)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOV  R26,R0
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDS  R30,_i
	LDS  R31,_i+1
	SUBI R30,LOW(-_sen)
	SBCI R31,HIGH(-_sen)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1A:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	ST   -Y,R27
	ST   -Y,R26
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1F:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	OUT  0x28+1,R31
	OUT  0x28,R30
	LDD  R30,Y+1
	LDI  R31,0
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x20:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_garis)
	LDI  R27,HIGH(_garis)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CALL __EEPROMWRW
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	__POINTW1FN _0x0,38
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x20
	CALL __CWD1
	CALL __PUTPARD1
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x24:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x20
	LDI  R26,LOW(_back)
	LDI  R27,HIGH(_back)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x20
	LDI  R26,LOW(_tengah)
	LDI  R27,HIGH(_tengah)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	LDS  R30,_sensor
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	CALL _cek_sensor
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+1
	JMP  _kiri

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDS  R30,_sensor
	ANDI R30,LOW(0x40)
	CPI  R30,LOW(0x40)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2A:
	CALL _cek_sensor
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+1
	JMP  _kanan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	CALL _cek_sensor
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+1
	JMP  _mundur

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(180)
	LDI  R27,0
	JMP  _belki2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(160)
	LDI  R27,0
	JMP  _belki

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2E:
	ST   -Y,R30
	LDD  R26,Y+1
	CALL _maju
	SET
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LD   R30,Y
	SUBI R30,LOW(70)
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LD   R30,Y
	SUBI R30,LOW(40)
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
	SUBI R26,LOW(10)
	CALL _maju
	CLT
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
	SUBI R26,LOW(20)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x33:
	CALL _maju
	CLT
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x34:
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
	SUBI R26,LOW(40)
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
	SUBI R26,LOW(70)
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+1
	SUBI R26,-LOW(3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDS  R30,_sensor
	ANDI R30,LOW(0x20)
	CPI  R30,LOW(0x20)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	LDS  R30,_sensor
	ANDI R30,0x7F
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	CALL _cek_sensor
	LD   R26,Y
	LDD  R27,Y+1
	JMP  _scan2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(180)
	LDI  R27,0
	CALL _scanX
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _rem
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	CALL _belki
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _rem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	CALL _belka
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _rem

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3E:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x41:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	CALL __long_delay_G103
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	CALL __lcd_write_data
	JMP  __long_delay_G103

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xACD
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
