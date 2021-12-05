ORG 100H
INCLUDE 'EMU8086.INC'
.MODEL SMALL
.STACK 100H
.DATA
    N DB 0
.CODE  


;----------------------------MAIN-----------------------------
MAIN PROC
    
    MOV AX,@DATA           ;INITIALIZATION
    MOV DS,AX
    XOR CX,CX
    XOR DX,DX
    
    CALL DECIMAL_INPUT     ;NUMBER IS SAVED IN DL  
    CALL MONEY_TO_SEC      ;SECONDS ARE SAVED IN AL
    CALL TIMER             ;TIMER COUNTDOWN   
    RET
MAIN ENDP   
;-------------------------------------------------------------




;-------------------DECIMAL INPUT PROC------------------------  

;THIS PROCEDURE ASKS THE USER TO INPUT DECIMAL NUMBER
;AND STORES IT AT DL 


DECIMAL_INPUT PROC
    PRINT "ENTER MONEY (MAX 43$): " ;MAX 43$ BECAUSE IT WILL
                                    ;PROVIDE MAX TIME (255 SEC)
    FOR:
        MOV AH,1
        INT 21H
        CMP AL,0DH
        JE  END_FOR
        SUB AL,48
        MOV N,AL
        MOV AL,10
        MUL DL
        ADD AL,N
        MOV DL,AL
        JMP FOR
    END_FOR:
    RET
DECIMAL_INPUT ENDP 
;-------------------------------------------------------------





;--------------------MONEY TO SEC PROC------------------------
;THIS PROCEDURE CALCULATES THE TOTAL TIME ALLOWED FOR PARKING 
;ACORDING TO THE MONEY   1$-->5SEC  5$-->30SEC  10$-->60SEC
;AND STORES IT AT AL

MONEY_TO_SEC PROC   
    XOR AX,AX
    L1:
       CMP DL,0AH
       JL  L2
       ADD AL,3CH
       SUB DL,0AH
       JMP L1
    L2:
       CMP DL,05H
       JL  L3
       ADD AL,1EH
       SUB DL,05H
       JMP L2
    L3: 
       CMP DL,00H
       JZ  END_L 
       ADD AL,05H
       SUB DL,01H
       JMP L3  
    END_L:
          RET
MONEY_TO_SEC ENDP
;-------------------------------------------------------------





;--------------------------TIMER------------------------------ 
;THIS PROSECURE DISPLAY THE TIME LEFT FOR PARKING THE CAR (IN SEC)
                  
TIMER PROC
                       
    #start=led_display.exe#
    DELAY:
          OUT  199,AX
          MOV  CX,0110H
          LOOP $             ;DELAY LOOP APROX 1 SEC
          DEC  AX
          CMP  AX,0000H
          JL   END_DELAY
          JMP  DELAY
    END_DELAY:
              RET
TIMER ENDP
;-------------------------------------------------------------