.MODEL SMALL
.STACK 100H
.DATA      

;initial keymap
A1 DB ?
A2 DB ?
A3 DB ?
B1 DB ?
B2 DB ?
B3 DB ?
C1 DB ?
C2 DB ?
C3 DB ?
   

;printing 
SPACES DB '          $'
SDS DB 32,179,32,'$'      ;prints ' | ' 
NEWLINE DB 13,10,'$'  
NEWLINES DB 13,10,10,10,10,10,'$'   ;five new lines
DASHES DB 13,10,'          -----------         |          -----------$'
COORDINATES DB 13,10,'          TIC-TAC-TOE         |          COORDINATES$'   
CORD0 DB 13,10,'                              |                     $'   
CORD1 DB '          |           1 | 2 | 3 $'
CORD2 DB '          |           4 | 5 | 6 $'
CORD3 DB '          |           7 | 8 | 9 $'
                    

;messages   
WELCOME DB '                    Welcome to TIC-TAC-TOE$'          
EXIT_INSTRUCTION DB 13,10,'Enter 0 to exit.$'                
INSTRUCTION1 DB 13,10,'(PLAYER 1) Enter a coordinate to play (1-9): $'    
INSTRUCTION2 DB 13,10,'(PLAYER 2) Enter a coordinate to play (1-9): $'
INV_INPUT DB 13,10,10,'Input must be a number between 1-9. Try again.$'
OVERWRITE DB 13,10,10,'Coordinate is not empty. Try again.$'  
GAME_OVER_MSG DB 13,10,10,'Game Over. Nobody wins.$' 
OP2 DB 13,10,'Enter any other key to play again.$'

;win & draw message
WIN_P1 DB 13,10,10,'Game over. (Player 1) wins.$'
WIN_P2 DB 13,10,10,'Game over. (Player 2) wins.$' 
DRAWMSG DB 13,10,10,"Game over. It's a draw.$"


;LOGIC    
SIGN DB 'o'     ;move sign
FILLED DB 0     ;number of positions filled

