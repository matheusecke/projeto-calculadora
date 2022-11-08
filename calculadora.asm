title MATHEUS ECKE MEDEIROS RA: 22004797

.model small
.data
    start       DB          ' =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- CALCULADORA -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= $'
    linha       DB          '==============================================================================$'
    primeiro    DB          ' PRIMEIRO NUMERO: $'
    segundo     DB          ' SEGUNDO NUMERO : $'
    operador    DB          ' OPERADOR (+ - * /): $'
    invalido    DB          ' OPERADOR INVALIDO!$'
    N1          DB          ?
    N2          DB          ?
    OP          DB          ?
.code

    MAIN PROC

        CALL LIMPA_TELA
        
        MOV AX, @DATA           ; move o segmento data para AX
        MOV DS, AX              ; e depois para DS

        CALL CABECALHO

        ; le primeiro numero
        LEA DX, primeiro
        CALL PRINT_STRING
        MOV AH, 01
        INT 21H
        MOV N1, AL
        
        CALL PULA_LINHA         ; pula 2 linhas

        ; le segundo numero
        LEA DX, segundo
        CALL PRINT_STRING
        MOV AH, 01
        INT 21H
        MOV N2, AL
        
        CALL PULA_LINHA         ; pula 2 linhas

        ; le o operador
        LEA DX, operador
        CALL PRINT_STRING
        MOV AH, 01
        INT 21H
        MOV OP, AL

        ; verifica qual foi o operador digitado
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

        MOV BL, N1              ; armazena os 2 numeros
        MOV BH, N2              ; lidos em BL e BH
        ADD BH, BL              ; e realiza a SOMA
        SUB BH, 30H
        MOV CL, BH              ; armazaena resultado em CL

        CALL PULA_LINHA         ; pula 2 linhas
        CALL ESPACO

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
        CMP CL, 3AH
        JL MENOR10

        ; imprime os dois digitos do numero separadamente
        CALL DOIS_DIGITOS
        JMP RET1

        MENOR10:
        ; imprime o resultado
        MOV DL, CL
        CALL PRINT_CHAR
           
        RET1:
            RET

    FUNCTION_SOMA ENDP

    FUNCTION_SUBTRACAO PROC

        MOV BL, N1              ; armazena os 2 numeros
        MOV BH, N2              ; lidos em BL e BH
        SUB BL, BH              ; e realiza a SUBTRACAO

        CALL PULA_LINHA         ; pula 2 linhas
        CALL ESPACO

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
        JGE RESULTADO           ; pula para a impressao de resultado caso seja positivo
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

        MOV BL, N1              ; armazena os 2 numeros
        MOV BH, N2              ; lidos em BL e BH
        XOR CL, CL              ; zera o conteudo de CL para armazenar resultado
        SUB BH, 30H
        SUB BL, 30H
    
        VEZES:
            SHR BH, 1
            JNC PAR

            ADD CL, BL

            PAR:
                SHL BL, 1
                CMP BH, 0
                JNZ VEZES

            ADD CL, 30H
            CALL PULA_LINHA
            CALL ESPACO

            ; imprime o primeiro numero
            MOV DL, N1
            CALL PRINT_CHAR

            ; imprime o sinal de *
            MOV DL, '*'
            CALL PRINT_CHAR

            ; imprime o segundo numero
            MOV DL, N2
            CALL PRINT_CHAR

            ; imprime o sinal de =
            MOV DL, '='
            CALL PRINT_CHAR

            ; testa para numero maior ou igual a 10, e faz o jump caso ele seja menor
            CMP CL, 3AH
            JL MENORQUE10

            ; imprime os dois digitos do numero separadamente
            CALL DOIS_DIGITOS
            JMP RET2

        MENORQUE10:
        ; imprime o resultado
        MOV DL, CL
        CALL PRINT_CHAR
           
        RET2:
            RET

    FUNCTION_MULTIPLICACAO ENDP

    FUNCTION_DIVISAO PROC

        MOV BL, N1              ; armazena os 2 numeros
        MOV BH, N2              ; lidos em BL e BH
        SUB BL, 30H
        SUB BH, 30H

        CMP BH, 1               ; verifica se o divisor eh 1
        MOV CL, BL              ; se sim printa o dividendo
        JE PRINTDIV
        CMP BL, BH              ; verifica se os numeros sao iguais
        JNE DIFERENTES          ; se forem diferentes executa o processo de divisao\
        MOV CL, 31H             ; se forem iguais define o resultado como 1 
        JMP PRINTDIV

        DIFERENTES:
            XOR CL, CL          ; zera CL
            VOLTA:
            SHR BH, 1           ; desloca o divisor e testa seu carry
            JNC DIVPAR          ; caso nao tenha carry se trata de um divisor par
            SHR BL, 1           ; divide por 2
            SUB BL, BH          ; subtrai o divisor do dividendo
            MOV CL, BL          ; armazena o resultado em CL
            JMP PRINTDIV

            DIVPAR:
                SHR BL, 1       ; divide por 2
                SUB BH, 1       ; subtrai 1 do divisor para evitar a repeticao do processo
                CMP BH, 0       ; testa se o divisor se tornou 0
                JNE VOLTA       ; repete o processo
                MOV CL, BL      ; armazena o resultado em CL
                
        PRINTDIV:
            ADD CL, 30H
            CALL PULA_LINHA
            CALL ESPACO

            ; imprime o primeiro numero
            MOV DL, N1
            CALL PRINT_CHAR

            ; imprime o sinal de /
            MOV DL, '/'
            CALL PRINT_CHAR

            ; imprime o segundo numero
            MOV DL, N2
            CALL PRINT_CHAR

            ; imprime o sinal de =
            MOV DL, '='
            CALL PRINT_CHAR

            MOV DL, CL
            CALL PRINT_CHAR

        FIM_DIV:
            RET
    
    FUNCTION_DIVISAO ENDP

    CABECALHO PROC

        LEA DX, linha       ; linha de =
        CALL PRINT_STRING
        CALL PULA_LINHA
        LEA DX, start       ; move mensagem inicial para ser impressa
        CALL PRINT_STRING
        CALL PULA_LINHA
        LEA DX, linha       ; linha de =
        CALL PRINT_STRING
        CALL PULA_LINHA

        RET

    CABECALHO ENDP
    
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

    ESPACO PROC

        ; da um espaco
        MOV DL, ' '
        CALL PRINT_CHAR
        RET

    ESPACO ENDP

    DOIS_DIGITOS PROC

        ; separa os dois digitos para impressao
        XOR AX, AX
        MOV AL, CL
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

        RET

    DOIS_DIGITOS ENDP

    LIMPA_TELA PROC
        
        MOV AL, 03H
        MOV AH, 00H
        INT 10h

        RET

    LIMPA_TELA ENDP

end MAIN
