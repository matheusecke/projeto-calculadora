.model small
.data
    start       DB          '-=- CALCULADORA -=-$'
    primeiro    DB          'PRIMEIRO NUMERO: $'
    segundo     DB          'SEGUNDO NUMERO : $'
    operador    DB          'OPERADOR (+ - * /): $'
    invalido    DB          'OPERADOR INVALIDO!$'
    N1          DB          ?
    N2          DB          ?
    OP          DB          ?
.code

    PRINT_CHAR PROC

        ; print de char
        MOV AH, 02
        INT 21H

        RET

    PRINT_CHAR ENDP

    PRINT_STRING PROC

        ; print de string
        MOV AH, 09
        INT 21H

        RET

    PRINT_STRING ENDP
    
    PULA_LINHA PROC

        ; pula linha 2 vezes
        MOV DL, 0AH
        CALL PRINT_CHAR
        INT 21H

        RET

    PULA_LINHA ENDP
    
    FUNCTION_SOMA PROC

        MOV BL, N1          ; armazena os 2 numeros
        MOV BH, N2          ; lidos em BL e BH
        ADD BL, BH          ; e realiza a SOMA

        CALL PULA_LINHA     ; pula 2 linhas
        
        ; imprime o primeiro numero
        MOV DL, N1
        CALL PRINT_CHAR

        ; imprime o sinal de +
        MOV DL, 2BH
        CALL PRINT_CHAR

        ; imprime o segundo numero
        MOV DL, N2
        CALL PRINT_CHAR

        ; imprime o sinal de =
        MOV DL, 3DH
        CALL PRINT_CHAR

        MOV AX, BL
        MOV BL, 10
        DIV BL

        ; imprime o resultado
        MOV DL, BL
        SUB DL, 30H
        CALL PRINT_CHAR
        JMP FIM    

        RET

    FUNCTION_SOMA ENDP

    FUNCTION_SUBTRACAO PROC

        MOV BL, N1          ; armazena os 2 numeros
        MOV BH, N2          ; lidos em BL e BH
        SUB BL, BH          ; e realiza a SUBTRACAO

        CALL PULA_LINHA     ; pula 2 linhas

        ; imprime o primeiro numero
        MOV DL, N1
        CALL PRINT_CHAR

        ; imprime o sinal de -
        MOV DL, 2DH
        CALL PRINT_CHAR

        ; imprime o segundo numero
        MOV DL, N2
        CALL PRINT_CHAR

        ; imprime o sinal de =
        MOV DL, 3DH
        CALL PRINT_CHAR

        ; teste de resultado negativo
        CMP BL, 0
        JG RESULTADO        ; pula para a impressao de resultado caso seja positivo
        MOV DL, 2DH
        CALL PRINT_CHAR
        NEG BL

        ; imprime o resultado
        RESULTADO:
        MOV DL, BL
        ADD DL, 30H
        CALL PRINT_CHAR
        JMP FIM

        RET
        
    FUNCTION_SUBTRACAO ENDP

    FUNCTION_MULTIPLICACAO PROC

        RET

    FUNCTION_MULTIPLICACAO ENDP

    FUNCTION_DIVISAO PROC

        RET
    
    FUNCTION_DIVISAO ENDP

    MAIN PROC

        MOV AX, @DATA       ; move o segmento data para AX
        MOV DS, AX          ; e depois para DS

        CALL PULA_LINHA
        LEA DX, start       ; move mensagem inicial para ser impressa
        CALL PRINT_STRING

        CALL PULA_LINHA

        ; le primeiro numero
        LEA DX, primeiro
        CALL PRINT_STRING
        MOV AH, 01
        INT 21H
        MOV N1, AL
        
        CALL PULA_LINHA     ; pula 2 linhas

        ; le segundo numero
        LEA DX, segundo
        CALL PRINT_STRING
        MOV AH, 01
        INT 21H
        MOV N2, AL
        
        CALL PULA_LINHA     ; pula 2 linhas

        ; le o operador
        LEA DX, operador
        CALL PRINT_STRING
        MOV AH, 01
        INT 21H
        MOV OP, AL

        CMP OP, 2BH
        JE SOMA
        CMP OP, 2DH
        JE SUBTRACAO
        JMP ERRO

        ; chama a funcao que realiza SOMA
        SOMA:
            CALL FUNCTION_SOMA

        ; chama a funcao que realiza SUBTRACAO
        SUBTRACAO:
            CALL FUNCTION_SUBTRACAO

        ; chama a funcao que realiza MULTIPLICACAO
        MULTIPLICACAO:
            CALL FUNCTION_MULTIPLICACAO

        ; chama a funcao que realiza DIVISAO
        DIVISAO:
            CALL FUNCTION_DIVISAO

        ; imprime mensagem de erro quando o operador for invalido
        ERRO:
            CALL PULA_LINHA
            LEA DX, invalido
            CALL PRINT_STRING
        
        ; encerra o programa
        FIM:
            CALL PULA_LINHA
            MOV AH, 4CH
            INT 21H

    MAIN ENDP
end MAIN