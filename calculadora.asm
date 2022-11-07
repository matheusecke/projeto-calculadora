title MATHEUS ECKE MEDEIROS RA: 22004797

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

        CMP OP, '+'
        JE SOMA
        CMP OP, '-'
        JE SUBTRACAO
        CMP OP, '*'
        JE MULTIPLICACAO
        CMP OP, '/'
        JE DIVISAO
        JMP ERRO

        ; chama o procedimento que realiza SOMA
        SOMA:
            CALL FUNCTION_SOMA
            JMP FIM

        ; chama o procedimento que realiza SUBTRACAO
        SUBTRACAO:
            CALL FUNCTION_SUBTRACAO
            JMP FIM

        ; chama o procedimento que realiza MULTIPLICACAO
        MULTIPLICACAO:
            CALL FUNCTION_MULTIPLICACAO
            JMP FIM

        ; chama o procedimento que realiza DIVISAO
        DIVISAO:
            CALL FUNCTION_DIVISAO
            JMP FIM

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

    FUNCTION_SOMA PROC

        MOV BL, N1          ; armazena os 2 numeros
        MOV BH, N2          ; lidos em BL e BH
        ADD BH, BL          ; e realiza a SOMA
        SUB BH, 30H

        CALL PULA_LINHA     ; pula 2 linhas
        
        ; imprime o primeiro numero
        MOV DL, N1
        CALL PRINT_CHAR

        ; imprime o sinal de +
        MOV DL, '+'
        CALL PRINT_CHAR

        ; imprime o segundo numero
        MOV DL, N2
        CALL PRINT_CHAR

        ; imprime o sinal de =
        MOV DL, '='
        CALL PRINT_CHAR

        ; testa para numero maior ou igual a 10, e faz o jump caso ele seja menor
        CMP BH, 3AH
        JL MENOR10

        ; separa os dois digitos para impressao
        XOR AX, AX
        MOV AL, BH
        SUB AL, 30H
        MOV BL, 10
        DIV BL

        ; imprime os dois digitos separadamente
        MOV BX, AX
        MOV DL, BL
        OR DL, 30H
        CALL PRINT_CHAR
        MOV DL, BH
        OR DL, 30H
        CALL PRINT_CHAR
        JMP RET1

        MENOR10:
        ; imprime o resultado
        MOV DL, BH
        CALL PRINT_CHAR
           
        RET1:
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
        MOV DL, '-'
        CALL PRINT_CHAR

        ; imprime o segundo numero
        MOV DL, N2
        CALL PRINT_CHAR

        ; imprime o sinal de =
        MOV DL, '='
        CALL PRINT_CHAR

        ; teste de resultado negativo
        CMP BL, 0
        JGE RESULTADO        ; pula para a impressao de resultado caso seja positivo
        MOV DL, '-'
        CALL PRINT_CHAR
        NEG BL

        ; imprime o resultado
        RESULTADO:
        MOV DL, BL
        ADD DL, 30H
        CALL PRINT_CHAR

        RET
        
    FUNCTION_SUBTRACAO ENDP

    FUNCTION_MULTIPLICACAO PROC

        MOV BL, N1          ; armazena os 2 numeros
        MOV BH, N2          ; lidos em BL e BH
        XOR CL, CL          ; zera o conteudo de CL
        AND BL, 0FH
        AND BH, 0FH
    
        VEZES:
            SHR BH, 1
            JNC PAR

            ADD CL, BL

            PAR:
                SHL BL, 1
                ADD BH, 0
                JNZ VEZES

            ADD CL, 30H
            MOV DL, CL
            CALL PRINT_CHAR

        RET

    FUNCTION_MULTIPLICACAO ENDP

    FUNCTION_DIVISAO PROC

        MOV BL, N1          ; armazena os 2 numeros
        MOV BH, N2          ; lidos em BL e BH
    
        RET
    
    FUNCTION_DIVISAO ENDP
    
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

    end MAIN