.CODE
 MAIN PROC
     MOV AX,@DATA
     MOV DS,AX  
     
     ;-----------------------------WELCOME MESSAGE-----------------------------
     MOV AH,9   
     LEA DX,NEWLINE
     INT 21H
     LEA DX,WELCOME
     INT 21H
     
     ;-----------------------------Initialize all values-----------------------------
     INITIALIZE:
     MOV A1,'-'
     MOV A2,'-'
     MOV A3,'-'
     MOV B1,'-'
     MOV B2,'-'
     MOV B3,'-'
     MOV C1,'-'
     MOV C2,'-'
     MOV C3,'-'  
     MOV SIGN, 'o'
     MOV BL,'x'
     MOV FILLED,0
     
     ;NOTE:
     ;BL FOR alternating X,0
     ;BH,CH,CL FOR WIN CONDITION  

     ;;;;;;;;;;;      
      
     ; 0 | 0 | 0
     ;-----------
     ; 0 | 0 | 0
     ;-----------
     ; 0 | 0 | 0
     ;;;;;;;;;;;
     
     
     ;-----------------------------Printing the game screen-----------------------------
     
     GAME_SCR:   
     MOV AH,9    
     LEA DX,NEWLINES
     INT 21H       
     LEA DX,COORDINATES
     INT 21H   
     LEA DX,CORD0  
     INT 21H
     INT 21H
     LEA DX,NEWLINE    
     INT 21H
     
     
     ;ROW 1
     MOV AH,9
     LEA DX,SPACES
     INT 21H
     
     MOV AH,2
     MOV DL,32
     INT 21H
     MOV DL,A1
     INT 21H   
     MOV AH,9
     LEA DX,SDS
     INT 21H  
     MOV AH,2
     MOV DL,A2
     INT 21H
     MOV AH,9
     LEA DX,SDS
     INT 21H
     MOV AH,2  
     MOV DL,A3
     INT 21H  
      
     MOV AH,9  
     LEA DX,CORD1
     INT 21H
     LEA DX,DASHES
     INT 21H 
     LEA DX,NEWLINE
     INT 21H         
     
     ;ROW 2
     MOV AH,9
     LEA DX,SPACES
     INT 21H
     
     MOV AH,2
     MOV DL,32
     INT 21H
     MOV DL,B1
     INT 21H   
     MOV AH,9
     LEA DX,SDS
     INT 21H  
     MOV AH,2
     MOV DL,B2
     INT 21H
     MOV AH,9
     LEA DX,SDS
     INT 21H
     MOV AH,2  
     MOV DL,B3
     INT 21H   
      
     MOV AH,9
     LEA DX,CORD2
     INT 21H
     LEA DX,DASHES
     INT 21H 
     LEA DX,NEWLINE
     INT 21H    
     
     ;ROW 3
     MOV AH,9
     LEA DX,SPACES
     INT 21H
     
     MOV AH,2
     MOV DL,32
     INT 21H
     MOV DL,C1
     INT 21H   
     MOV AH,9
     LEA DX,SDS
     INT 21H  
     MOV AH,2
     MOV DL,C2
     INT 21H
     MOV AH,9
     LEA DX,SDS
     INT 21H
     MOV AH,2  
     MOV DL,C3
     INT 21H 
      
     MOV AH,9  
     LEA DX,CORD3
     INT 21H
     LEA DX,NEWLINE
     INT 21H          
 
     
     

     ;-----------------------------Check all win conditions----------------------------- 
     MOV CX,8
     
     BIG_LOOP:
     
     CMP CX,1
     JE ROW_1
     
     CMP CX,2
     JE ROW_2
     
     CMP CX,3
     JE ROW_3
     
     CMP CX,4
     JE COL_1
     
     CMP CX,5
     JE COL_2
     
     CMP CX,6
     JE COL_3
     
     CMP CX,7
     JE DIAG_1
     
     CMP CX,8
     JE DIAG_2
     
     
     ROW_1:
     PUSH CX
     MOV BH,A1;
     MOV CL,A2;
     MOV CH,A3;
     JMP WIN
     
     ROW_2:
     PUSH CX
     MOV BH,B1;
     MOV CL,B2;
     MOV CH,B3;
     JMP WIN
     
     ROW_3:
     PUSH CX
     MOV BH,C1;
     MOV CL,C2;
     MOV CH,C3;
     JMP WIN
     
     COL_1:
     PUSH CX
     MOV BH,A1;
     MOV CL,B1;
     MOV CH,C1;
     JMP WIN
     
     
     COL_2:
     PUSH CX
     MOV BH,A2;
     MOV CL,B2;
     MOV CH,C2;
     JMP WIN
     
     COL_3:
     PUSH CX
     MOV BH,A3;
     MOV CL,B3;
     MOV CH,C3;
     JMP WIN
     
     DIAG_1:
     PUSH CX
     MOV BH,A1;
     MOV CL,B2;
     MOV CH,C3;
     JMP WIN
     
     DIAG_2:
     PUSH CX
     MOV BH,A3;
     MOV CL,B2;
     MOV CH,C1;
     JMP WIN
     

     WIN:      
     
     ;player1 = x, player2 = o
     CMP BL,'x'
     JE PLAYER2_WON
     
     ;-----------------------------Check if player1 won-----------------------------
     PLAYER1_WON:
     
        CMP BH,CL
        JNE CHECK_FULL
        CMP CL,CH
        JNE CHECK_FULL
        
        ; CHECK IF THERE'S ANY HYPHEN
        CMP BH,'-'
        JE CHECK_FULL
        
        MOV AH,9
        LEA DX,NEWLINES
        INT 21H   
        LEA DX,WIN_P1
        INT 21H
        JMP GAME_OVER

        
     JMP CHECK_FULL
     
     ;-----------------------------Check if player2 won-----------------------------
     PLAYER2_WON:  
     
        CMP BH,CL
        JNE CHECK_FULL
        CMP CL,CH
        JNE CHECK_FULL 
        
        ; CHECK IF THERE'S ANY HYPHEN
        CMP BH,'-'
        JE CHECK_FULL
        
        MOV AH,9
        LEA DX,NEWLINES
        INT 21H   
        LEA DX,WIN_P2
        INT 21H
        JMP GAME_OVER    
     
     
     ;-----------------------------Check if board is full-----------------------------
     CHECK_FULL:
     CMP FILLED,9
     JE DRAW
     
     POP CX  
     LOOP BIG_LOOP;
                          
                          
     ;-----------------------------Game starts here-----------------------------
     START_GAME:            
     LEA DX, NEWLINES
     MOV AH,9
     INT 21H  
     LEA DX,EXIT_INSTRUCTION
     INT 21H
     CMP BL,'o'
     JE IN2
     LEA DX, INSTRUCTION1
     INT 21H 
     jmp Input
     IN2:
     LEA DX, INSTRUCTION2
     INT 21H     
     
     
           
              
              
              
     ;-----------------------------Input starts here-----------------------------          
     Input:         
     MOV AH,1
     INT 21H
     MOV DL,AL  
      
     CMP DL,'0'     ;jump to label according to input
     JE EXIT
     CMP DL,'1'
     JE KEY_A1
     CMP DL,'2'
     JE KEY_A2        
     CMP DL,'3'
     JE KEY_A3
     CMP DL,'4'
     JE KEY_B1
     CMP DL,'5'
     JE KEY_B2
     CMP DL,'6'
     JE KEY_B3
     CMP DL,'7'
     JE KEY_C1
     CMP DL,'8'
     JE KEY_C2
     CMP DL,'9'
     JE KEY_C3
     
     JE INVALID_MSG ;in case of no valid input
     
     
     ;-----------------------------Assign input to board-----------------------------
     KEY_A1: 
     CMP A1,'-'
     JNE OVERWRITE_MSG
     MOV A1,BL  
     JMP SWITCH 
     
     KEY_A2:
     CMP A2,'-'
     JNE OVERWRITE_MSG 
     MOV A2,BL  
     JMP SWITCH 
     
     KEY_A3:            
     CMP A3,'-'
     JNE OVERWRITE_MSG
     MOV A3,BL  
     JMP SWITCH
     
     KEY_B1:            
     CMP B1,'-'
     JNE OVERWRITE_MSG
     MOV B1,BL  
     JMP SWITCH
     
     KEY_B2:            
     CMP B2,'-'
     JNE OVERWRITE_MSG
     MOV B2,BL  
     JMP SWITCH
     
     KEY_B3:            
     CMP B3,'-'
     JNE OVERWRITE_MSG
     MOV B3,BL  
     JMP SWITCH
      
     KEY_C1:            
     CMP C1,'-'
     JNE OVERWRITE_MSG
     MOV C1,BL  
     JMP SWITCH
      
     KEY_C2:            
     CMP C2,'-'
     JNE OVERWRITE_MSG
     MOV C2,BL  
     JMP SWITCH 
     
     KEY_C3:            
     CMP C3,'-'
     JNE OVERWRITE_MSG
     MOV C3,BL  
     JMP SWITCH  
     
     ;-----------------------------Message for invalid input-----------------------------
     INVALID_MSG:
     MOV AH,9
     LEA DX,INV_INPUT
     INT 21H
     JMP GAME_SCR        
     
     ;-----------------------------Message for overwriting attempt-----------------------------
     OVERWRITE_MSG:
     MOV AH,9
     LEA DX,OVERWRITE
     INT 21H
     JMP GAME_SCR
     
     ;-----------------------------Switch player-----------------------------
     SWITCH:  
     INC FILLED
     XCHG BL,SIGN  
     JMP GAME_SCR 
     
     ;-----------------------------Draw message-----------------------------
     DRAW:
     MOV AH,9
     LEA DX,NEWLINES
     INT 21H   
     LEA DX,DRAWMSG
     INT 21H
     JMP GAME_OVER    
     
     ;-----------------------------Menu after game over-----------------------------
     GAME_OVER:
     LEA DX,NEWLINE
     INT 21H
     LEA DX,EXIT_INSTRUCTION
     INT 21H
     LEA DX,OP2
     INT 21H 
     LEA DX,NEWLINE
     INT 21H
     
     ;-----------------------------Game over menu input-----------------------------
     MOV AH,1
     INT 21H
     CMP AL,'0'  
     JNE INITIALIZE     
     JMP EXIT
             
             
    
    EXIT:
    MOV AH,4CH
    INT 21H 
    MAIN ENDP
 END MAIN
   
  
