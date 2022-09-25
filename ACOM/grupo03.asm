; **********************************************************************
; * IST-UL - Arquitetura de Computadores
; * João Matos nº 98949
; * João Amandeu nº 98943
; * Maria Freitas nº 96757 
; **********************************************************************

; **********************************************************************
; * Jogo do Pac-Man
; **********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************

DISPLAYS   		EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    		EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    		EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
MASCARA    		EQU 0FH     ; para eliminar os bits extra quando se lê o teclado
LINHA      		EQU 1	    ; o valor de LINHA comeca na primeira linha, 1
NO_LINHA   		EQU 10000   ; em decimal equivale ao valor 16
MAX_CONT   		EQU 64H		; valor máximo do contador em hexadecimal
TECLA_0			EQU 0H		; valor em hexadecimal da tecla 0
TECLA_1			EQU 1H		; valor em hexadecimal da tecla 1
TECLA_2 		EQU 2H		; valor em hexadecimal da tecla 2
TECLA_3	   		EQU 3H	    ; valor em hexadecimal da tecla 3
TECLA_4			EQU 4H		; valor em hexadecimal da tecla 4
TECLA_5 		EQU 5H		; valor em hexadecimal da tecla 5
TECLA_6			EQU 6H		; valor em hexadecimal da tecla 6
TECLA_7			EQU 7H		; valor em hexadecimal da tecla 7
TECLA_8			EQU 8H		; valor em hexadecimal da tecla 8
TECLA_9			EQU 9H		; valor em hexadecimal da tecla 9
TECLA_A			EQU 0AH		; valor em hexadecimal da tecla A
TECLA_B	   		EQU 0BH	    ; valor em hexadecimal da tecla B
TECLA_C	   		EQU 0CH	    ; valor em hexadecimal da tecla C
TECLA_D			EQU 0DH		; valor em hexadecimal da tecla D
TECLA_E	   		EQU 0EH	    ; valor em hexadecimal da tecla E 
TECLA_F	   		EQU 0FH	    ; valor em hexadecimal da tecla F
DEFINE_SOM 		EQU 605AH   ; endereço do comando para reproduzir o som
SOM 	   		EQU 0       ; numero do som
DEFINE_ECRA		EQU 6004H	; endereço do comando para selecionar os ecras
APAGA_TUDO		EQU 6002H   ; apaga todos os pixeis de todos os ecrãs
ECRA1			EQU 0		; ecra numero 1
ECRA2			EQU 1		; ecra numero 2
ECRA3			EQU 2       ; ecra numero 3
ECRA4			EQU 3       ; ecra numero 4
ECRA5			EQU 4       ; ecra numero 5
ECRA6			EQU 5       ; ecra numero 6
DEFINE_IMA		EQU 6042H   ; endereço do comando para a imagem de fundo
DEFINE_LINHA    EQU 600AH   ; endereço do comando para definir a linha
DEFINE_COLUNA   EQU 600CH   ; endereço do comando para definir a coluna
DEFINE_PIXEL    EQU 6012H   ; endereço do comando para escrever um pixel
DEFINE_COR 		EQU 6014H	; endereço do comando para definir a cor 
APAGA_AVISO     EQU 6040H   ; endereço do comando para apagar o aviso de nenhum cenário selecionado
COR_PAC	        EQU 0FFF0H  ; cor amarelo em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_FANT  		EQU 0F0F0H  ; cor verde em ARGB
COR_VERMELHO	EQU 0FF00H 	; cor vermelho em ARGB
COR_EXPLOSAO	EQU 0F0FFH	; cor azul claro em ARGB 
COR_CAIXA 		EQU 0F00FH	; cor azul da caixa em ARGB
NUM_FANTASMAS	EQU 4		; numero de fantasmas que vão existir no jogo
IMAGEM_INICIAL	EQU 0	    ; numero da imagem de inicio
IMAGEM_FUNDO  	EQU 1	    ; numero da imagem de fundo
IMAGEM_PAUSA	EQU 2	    ; numero da imagem de pausa
IMAGEM_GANHOU	EQU 3	    ; numero da imagem de jogo ganho
IMAGEM_PERDEU	EQU 4	    ; numero da imagem de jogo perdido
IMAGEM_FINAL	EQU 5	    ; numero da imagem de jogo terminado

; ************************************************************************
; * Dados 
; ************************************************************************

PLACE       1000H
	
pilha:      TABLE 100H      ; espaço reservado para a pilha 
                            ; (200H bytes, pois são 100H words)
SP_inicial:                 ; este é o endereço (1200H) com que o SP deve ser 
                            ; inicializado. O 1.º end. de retorno será 
                            ; armazenado em 11FEH (1200H-2)
tabela_int: WORD 	rot0	; tabela de interrupcoes
;			WORD    rot1
;			WORD  	rot2

; ************************************************************************
; * Objetos  
; ************************************************************************

tecla_carregada:						; edereço com a tecla carregada
	WORD 10H

sitio_pacman_aberto: 
	WORD 23   							; Linha onde vai ser desenhado o Pac-man de boca aberta
    WORD 29   							; Coluna onde vai ser desenhado o Pac-man de boca aberta
	WORD COR_PAC						; Define a cor amarela do Pac-man aberto
	WORD 0
	
sitio_fantasma_1:
    WORD 14 							; Linha onde vai ser desenhado o fantasma
    WORD 32 							; Coluna onde vai ser desenhado o fantasma
	WORD 0								; valor da movimentação 

sitio_fantasma_2:
	WORD 14
	WORD 32
	WORD 0
	
sitio_fantasma_3:
	WORD 14
	WORD 32
	WORD 0
	
sitio_fantasma_4:
	WORD 14
	WORD 32
	WORD 0

cor_fantasmas:
    WORD COR_FANT 						; Define a cor verde do fantasma 
	
cor_cruzes:
	WORD COR_VERMELHO					; Define a cor vermelha das cruzes 

cor_explosao:
	WORD COR_EXPLOSAO					; Define a cor azul da explosão 

sitio_x_cima_esquerda:
	WORD 1								; Linha onde vai ser desenhada a cruz de cima da esquerda
	WORD 1								; Coluna onde vai ser desenhada a cruz de cima da esquerda
	WORD 0

sitio_x_cima_direita:
	WORD 1								; Linha onde vai ser desenhada a cruz de cima da direita
	WORD 59								; Coluna onde vai ser desenhada a cruz de cima da direita
	WORD 0

sitio_x_baixo_esquerda:
	WORD 27								; Linha onde vai ser desenhada a cruz de baixo da esquerda
	WORD 1								; Coluna onde vai ser desenhada a cruz de cima da esquerda
	WORD 0
	
sitio_x_baixo_direita:
	WORD 27								; Linha onde vai ser desenhada a cruz de cima da direita
	WORD 59								; Coluna onde vai ser desenhada a cruz de cima da direita
	WORD 0

numero_cruzes_comidas:
	WORD 0

numero_fantasmas:
	WORD 0
	WORD 0

toca_fantasmas:
	WORD 0	

sitio_caixa:							
	WORD 12								; Linha onde vai ser desenhada a caixa
	WORD 28								; Coluna onde vai ser desenhada a caixa
	WORD COR_CAIXA						; Define a cor azul da caixa 
	
pacman_fechado: 						; Tabela para desenhar o PAC-MAN de boca fechada
	STRING 5, 4							; Dimensões do PAC-MAN de boca fechada 
	STRING 0, 1, 1, 0
	STRING 1, 1, 1, 1
	STRING 1, 1, 1, 1
	STRING 1, 1, 1, 1
	STRING 0, 1, 1, 0  

pacman_aberto:							; Tabela para desenhar o PAC-MAN de boca aberta
	STRING 5, 4							; Dimensões do PAC-MAN de boca aberta 
	STRING 0, 1, 1, 0 
	STRING 1, 1, 1, 1  
	STRING 1, 0, 0, 0  
	STRING 1, 1, 1, 1  
	STRING 0, 1, 1, 0  

fantasmas: 							    ; Tabela para desenhar um fantasma
	STRING 4, 4							; Dimensões dos fantasmas
	STRING 0, 1, 1, 0  
	STRING 1, 1, 1, 1
	STRING 1, 1, 1, 1
	STRING 1, 0, 0, 1  

cruzes:									; Tabela para desenhar os objetos dos cantos
	STRING 4, 4							; Dimensões das cruzes 
	STRING 1, 0, 0, 1  
	STRING 0, 1, 1, 0
	STRING 0, 1, 1, 0
	STRING 1, 0, 0, 1

explosao:								; Tabela para desenhar a explosao 
	STRING 5, 5							; Dimensões da explosão
	STRING 0, 1, 0, 1, 0 
	STRING 1, 0, 1, 0, 1
	STRING 0, 1, 0, 1, 0
	STRING 1, 0, 1, 0, 1
	STRING 0, 1, 0, 1, 0

caixa:									; Tabela para desenhar a caixa 
	STRING 8, 12						; Dimensões da caixa 
	STRING 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1
	STRING 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	STRING 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	STRING 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	STRING 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	STRING 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	STRING 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	STRING 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

; ************************************************************************
; * Código - inicializações
; ************************************************************************

PLACE      0H
inicio:		  				 ; inicializações
    MOV  [APAGA_AVISO], R1   ; apaga o aviso de nenhum cenário selecionado 
    MOV  R2, TEC_LIN    	 ; endereço do periférico das linhas
    MOV  R3, TEC_COL    	 ; endereço do periférico das colunas
    MOV  R4, DISPLAYS    	 ; endereço do periférico dos displays
	MOV  [R4], R1	    	 ; escreve linha e coluna a zero nos displays
    MOV  SP, SP_inicial   	 ; inicializa SP para a palavra a seguir à última da pilha  
	MOV  BTE, tabela_int     ; inicializa BTE (registo de Base da Tabela de Exceções)
	EI0						 ; permite interrupcoes 0 (relogio jogo)
	EI1						 ; permite interrupcoes 1 (relogio fantasmas)
;	EI2						 ; permite interrupcoes 2 (relogio explosoes)
;	EI						 ; permite interrupções (geral)		

; ************************************************************************
; * Código - principal
; ************************************************************************

começa:
	CALL ecra_inicial
	CALL comeca_jogo
	MOV R7, [numero_fantasmas]
	ADD R7, 1
	MOV [numero_fantasmas], R7 			 
	CALL fundo 
	CALL desenha_pac_aberto
	CALL desenha_x_cima_esquerda
	CALL desenha_x_cima_direita
	CALL desenha_x_baixo_esquerda
	CALL desenha_x_baixo_direita
	CALL desenha_caixa
jogo:
	CALL responsavel_fantasmas
	CALL spawn
	CALL teclado
	MOV R10, [tecla_carregada]
;	MOV R11, TECLA_D
;	CMP R10, R11 
;	JZ pausa 
	MOV R11, TECLA_E
	ADD R11, 1
	CMP R10, R11
	JZ fim 
	CALL movimenta_pacman
	CALL come_cruzes
	MOV R10, [numero_cruzes_comidas]    ; Coloca no edereço R10 o valor de cruzes comidas pelo pacman
	MOV R11, 4							; Coloca no edereço R11 o valor 4		
	CMP R10, R11						; Compara os valores dos edereços R10 e R11
	JZ ganhou							; Se forem iguais, aparece o ecra de vitoria
	CALL colisoes_2
	MOV R10, [toca_fantasmas]			; coloca o valor de toca fantasmas em R10 
	MOV R11, 0							
	CMP R10, R11 						; verifica se é zero
	JNZ perdeu 							; se não for zero -> perdeu 
	JMP jogo 							
;pausa:
;	CALL ecra_pausa
;	CALL teclado 
;	MOV R11, TECLA_D 
;	CMP R10, R11
;	JZ jogo 
;	MOV R11, TECLA_E 
;	CMP R10, R11
;	JZ fim 
;	JNZ pausa 
fim:
	CALL apaga_ecras
	CALL ecra_final
	JMP acabou 

; ************************************************************************
; *	Funções auxiliares da função main do programa 
; ************************************************************************
ganhou:
	CALL apaga_ecras
	CALL ecra_ganhou
	acabou:
		JMP acabou 

perdeu:
	CALL apaga_ecras
	CALL ecra_perdeu
	JMp acabou  
		
comeca_jogo:
	PUSH R10
	PUSH R11
	repete:
		CALL teclado 
		MOV R10, [tecla_carregada]
		MOV R11, TECLA_C
		CMP R10, R11 
		JNZ repete	
	POP R11
	POP R10
	RET
	
; ************************************************************************
; * Código
; ************************************************************************

; ************************************************************************
; *	Nome:	teclado														 
; *	Descricao: guarda a tecla premida no teclado 		 	
; ************************************************************************
teclado:		  						
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9 
	MOV R9, [numero_fantasmas+2]
	ADD R9, 1
	MOV [numero_fantasmas+2], R9 
	muda_linha1:	    				; coloca o valor da linha a ler em 1
		MOV R1, LINHA
	espera_tecla:	    				; analisa o teclado até que seja pressionada uma tecla
		MOVB [R2], R1   				; escrever no periférico de saída (linhas)
		MOVB R0, [R3]     				; ler do periférico de entrada (colunas)
		MOV  R5, MASCARA
		AND  R0, R5     				; elimina os bits 7..4, teclado só liga aos bits 3..0 
		CMP  R0, 0    					; verifica se ha tecla permida
		JZ   muda_linha					; se nao houver tecla permida naquela linha, passa à seguinte
		JNZ	 transforma_teclas 			; se houver  tecla permida -> transforma_teclas
	muda_linha:							; muda a linha a analisar 
		MOV R8, 16						; coloca 16 em R8 (equivale à linha 5)
		SHL R1, 1						; transforma a linha na linha seguinte
		CMP R1, R8						; compara a linha com a linha 5 (que ja não é para analisar)
		JNE espera_tecla				; se for diferente -> espera_tecla
		JMP sai_teclado_sem_tecla		; se for igual -> sai do teclado para este não ser bloqueante
	transforma_teclas:					; transforma os valores das teclas em hexadecimal (corresponde às teclas do teclado) 
		transforma_linhas:				; transforma o valor da linha
			SHR R1, 1					; faz SHR ao valor da linha
			ADD R6, 1					; adiciona 1 a R6 (utilizado para guardar a linha)
			CMP R1, 0					; compara a linha com 0
			JNZ transforma_linhas		; se nao for 0 repete o ciclo -> transforma_linhas 
			JZ  transforma_colunas		; se for 0 -> transforma_colunas
		transforma_colunas:				; transforma o valor da coluna
			SHR R0, 1					; faz SHR ao valor da coluna 
			ADD R7, 1					; adiciona 1 a R7 (utilizado para guardar a coluna)
			CMP R0, 0					; compara a coluna com 0
			JNZ transforma_colunas		; se nao for 0 repete o ciclo -> transforma_colunas
			JZ  ha_tecla				; se for 0 -> ha_tecla
	ha_tecla:							; escreve a tecla permida no display
		SUB R6, 1						; subtrai um ao valor da linha
		SUB R7, 1						; subtrai um ao valor da coluna
		MOV R8, 4						; coloca 4 em R8
		MUL R6, R8						; multiplica a linha por R8 (4)
		ADD R6, R7 						; adiciona o valor da coluna ao resulta da multiplicação anterior 
		JMP sai_teclado_com_tecla
	sai_teclado_sem_tecla:
		MOV R6, 10H
		MOV [tecla_carregada], R6
		JMP sai_teclado
	sai_teclado_com_tecla:
		MOV [tecla_carregada], R6		; coloca o valor da tecla no endereço da tecla_carregada
	sai_teclado:
		POP R9 
		POP R8
		POP R7
		POP R6
		POP R5
		POP R3
		POP R2
		POP R1
		POP R0
		RET 

; ************************************************************************
; *	Nome:	rot0	          				 			  		   		 
; *	Descricao: chama a função responsavel pelos fantasmas 										 
; ************************************************************************
rot0:
	PUSH R0
	CALL responsavel_fantasmas
	POP  R0
	RFE					; Return From Exception

; ************************************************************************
; *	Nome:	rot1	          				 			  		   		 
; *	Descricao: chama a função contador quando o flanco		             
; * 		   de relógio é ascendente												 
; ************************************************************************;rot1:
;rot1:
;	PUSH R0
;	CALL contador
;	POP R0
;	RFE					; Return From Exception

; ************************************************************************
; *	Nome:	rot2	          				 			  		   		 
; *	Descricao: chama a função contador explosoes											 
; ************************************************************************
;rot2:
;	PUSH R0
;	CALL contador_explosoes
;	POP  R0
;	RFE

; ************************************************************************
; *	Nome:	contador 														 
; *	Descricao: função responsavel pelo contador de pontos, associado ao relógio 
; * 		   jogo e incrementa a cada segundo. O valor é colocado no display.
; ************************************************************************
contador:		
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R6
	PUSH R7
	MOV R7, MAX_CONT			; coloca o valor maximo que o contador pode ter em R7
	compara_maximo:				; compara se o valor do contador ja atingiu o seu máximo
		CMP R9, R7				; compara o valor presente no contador com o máximo
		JNE adiciona			; se nao for igual -> adiciona
		JMP sai_contador		; se for igual não pode ser incrementado
	adiciona:
		ADD  R9, 1				; adiciona 1 ao contador 
		JMP converte		
	converte:					; converte o valor em hexadecimal para decimal 
		MOV R2, R9				; copia R9 para R2
		MOV R3, R9				; copia R9 para R3
		MOV R5, 10				; coloca 10 em R5
		MOD R2, R5				; divide R2 por R5 e coloca o resto da divisão em R2
		DIV R3, R5				; divide R3 por R5
		SHL R3, 4			
		OR R2, R3
		MOV [R4], R2			; coloca o valor do contador no display
		JMP sai_contador
	sai_contador:
		POP R7
		POP R6
		POP R5 
		POP R3
		POP R2
		RET

; ************************************************************************
; *	Nome:	som														 
; *	Descricao: função responsável por tocar um som		 	
; ************************************************************************
som:									; função responsavel por reproduzir um som
	PUSH R0
	MOV R0, SOM							; coloca o nº do som no R0
	MOV [DEFINE_SOM], R0				; reproduz o som
	sai_som:
		POP R0
		RET
		
; ************************************************************************
; *	Nome:	desenha_pac_aberto									
; *	Descricao:	função que desenha o pacman de boca aberta 		 	
; ************************************************************************
desenha_pac_aberto:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7
	PUSH R8
	MOV R7, ECRA2						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7	
	MOV R0, pacman_aberto				; Inicializa a tabela do pacman_aberto no registo R0
	MOV R1, [sitio_pacman_aberto]		; Coloca o valor da linha em R1
	MOV R2, [sitio_pacman_aberto+2]		; Coloca o valor da coluna em R2
	MOV R8, [sitio_pacman_aberto+4]		; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET

; ************************************************************************
; *	Nome:	desenha_fantasma									
; *	Descricao:	função que desenha o fantasma 1		 	
; ************************************************************************
desenha_fantasma_1:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7
	PUSH R8
	MOV R7, ECRA3						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7	
	MOV R0, fantasmas					; Inicializa a tabela dos fantasmas no registo R0
	MOV R1, [sitio_fantasma_1]			; Coloca o valor da linha em R1
	MOV R2, [sitio_fantasma_1+2]		; Coloca o valor da coluna em R2
	MOV R8, [cor_fantasmas]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET

; ************************************************************************
; *	Nome:	desenha_fantasma_2									
; *	Descricao:	função que desenha o fantasma 2		 	
; ************************************************************************
desenha_fantasma_2:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7 
	PUSH R8
	MOV R7, ECRA3						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, fantasmas					; Inicializa a tabela dos fantasmas no registo R0
	MOV R1, [sitio_fantasma_2]			; Coloca o valor da linha em R1
	MOV R2, [sitio_fantasma_2+2]		; Coloca o valor da coluna em R2
	MOV R8, [cor_fantasmas]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET

; ************************************************************************
; *	Nome:	desenha_fantasma_3									
; *	Descricao:	função que desenha o fantasma 3		 	
; ************************************************************************
desenha_fantasma_3:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7
	PUSH R8
	MOV R7, ECRA3						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, fantasmas					; Inicializa a tabela dos fantasmas no registo R0
	MOV R1, [sitio_fantasma_3]			; Coloca o valor da linha em R1
	MOV R2, [sitio_fantasma_3+2]		; Coloca o valor da coluna em R2
	MOV R8, [cor_fantasmas]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET

; ************************************************************************
; *	Nome:	desenha_fantasma_4									
; *	Descricao:	função que desenha o fantasma 4		 	
; ************************************************************************
desenha_fantasma_4:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7 
	PUSH R8
	MOV R7, ECRA3						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, fantasmas					; Inicializa a tabela dos fantasmas no registo R0
	MOV R1, [sitio_fantasma_4]			; Coloca o valor da linha em R1
	MOV R2, [sitio_fantasma_4+2]		; Coloca o valor da coluna em R2
	MOV R8, [cor_fantasmas]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET

; ************************************************************************
; *	Nome:	desenha_x_cima_esquerda									
; *	Descricao:	função que desenha a cruz de cima do lado esquerdo		 	
; ************************************************************************
desenha_x_cima_esquerda:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7 
	PUSH R8
	MOV R7, ECRA4						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, cruzes						; Inicializa a tabela das cruzes no registo R0
	MOV R1, [sitio_x_cima_esquerda]		; Coloca o valor da linha em R1
	MOV R2, [sitio_x_cima_esquerda+2]	; Coloca o valor da coluna em R2
	MOV R8, [cor_cruzes]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET

; ************************************************************************
; *	Nome:	desenha_x_cima_direita								
; *	Descricao:	função que desenha a cruz de cima do lado direito 		 	
; ************************************************************************
desenha_x_cima_direita:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7 
	PUSH R8
	MOV R7, ECRA4						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, cruzes						; Inicializa a tabela das cruzes no registo R0
	MOV R1, [sitio_x_cima_direita]		; Coloca o valor da linha em R1
	MOV R2, [sitio_x_cima_direita+2]	; Coloca o valor da coluna em R2
	MOV R8, [cor_cruzes]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET
	
; ************************************************************************
; *	Nome:	desenha_x_baixo_esquerda								
; *	Descricao:	função que desenha a cruz de baixo do lado esquerdo 		 	
; ************************************************************************
desenha_x_baixo_esquerda:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7 
	PUSH R8
	MOV R7, ECRA4						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, cruzes						; Inicializa a tabela das cruzes no registo R0
	MOV R1, [sitio_x_baixo_esquerda]	; Coloca o valor da linha em R1
	MOV R2, [sitio_x_baixo_esquerda+2]	; Coloca o valor da coluna em R2
	MOV R8, [cor_cruzes]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET
	
; ************************************************************************
; *	Nome:	desenha_x_baixo_direita								
; *	Descricao:	função que desenha a cruz de baixo do lado direito 		 	
; ************************************************************************
desenha_x_baixo_direita:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7 
	PUSH R8
	MOV R7, ECRA4						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, cruzes						; Inicializa a tabela das cruzes no registo R0
	MOV R1, [sitio_x_baixo_direita]		; Coloca o valor da linha em R1
	MOV R2, [sitio_x_baixo_direita+2]	; Coloca o valor da coluna em R2
	MOV R8, [cor_cruzes]	; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET 
	
; ************************************************************************
; *	Nome:	desenha_caixa									
; *	Descricao:	função que desenha a caixa 		 	
; ************************************************************************
desenha_caixa:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R8
	MOV R0, caixa						; Inicializa a tabela da caixa no registo R0
	MOV R1, [sitio_caixa]				; Coloca o valor da linha em R1
	MOV R2, [sitio_caixa+2]				; Coloca o valor da coluna em R2
	MOV R8, [sitio_caixa+4]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R2
	POP R1
	POP R0
	RET
	
; ************************************************************************
; *	Nome:	desenha_objeto							
; *	Descricao:	função que desenha o objeto indicado na tabela 
; *				presente em R0. Começa na linha guardada em R1
; *				e na coluna guardada em R2, com a cor presente 
; *				em R8
; ************************************************************************
desenha_objeto:	
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	MOVB R4, [R0]						; Altura do objeto
	ADD R0, 1							; Passa ao próximo elemento da tabela
	MOVB R3, [R0]						; Comprimento do objeto	
	ADD R0, 1							; Próximo elemento da tabela
	MOV R7, R3							; Copia o comprimento para o R7
	inicio_sub:
		CMP R3, 0						; Verifica se chegou ao fim da linha
		JZ soma							; Chegou ao fim da linha
		JNZ cont1						; Nao chegou ao fim da linha
	soma:	
		CALL soma_linha					; Passa para a linha seguinte
		CMP R4, 0						; Verifica se já percorreu todas as linhas
		JZ sai_desenha_objeto			; Se já percorreu todas as linhas termina 	
	cont1:
		MOVB R6, [R0]					; Guarda o valor da tabela que se vai analisar
		CMP R6, 1						; Verifica se o elemento da tabela é 1 ou 0
		JZ desenha							; Vai desenhar o pixel
		JNZ cont2						; Passa para o pixel seguinte	
	desenha:
		CALL escreve_pixel
	cont2:
		ADD R0, 1						; Próximo elemento da tabela
		ADD R2, 1						; Adiciona 1 à coluna
		SUB R3, 1						; Subtrai 1 ao comprimento do objeto
		JMP inicio_sub					; Vai verificar se chegou ao fim da nova linha
	soma_linha:
		ADD R1, 1						; Adiciona 1 à linha 
		SUB R4, 1						; Subtrai 1 à altura do objeto
		SUB R2, R7						; Volta para a coluna inicial
		MOV R3, R7						; Coloca o comprimento em R3
		RET	
	sai_desenha_objeto:
		POP R7
		POP R6
		POP R5
		POP R4
		POP R3
		POP R2
		POP R1
		POP R0
		RET
		
; ************************************************************************
; *	Nome:	desenha_explosao									
; *	Descricao:	função que desenha a explosao	 	
; ************************************************************************
desenha_explosao:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R7
	PUSH R8
	MOV R7, ECRA2						; Coloca o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7	
	MOV R0, explosao					; Inicializa a tabela dos fantasmas no registo R0
	MOV R1, [sitio_pacman_aberto]			; Coloca o valor da linha em R1
	MOV R2, [sitio_pacman_aberto+2]		; Coloca o valor da coluna em R2
	MOV R8, [cor_explosao]				; Coloca o valor da cor em R8
	CALL desenha_objeto
	POP R8
	POP R7 
	POP R2
	POP R1
	POP R0
	RET

; ************************************************************************
; *	Nome:	escreve_pixel							
; *	Descricao:	função que escreve o pixel na linha guardada em R1,
; * 			na coluna guardada em R2 e com a cor guardada em R8 
; ************************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1      ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2     ; seleciona a coluna
	MOV  [DEFINE_PIXEL], R8      ; altera a cor do pixel na linha e coluna selecionadas
	RET 

; ************************************************************************
; *	Nome:	cima_esquerda 							
; *	Descricao:	função que verifica se é possivel andar para cima 
; * 			e para a esquerda. Se possivel subtrai uma linha e uma coluna
; ************************************************************************
cima_esquerda:							; função responsável pela movimentação para cima e para a esquerda (na diagonal)
	MOV R6, 0H							; coloca o limite superior do ecrã em R6
	CMP R0, R6							; compara a linha atual com o limite 
	JZ sai_cima_esquerda				; se for igual -> sai mantendo a posição onde se escontrava
	MOV R6, 0H							; coloca o limite esquerdo do ecrã em R6
	CMP R1, R6							; compara com o limite 
	JZ sai_cima_esquerda				; se for igual -> sai mantendo a posição onde se escontrava
	MOV R6, 14H							; coloca a linha do limite inferior da caixa em R6
	CMP R0, R6							; compara a linha atual com o limite 
	JZ verifica_cima_esquerda			; se for igual vai verificar as colunas
	MOV R6, 28H							; coloca a coluna limite direita da caixa em R6
	CMP R1, R6							; verifica se está na coluna limite  
	JZ verifica_cima_esquerda_2			; vai verificar as linhas 
	JNZ desenha_cima_esquerda
	verifica_cima_esquerda:
		MOV R6, 1AH						; coloca a coluna limite esquerda da caixa em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JLT desenha_cima_esquerda		; se estiver à esquerda 
		MOV R6, 28H						; coloca a coluna limite direita da caixa em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JGT desenha_cima_esquerda		; se estiver à direita da coluna pode desenhar 
		JMP sai_cima_esquerda 			; se estiver entre as colunas limite passa à próxima verificação
	verifica_cima_esquerda_2:
		MOV R6, 9H						; coloca a linha superior da caixa - tamanho do pacman em R6
		CMP R0, R6						; compara a linha atual com o limite 
		JLT desenha_cima_esquerda		; es estiver a cima pode desenhar 
		MOV R6, 14H						; coloca a linha inferior da caixa em R6
		CMP R0, R6						; compara a linha atual com o limite 
		JGT desenha_cima_esquerda		; se estiver a baixo pode desenhar 
		JLT sai_cima_esquerda			; se estiver entre as linhas não pode desenhar -> sai mantendo a posição atual 
	desenha_cima_esquerda:
		CALL subtrai_coluna				; retira uma coluna 
		CALL subtrai_linha				; retira uma linha (para andar para cima)
		ADD R7, 1
		RET 
	sai_cima_esquerda:
		RET 
		
; ************************************************************************
; *	Nome:	cima							
; *	Descricao:	função que verifica se é possivel andar para cima. 
; *				Se possivel subtrai uma linha
; ************************************************************************	
cima:									; função responsável pela movimentação para cima 
	MOV R6, 0H							; coloca o limite superior do ecrã em R6
	CMP R0, R6							; compara a linha onde o pacman se encontra com o limite superior do ecrã
	JZ sai_cima							; se for igual o pacman mantém-se onde se encontrava
	MOV R6, 14H							; coloca a linha do limite inferior da caixa dos fantasmas 
	CMP R0, R6							; compara com o limite 
	JZ verifica_cima					; se for igual vai verificar as colunas
	JNZ desenha_cima					; se passar as verificações desenha 
	verifica_cima:					
		MOV R6, 19H						; coloca o valor da coluna da esquerda da caixa - tamanho do pacman em R6
		CMP R1, R6						; compara com o limite 
		JLT desenha_cima				; se estiver à esquerda da coluna pode ir para cima
		MOV R6, 28H						; coloca o valor da coluna da direita da caixa em R6
		CMP R1, R6						; compara com o limite 
		JGT desenha_cima				; se estiver à direita da coluna pode subir 
		JLT sai_cima
	desenha_cima:
		CALL subtrai_linha				; retira uma linha (anda para cima no ecrã)
		ADD R7, 1
		RET
	sai_cima:
		RET   
		
; ************************************************************************
; *	Nome:	cima_direita 							
; *	Descricao:	função que verifica se é possivel andar para cima 
; * 			e para a direita. Se possivel subtrai uma linha e adiciona uma coluna
; ************************************************************************
cima_direita:							; função responsável por fazer movimentar o pacman para cima e para a direita (na diagonal)
	MOV R6, 0H							; coloca o limite superior do ecrã em R6
	CMP R0, R6							; compara a linha atual com o limite 
	JZ sai_cima_direita					; se for igual sai mantendo a posição atual 
	MOV R6, 3CH							; coloca o limite direito do ecrã - tamanho do pacman em R6
	CMP R1, R6							; compara a coluna atual com o limite do ecrã 
	JZ sai_cima_direita					; se for igual sai mantendo a posição atual 
	MOV R6, 14H							; coloca a linha limite inferior da caixa em R6
	CMP R0, R6							; compara a linha atual com a linha limite 
	JZ verifica_cima_direita			; se for igual -> verifica as colunas
	MOV R6, 18H							; coloca o valor da coluna limite esquerda da caixa - tamanho do pacman em R6
	CMP R1, R6							; compara a coluna atual com o limite 
	JZ verifica_cima_direita_2			; vai verificar as colunas 
	JNZ desenha_cima_direita 			; se passar as verifiações desenha 
	verifica_cima_direita:
		MOV R6, 18H						; coloca o valor da coluna limite esquerda da caixa - tamanho do pacman em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JLT desenha_cima_direita		; se estiver à esquerda da caixa pode desenhar  
		MOV R6, 26H						; coloca a coluna limite direita da caixa em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JGT desenha_cima_direita		; se estiver à direita da caixa pode desenhar 
		JMP sai_cima_direita				
	verifica_cima_direita_2:
		MOV R6, 9H						; coloca a linha limite superior da caixa - tamanho do pacman em R6
		CMP R0, R6						; compara a linha atual com o limite 
		JLT desenha_cima_direita		; se for menor (estiver a cima no ecrã) pode desenhar 
		MOV R6, 14H						; coloca a linha limite inferior da caixa em R6
		CMP R0, R6						; compara a linha atual com o limite 
		JGT desenha_cima_direita		; se a linha for maior (estiver a baixo no ecrã) pode desenhar 
		JLT sai_cima_direita			; se a linha estiver entre a menor e a maior sai mantendo a posição atual 
	desenha_cima_direita:
		CALL subtrai_linha				; subtrai uma linha 
		CALL adiciona_coluna			; adiciona uma coluna 
		ADD R7, 1
		RET
	sai_cima_direita:
		RET   

; ************************************************************************
; *	Nome:	esquerda 							
; *	Descricao:	função que verifica se é possivel a esquerda. Se possivel
; * 			 subtrai uma coluna
; ************************************************************************		
esquerda:
	MOV R6, 0H							; coloca o limite esquerdo do ecrã em R6
	CMP R1, R6							; compara a coluna da posição atual com o limite esquerdo do ecrã
	JZ sai_esquerda						; se estiver no limite sai ficando o pacman na mesma posição 
	MOV R6, 28H							; coloca o limite direito da caixa em R6
	CMP R1, R6							; compara a coluna atual com o limite 
	JZ verifica_esquerda				; se for igual vai verificar as linhas 
	JNZ desenha_esquerda 				; se passar nas verificações desenha 
	verifica_esquerda:
		MOV R6, 8H						; coloca a linha limite superior da caixa - tamanho do pacman em R6
		CMP R0, R6						; compara com a linha atual com o limite 
		JLT desenha_esquerda			; se for menor (estiver a cima no ecrã) pode desenhar 
		MOV R6, 14H						; coloca a linha limite inferior da caixa em R6
		CMP R0, R6						; compara a linha atual com o limite 
		JLT sai_esquerda				; se a linha estiver entre a menor e a maior sai mantendo a posição atual
		JGT desenha_esquerda			; se a linha for maior (estiver a baixo no ecrã) pode desenhar 
	desenha_esquerda:
		CALL subtrai_coluna				; subtrai uma coluna
		ADD R7, 1
		RET 
	sai_esquerda:
		RET   

; ************************************************************************
; *	Nome:	direita  							
; *	Descricao:	função que verifica se é possivel a direita. Se possivel
; * 			 adiciona uma coluna
; ************************************************************************	
direita:
	MOV R6, 3CH							; coloca o limite direito do ecrã - tamanho do pacman em R6 
	CMP R1, R6							; compara a coluna atual com o limite do ecrã
	JZ sai_direita						; se for igual sai mantendo a posição atual 
	MOV R6, 18H							; coloca o valor da coluna limite esquerda da caixa - tamanho do pacman em R6
	CMP R1, R6							; compara a coluna atual com o limite 
	JZ verifica_direita					; se tiver no limite vai verificar as linhas 
	JNZ desenha_direita					; se passar nas verifiações -> desenha 
	verifica_direita:
		MOV R6, 8H						; coloca a linha limite superior da caixa - tamanho do pacman em R6
		CMP R0, R6						; compara com a linha atual com o limite 
		JLT desenha_direita				; se for menor (estiver a cima no ecrã) pode desenhar 
		MOV R6, 14H						; coloca a linha limite inferior da caixa em R6
		CMP R0, R6						; compara a linha atual com o limite 
		JLT sai_direita					; se a linha estiver entre a menor e a maior sai mantendo a posição atual
		JGT desenha_direita				; se a linha for maior (estiver a baixo no ecrã) pode desenhar
	desenha_direita:
		CALL adiciona_coluna			; adiciona uma coluna 
		ADD R7, 1
		RET 
	sai_direita:
		RET   

; ************************************************************************
; *	Nome:	baixo_esquerda  							
; *	Descricao:	função que verifica se é possivel andar para baixo 
; * 			e para a esquerda. Se possivel adiciona uma linha e subtrai uma coluna
; ************************************************************************
baixo_esquerda:
	MOV R6, 1BH							; coloca a linha do limite inferior do ecrã em R6
	CMP R2, R6							; compara a linha atual com o limite 
	JZ sai_baixo_esquerda				; se for igaul sai mantendo a posição atual 
	MOV R6, 0H							; coloca a coluna do limite esquerda do ecrã em R6 
	CMP R1, R6							; compara a coluna atual com o limite 
	JZ sai_baixo_esquerda				; se for igual sai mantendo a posição atual 
	MOV R6, 7H							; coloca a linha limite superior da caixa - tamamnho do pacman em R6 
	CMP R0, R6							; compara a linha atual com o limite 
	JZ verifica_baixo_esquerda			; se for igual vai verificar as colunas 
	MOV R6, 28H							; coloca o valor da coluna da direita da caixa em R6
	CMP R1, R6							; compara a coluna atual com o limite 
	JZ verifica_baixo_esquerda_2		; se for igual vai verificar as linhas 
	JNZ desenha_baixo_esquerda			; se passar nas verificações desenha 
	verifica_baixo_esquerda:
		MOV R6, 1AH						; coloca o limite esquerdo da caixa - tamanho do pacman em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JLT desenha_baixo_esquerda		; se estiver à esquerda da caixa pode desenhar 
		MOV R6, 29H						; coloca o limite direito da caixa em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JGT desenha_baixo_esquerda		; se estiver à direita da caixa pode desenhar 
		JLT sai_baixo_esquerda			; se estiver entre os limites da caixa sai mantendo a posição atual 
	verifica_baixo_esquerda_2:
		MOV R6, 8H						; coloca o limite superior da caixa - tamanho do pacman em R6 
		CMP R0, R6						; compara a linha atual com o limite 
		JLT desenha_baixo_esquerda		; se estiver por cima da caixa pode desenhar 
		MOV R6, 13H						; coloca o limite inferior da caixa em R6
		CMP R0, R6						; compara a linha atual com o limite 
		JGT desenha_baixo_esquerda		; se estiver por baixo da caixa pode desenhar 
		JLT sai_baixo_esquerda			; se estiver entre os limites da caixa sai mantendo a posição atual 
	desenha_baixo_esquerda:
		CALL adiciona_linha				; adiciona uma linha 
		CALL subtrai_coluna				; retira uma coluna 
		ADD R7, 1
		RET 
	sai_baixo_esquerda:
		MOV R7, 0
		RET   

; ************************************************************************
; *	Nome:	baixo  							
; *	Descricao:	função que verifica se é possivel andar para baixo. 
; * 			Se possivel adiciona uma linha
; ************************************************************************			
baixo:
	MOV R6, 1BH							; coloca a linha limite inferior do ecrã em R6 
	CMP R0, R6							; compara a linha atual com a linha limite do ecrã 
	JZ sai_baixo						; se for igual sai mantendo a posição atual 
	MOV R6, 7H							; coloca a linha limite superior da caixa - tamanho do pacman em R6
	CMP R0, R6							; compara a linha atual com o limite 
	JZ verifica_baixo					; se for igual vai verificar as colunas 
	JNZ desenha_baixo					; se passar nas verificações -> desenha
	verifica_baixo:						
		MOV R6, 19H						; coloca o valor da coluna da esquerda da caixa - tamanho do pacman em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JLT desenha_baixo				; se estiver à esquerda pode desenhar 
		MOV R6, 28H						; coloca o valor da coluna direita da caixa em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JLT sai_baixo					; se estiver entre os limites das caixa sai ficando na posição atual 
		JGT desenha_baixo				; se estiver à direita da caixa pode desenhar 
	desenha_baixo:
		CALL adiciona_linha				; adiciona uma linha 
		ADD R7,1 
		RET 
	sai_baixo:
		RET   

; ************************************************************************
; *	Nome:	baixo_direita   							
; *	Descricao:	função que verifica se é possivel andar para baixo 
; * 			e para a direita. Se possivel adiciona uma linha e uma coluna
; ************************************************************************
baixo_direita:			
	MOV R6, 1BH							; coloca a linha limite inferior do ecrã em R6
	CMP R0, R6							; compara a linha atual com o limite 
	JZ sai_baixo_direita				; se for igual sai mantendo a posição atual
	MOV R6, 3CH							; coloca o limite direito do ecrã em R6
	CMP R1, R6							; compara a coluna atual com o limite 
	JZ sai_baixo_direita				; se for igual sai mantendo a posição atual
	MOV R6, 7H							; coloca o limite superior da caixa em R6
	CMP R0, R6							; compara a linha atual com o limite 
	JZ verifica_baixo_direita			; se for igual vai verificar as colunas
	MOV R6, 18H							; coloca a coluna limite esquerdo da caixa em R6
	CMP R1, R6							; compara a coluna atual com o limite 
	JZ verifica_baixo_direita_2			; se for igual vai verificar as linhas 
	JNZ desenha_baixo_direita			; se passar nas verificações desenha 
	verifica_baixo_direita:
		MOV R6, 18H						; coloca o limite esquerdo da caixa - tamanho do pacman em R6
		CMP R1, R6						; compara a coluna atual com o limite 
		JLT desenha_baixo_direita		; se estiver à esquerda pode desenhar 
		MOV R6, 27H						; coloca o limite direito da caixa em R6
		CMP R1, R6						; compara a coluna atual com o limite da caixa 
		JGT desenha_baixo_direita		; se estiver à direita da caixa pode desenhar 
		JLT sai_baixo_direita			; se estiver entre os limites da caixa sai mantendo a posiçaõ atual 	
	verifica_baixo_direita_2:
		MOV R6, 8H						; coloca o limite superior da caixa - tamanho do pacman em R6 
		CMP R0, R6						; compara a linha atual com o limite 
		JLT desenha_baixo_direita		; se estiver por cima da caixa (no ecrã) pode desenhar 
		MOV R6, 13H						; coloca o limite inferior da caixa em R6
		CMP R0, R6						; compara a linha atual com o limite 
		JGT desenha_baixo_direita		; se estiver por baixo da caixa (no ecrã) pode desenhar 
		JLT sai_baixo_direita			; se estiver entre os limites sai mantendo a posição atual 
	desenha_baixo_direita:
		CALL adiciona_linha				; adiciona uma linha 
		CALL adiciona_coluna			; adiciona uma coluna
		ADD R7, 1
		RET
	sai_baixo_direita: 
		RET 

; ************************************************************************
; *	Funções auxiliares 
; ************************************************************************	
adiciona_coluna:
	ADD R1, 1								; adiciona 1 a R1
	RET
		
adiciona_linha:
	ADD R0, 1								; adiciona 1 a R0
	RET 
		
subtrai_coluna: 
	SUB R1, 1								; subtrai 1 a R1
	RET
		
subtrai_linha:
	SUB R0, 1								; subtrai 1 a R0 
	RET 
	
; ************************************************************************
; *	Nome:	movimenta_pacman 						
; *	Descricao:	função responsável pela movimentação do pacman 
; ************************************************************************
movimenta_pacman:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4 
	PUSH R5
	PUSH R6 
	PUSH R7 
	PUSH R8
	PUSH R9 
	PUSH R10 
	MOV R0, [sitio_pacman_aberto]			; coloca a linha do fantasma em R0
	MOV R1, [sitio_pacman_aberto+2]			; coloca a coluna do fantasma em R1
	MOV R8, [sitio_pacman_aberto]			; coloca a linha do fantasma em R0
	MOV R9, [sitio_pacman_aberto+2]
	MOV R5, [tecla_carregada]				; coloca a tecla carregada em R0
	SUB R5, 1
	MOV R10, 1
	MOV R7, 0
	MOV R6, 10H
	CMP R6, R5 
	JZ sai_movimenta_pacman_2
	tecla_zero:
		MOV R6, TECLA_0
		CMP R6, R5 
		JNZ tecla_um
		CALL apaga_pacman
		CALL cima_esquerda
		JMP sai_movimenta_pacman
	tecla_um:
		MOV R6, TECLA_1
		CMP R6, R5 
		JNZ tecla_dois 
		CALL apaga_pacman
		CALL cima
		JMP sai_movimenta_pacman
	tecla_dois:
		MOV R6, TECLA_2
		CMP R6, R5 
		JNZ tecla_quatro
		CALL apaga_pacman
		CALL cima_direita
		JMP sai_movimenta_pacman
	tecla_quatro:
		MOV R6, TECLA_4
		CMP R6, R5 
		JNZ tecla_seis 
		CALL apaga_pacman
		CALL esquerda
		JMP sai_movimenta_pacman
	tecla_seis:
		MOV R6, TECLA_6
		CMP R6, R5 
		JNZ tecla_oito
		CALL apaga_pacman
		CALL direita
		JMP sai_movimenta_pacman
	tecla_oito:
		MOV R6, TECLA_8
		CMP R6, R5 
		JNZ tecla_nove 
		CALL apaga_pacman
		CALL baixo_esquerda
		JMP sai_movimenta_pacman
	tecla_nove:
		MOV R6, TECLA_9
		CMP R6, R5 
		JNZ tecla_a 
		CALL apaga_pacman
		CALL baixo
		JMP sai_movimenta_pacman
	tecla_a:
		MOV R6, TECLA_A
		CMP R6, R5 
		JNZ sai_movimenta_pacman_2
		CALL apaga_pacman
		CALL baixo_direita
		JMP sai_movimenta_pacman
	sai_movimenta_pacman:
		MOV [sitio_pacman_aberto], R0
		MOV [sitio_pacman_aberto+2], R1
		CALL desenha_pac_aberto
	sai_movimenta_pacman_2:
		POP R10
		POP R9
		POP R8
		POP R7
		POP R6
		POP R5
		POP R4
		POP R3
		POP R2
		POP R1
		POP R0 
		RET 
			
; ************************************************************************
; *	Funções auxiliares da movimentação do pacman 
; ************************************************************************
apaga_pacman:								
	CALL tira_cor_pacman					; tira a cor do pacman
	CALL desenha_pac_aberto					; apaga o pacman da sua posição atual 
	CALL poe_cor_pacman						; volta a por cor no pacman 
	RET 
	
tira_cor_pacman:
	MOV  R4, 0								; coloca 0 em R5
	MOV  [sitio_pacman_aberto+4], R4 		; coloca R5 no endereço da cor do pacman 
	RET
		
poe_cor_pacman:    
	MOV R4, COR_PAC							; coloca a cor do pacman em R4 
	MOV  [sitio_pacman_aberto+4], R4 		; coloca R4 no endereço da cor do pacman 
	RET

; ************************************************************************
; *	Nome:	movimenta_fantasma							
; *	Descricao:	função responsável pelo movimento dos fantasmas 
; ************************************************************************	
movimenta_fantasma:
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8 
	PUSH R9 
	JNZ sai_movimenta_fantasma
	MOV R4, [sitio_pacman_aberto]			; coloca em R4 a linha da posição do pacman
	MOV R5, [sitio_pacman_aberto+2]			; coloca em R5 a coluna da posição do pacman 
	
	MOV R9, 8
	CMP R10, R9
	JGE compara_posicoes
	JLT sobe_fantasma
	
	compara_posicoes:
		CMP R0, R4							; compara a linha da posição do fantasma com a do pacman
		JZ laterais_fantasma				; se estiverem na mesma linha vai verificar as colunas 
		CMP R1, R5							; compara a coluna da posição do fantasma com a do pacman 
		JZ verticais_fantasma				; se estiverem na mesma coluna vai verificar as linhas 
		CMP R0, R4							; compara a linha da posição do fantasma com a do pacman
		JLT verifica_lado_cima				; se for menor vai verificar de que lado está em comparação ao pacman
		JGT verifica_lado_baixo 			; se for maior vai verificar de que lado está em comparação ao pacman
		
	laterais_fantasma:
		CMP R1, R5 							; compara a coluna da posição do fantasma com a do pacman 
		JGT esquerda_fantasma				; se a coluna for maior está à direita do pacman
		JLT direita_fantasma				; se a coluna for menor está à esquerda do pacman 
		direita_fantasma:
			SUB R0, 1						; subtrai 1 à linha do fantasma
			CALL direita 					; adiciona uma coluna à posição do fantasma 
			ADD R0, 1						; adiciona 1 à linha do fantasma
			JMP sai_movimenta_fantasma
		esquerda_fantasma:					
			SUB R0, 1						; subtrai 1 à linha do fantasma
			CALL esquerda 					; subtrai uma coluna à posição do fantasma 
			ADD R0, 1						; adiciona 1 à linha do fantasma
			JMP sai_movimenta_fantasma
	
	verticais_fantasma:
		CMP R0, R4							; compara a linha da posição do fantasma com a do pacman
		JGT sobe_fantasma					; se for maior o fantasma está por baixo do pacman 
		JLT desce_fantasma					; se for menor o fantasma está por cima do pacman 
		sobe_fantasma:
			SUB R0, 1						; subtrai 1 à linha do fantasma
			CALL cima						; subtrai uma linha (sobre no ecrã) à linha atual do fantasma 
			ADD R0, 1						; adiciona 1 à linha do fantasma
			JMP sai_movimenta_fantasma
		desce_fantasma:
			CALL baixo 						; adiciona uma linha (desce no ecrã) ao fantasma 
			JMP sai_movimenta_fantasma
	
	verifica_lado_cima:
		CMP R1, R5 							; compara a coluna do fantasma com a do pacman 
		JLT esquerda_baixo					; se for menor está à esquerda 
		JGT direita_baixo					; se for maior está à direita 
		esquerda_baixo:	
			SUB R0, 1						; subtrai 1 à linha do fantasma 
			CALL baixo_direita
			ADD R0, 1						; adiciona 1 à linha do fantasma
			JMP sai_movimenta_fantasma
		direita_baixo:
			SUB R0, 1						; subtrai 1 à linha do fantasma
			CALL baixo_esquerda 
			ADD R0, 1						; adiciona 1 à linha do fantasma
			JMP sai_movimenta_fantasma
			
	verifica_lado_baixo:
		CMP R1, R5 							; compara a coluna do fantasma com a do pacman  
		JLT esquerda_cima					; se for menor está à esquerda 
		JGT direita_cima 					; se for maior está à direita 
		esquerda_cima:
			SUB R0, 1						; subtrai 1 à linha do fantasma
			CALL cima_direita  
			ADD R0, 1						; adiciona 1 à linha do fantasma
			JMP sai_movimenta_fantasma
		direita_cima:
			SUB R0, 1						; subtrai 1 à linha do fantasma
			CALL cima_esquerda
			ADD R0, 1						; adiciona 1 à linha do fantasma
			JMP sai_movimenta_fantasma
			
	sai_movimenta_fantasma:
		POP R9 
		POP R8 	
		POP R7
		POP R6
		POP R5
		POP R4
		RET 


; ************************************************************************
; *	Funções auxiliares do movimento dos fantasmas 
; ************************************************************************
tira_cor_fantasmas:
	MOV  R2, 0								; coloca 0 em R2
	MOV  [cor_fantasmas], R2				; coloca R2 no endereço onde está a cor dos fantasmas 
	RET
		
poe_cor_fantasmas:    						
	MOV R2, COR_FANT						; coloca a cor dos fantasmas em R2 
	MOV  [cor_fantasmas], R2 				; coloca R2 no endereço onde está a cor dos fantasmas 
	RET

; ************************************************************************
; *	Nome:	fantasma_1							
; *	Descricao:	função responsável pelo fantasma 1
; ************************************************************************
fantasma_1:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R10 
	MOV R0, [sitio_fantasma_1]				; coloca a linha do fantasma em R0
	MOV R1, [sitio_fantasma_1+2]			; coloca a coluna do fantasma em R1
	MOV R2, [cor_fantasmas]					; coloca a cor do pacman em R2
	MOV R3, 0								; coloca 0 em R3 
	MOV R10, [sitio_fantasma_1+4]			; coloca o valor da movimentação do fantasma em R10
	CMP R3, R10								; compara se é zero 
	JZ primeiro_fantasma_1					; se for zero desenha o fantasma dentro da caixa 
	JNZ movimenta_fantasma_1				; se nao for zero vai movimententar o fantasma 
	primeiro_fantasma_1:
		CALL desenha_fantasma_1				; desenha o fantasma dentro da caixa 
		ADD R10, 1							; adiciona 1 a R10 
		MOV [sitio_fantasma_1+4], R10		; coloca R10 na movimentação do fantasma 1
		JMP sai_fantasma_1
	movimenta_fantasma_1:
		ADD R10, 1							; adiciona 1 a R10 
		MOV [sitio_fantasma_1+4], R10		; coloca R10 na movimentação do fantasma 1
		CALL tira_cor_fantasmas				; tira a cor dos fantasmas 
		CALL desenha_fantasma_1				; apaga o fantasma da sua posição atual 
		CALL poe_cor_fantasmas				; poe cor no fantasma 
		CALL movimenta_fantasma				; movimenta o fantasma 
		MOV [sitio_fantasma_1], R0			; coloca a nova linha no endereço da linha do fantasma 
		MOV [sitio_fantasma_1+2], R1 		; coloca a nova coluna no endereço da coluna do fantasma 
		CALL desenha_fantasma_1				; desenha o fantasma na nova posição 
	sai_fantasma_1:
		POP R10
		POP R3
		POP R2
		POP R1
		POP R0 
		RET 

; ************************************************************************
; *	Nome:	fantasma_2							
; *	Descricao:	função responsável pelo fantasma 2
; ************************************************************************
fantasma_2:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R10 	
	MOV R0, [sitio_fantasma_2]				; coloca a linha do fantasma em R0
	MOV R1, [sitio_fantasma_2+2]			; coloca a coluna do fantasma em R1
	MOV R2, [cor_fantasmas]					; coloca a cor do pacman em R2
	MOV R3, 0								; coloca 0 em R3 
	MOV R10, [sitio_fantasma_2+4]			; coloca o valor da movimentação do fantasma em R10
	CMP R3, R10 							; compara se é zero 
	JZ primeiro_fantasma_2					; se for zero desenha o fantasma dentro da caixa 
	JNZ movimenta_fantasma_2				; se nao for zero vai movimententar o fantasma 
	primeiro_fantasma_2:
		CALL desenha_fantasma_2				; desenha o fantasma dentro da caixa 
		ADD R10, 1
		MOV [sitio_fantasma_2+4], R10
		JMP sai_fantasma_2	
	movimenta_fantasma_2:
		ADD R10, 1
		MOV [sitio_fantasma_2+4], R10
		CALL tira_cor_fantasmas				; tira a cor dos fantasmas 
		CALL desenha_fantasma_2				; apaga o fantasma 
		CALL poe_cor_fantasmas				; poe cor no fantasma
		CALL movimenta_fantasma				; movimenta o fantasma 
		MOV [sitio_fantasma_2], R0			; coloca a nova linha no endereço da linha do fantasma 
		MOV [sitio_fantasma_2+2], R1 		; coloca a nova coluna no endereço da coluna do fantasma
		CALL desenha_fantasma_2				; desenha o fantasma na nova posição 
	sai_fantasma_2:
		POP R10
		POP R3
		POP R2
		POP R1
		POP R0 
		RET 

; ************************************************************************
; *	Nome:	fantasma_3							
; *	Descricao:	função responsável pelo fantasma 3
; ************************************************************************
fantasma_3:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R10 	
	MOV R0, [sitio_fantasma_3]				; coloca a linha do fantasma em R0
	MOV R1, [sitio_fantasma_3+2]			; coloca a coluna do fantasma em R1
	MOV R2, [cor_fantasmas]					; coloca a cor do pacman em R2
	MOV R3, 0								; coloca 0 em R3
	MOV R10, [sitio_fantasma_3+4]			; coloca o valor da movimentação do fantasma em R10
	CMP R3, R10 							; compara se é zero 
	JZ primeiro_fantasma_3					; se for zero desenha o fantasma dentro da caixa 
	JNZ movimenta_fantasma_3				; se nao for zero vai movimententar o fantasma 
	primeiro_fantasma_3:
		CALL desenha_fantasma_3
		ADD R10, 1
		MOV [sitio_fantasma_3+4], R10
		JMP sai_fantasma_3	
	movimenta_fantasma_3:
		ADD R10, 1
		MOV [sitio_fantasma_3+4], R10
		CALL tira_cor_fantasmas				; tira a cor dos fantasmas 
		CALL desenha_fantasma_3				; apaga o fantasma 
		CALL poe_cor_fantasmas				; poe cor no fantasma
		CALL movimenta_fantasma				; movimenta o fantasma 
		MOV [sitio_fantasma_3], R0			; coloca a nova linha no endereço da linha do fantasma 
		MOV [sitio_fantasma_3+2], R1 		; coloca a nova coluna no endereço da coluna do fantasma
		CALL desenha_fantasma_3				; desenha o fantasma na nova posição 
	sai_fantasma_3:
		POP R10
		POP R3
		POP R2
		POP R1
		POP R0 
		RET

; ************************************************************************
; *	Nome:	fantasma_4							
; *	Descricao:	função responsável pelo fantasma 4
; ************************************************************************
fantasma_4:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R10 
	MOV R0, [sitio_fantasma_4]				; coloca a linha do fantasma em R0
	MOV R1, [sitio_fantasma_4+2]			; coloca a coluna do fantasma em R1
	MOV R2, [cor_fantasmas]					; coloca a cor do pacman em R2
	MOV R3, 0								; coloca 0 em R3
	MOV R10, [sitio_fantasma_4+4]			; coloca o valor da movimentação do fantasma em R10
	CMP R3, R10								; compara se é zero 
	JZ primeiro_fantasma_4					; se for zero desenha o fantasma dentro da caixa 
	JNZ movimenta_fantasma_4				; se nao for zero vai movimententar o fantasma 
	primeiro_fantasma_4:
		CALL desenha_fantasma_4
		ADD R10, 1
		MOV [sitio_fantasma_4+4], R10
		JMP sai_fantasma_4
	movimenta_fantasma_4:
		ADD R10, 1
		MOV [sitio_fantasma_4+4], R10
		CALL tira_cor_fantasmas				; tira a cor dos fantasmas 
		CALL desenha_fantasma_4				; apaga o fantasma 
		CALL poe_cor_fantasmas				; por cor no fantasma 
		CALL movimenta_fantasma				; movimenta o fantasma 
		MOV [sitio_fantasma_4], R0			; coloca a nova linha no endereço da linha do fantasma 
		MOV [sitio_fantasma_4+2], R1 		; coloca a nova coluna no endereço da coluna do fantasma
		CALL desenha_fantasma_4				; desenha o fantasma na nova posição 
	sai_fantasma_4:
		POP R10
		POP R3
		POP R2
		POP R1
		POP R0 
		RET	

; ************************************************************************
; *	Nome:	responsavel_fantasmas							
; *	Descricao:	função responsável pelo numero de fantasmas em jogo
; ************************************************************************
responsavel_fantasmas:
	PUSH R0
	PUSH R1
	PUSH R2 
	MOV R2, 0
	MOV R0, NUM_FANTASMAS					; coloca o numero de fantasmas em R0
	MOV R1, [numero_fantasmas]				; coloca o numero de fantasmas ativos em R1
	CMP R2, R1 								; se o numero de fantasmas for zero -> sai 
	JZ sai_responsavel_fantasmas
	ADD R1, 1								; adiciona 1 a R1 
	CMP R0, R1 								; compara se o numero de fantasmas é 1
	JZ um									; se for -> um 
	ADD R1, 1								; adiciona 1 a R1 
	CMP R0, R1								; compara se o numero de fantasmas é 2
	JZ dois 								; se for -> dois 
	ADD R1, 1								; adiciona 1 a R2
	CMP R0, R1								; compara se o numero de fantasmas é 3
	JZ tres									; se for -> tres 
	ADD R1, 1								; adiciona 1 a R1 
	CMP R0, R1								; compara se o numero de fantasmas é 4
	JZ quatro								; se for -> quatro 
	um:
		CALL fantasma_1
		JMP sai_responsavel_fantasmas	
	dois:
		CALL fantasma_1
		CALL fantasma_2
		JMP sai_responsavel_fantasmas
	tres:
		CALL fantasma_1
		CALL fantasma_2
		CALL fantasma_3
		JMP sai_responsavel_fantasmas
	quatro:
		CALL fantasma_1
		CALL fantasma_2
		CALL fantasma_3
		CALL fantasma_4
		JMP sai_responsavel_fantasmas
	sai_responsavel_fantasmas:
		POP R2
		POP R1
		POP R0
		RET 

; ************************************************************************
; *	Nome:	come_cruzes 							
; *	Descricao:	função responsável por verificar se o pacman come as cruzes 
; ************************************************************************
come_cruzes:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4 
	PUSH R5 
	PUSH R6 
	PUSH R7 
	PUSH R10
	PUSH R11
	MOV R0, [sitio_pacman_aberto]			; coloca a linha do pacman em R0
	MOV R1, [sitio_pacman_aberto+2]			; coloca a coluna do pacman em R1 
	MOV R4, [cor_cruzes]					; coloca a cor das cruzes em R4 
	MOV R6, 0								; coloca 0 em R6 
	MOV R7, [numero_cruzes_comidas]			; coloca o numero de cruzes comidas em R7 
	MOV R2, 5H								; coloca a linha 5 em R2 
	CMP R0, R2								; compara o pacman com a linha 5
	JLT cruz_1								; se estiver a cima (no ecrã) -> cruz_1
	MOV R2, 16H								; coloca a linha 22 em R2 
	CMP R0, R2								; compara o pacman com a linha 22
	JGT cruz_3								; se estiver a baixo (no ecrã) -> cruz_3
	JMP sai_come_cruzes
	cruz_1:									; cruz de cima da esquerda 
		MOV R3, 5H							; coloca a coluna 5 em R3 
		CMP R1, R3							; compara a coluna do pacman com a coluna 5
		JGE cruz_2							; se for igual ou estiver à direita (no ecrã) -> cruz_2
		MOV R5, [sitio_x_cima_esquerda+4]	; coloca o valor de aceso/apagado em R5
		CMP R5, R6							; compara se a cruz está acesa ou apagada 
		JNZ sai_come_cruzes					; se não for zero ja está apagada -> sai 
		CALL tira_cor_cruzes				; tira a cor da cruz 
		CALL desenha_x_cima_esquerda		; apaga a cruz 
		CALL poe_cor_cruzes					; volta a por cor
		ADD R5, 1							; adiciona 1 a R5 
		MOV [sitio_x_cima_esquerda+4], R5 	; coloca R5 no endereço de aceso/apagado da cruz 
		ADD R7, 1							; adiciona 1 a R7
		MOV [numero_cruzes_comidas], R7		; coloca R7 no endereço do numero de cruzes apagadas
		JMP sai_come_cruzes			
		
	cruz_2:									; cruz de cima da direita 
		MOV R3, 37H							; coloca a coluna 55 em R3 		
		CMP R1, R3							; compara a posição do pacman com a linha 55 
		JLE sai_come_cruzes					; se for igual ou estiver à esquerda (no ecrã) -> sai
		MOV R5, [sitio_x_cima_direita+4]	; coloca o valor de aceso/apagado em R5 
		CMP R5, R6							; compara se a cruz está acesa ou apagada 
		JNZ sai_come_cruzes					; se não for zero ja está apagada -> sai 
		CALL tira_cor_cruzes				; tira a cor da cruz 
		CALL desenha_x_cima_direita			; apaga a cruz 
		CALL poe_cor_cruzes					; volta a por cor 
		ADD R5, 1							; adiciona 1 a R5 
		MOV [sitio_x_cima_direita+4], R5 	; coloca R5 no endereço de aceso/apagado da cruz 
		ADD R7, 1							; adiciona 1 a R7
		MOV [numero_cruzes_comidas], R7		; coloca R7 no endereço do numero de cruzes apagadas
		JMP sai_come_cruzes
		
	cruz_3:									; cruz ed baixo da esquerda 
		MOV R3, 5H							; coloca a coluna 5 em R3 
		CMP R1, R3							; compara a coluna do pacman com a coluna 5
		JGE cruz_4							; se for igual ou estiver à direita (no ecrã) -> cruz_4 
		MOV R5, [sitio_x_baixo_esquerda+4]	; coloca o valor de aceso/apagado em R5
		CMP R5, R6							; verifica se a cruz está acesa ou apagada 
		JNZ sai_come_cruzes					; se estiver apagada -> sai 
		CALL tira_cor_cruzes				; tira a cor da cruz 
		CALL desenha_x_baixo_esquerda		; apaga a cruz 
		CALL poe_cor_cruzes					; coloca a cor de volta 
		ADD R5, 1							; adiciona 1 a R5 
		MOV [sitio_x_baixo_esquerda+4], R5	; coloca R5 no endereço de aceso/apagado da cruz 
		ADD R7, 1							; adiciona 1 a R7
		MOV [numero_cruzes_comidas], R7		; coloca R7 no endereço do numero de cruzes apagadas
		JMP sai_come_cruzes
		
	cruz_4:
		MOV R3, 37H							; coloca a coluna 55 em R3 
		CMP R1, R3							; compara a coluna do pacman com a coluna 55 
		JLE sai_come_cruzes					; se for igual ou estiver à esquerda (no ecrã) -> sai 
		MOV R5, [sitio_x_baixo_direita+4]	; coloca o valor de aceso/apagado em R5
		CMP R5, R6							; verifica se a cruz está acesa ou apagada 
		JNZ sai_come_cruzes					; se nao for zero -> sai 
		CALL tira_cor_cruzes				; tira a cor da cruz 
		CALL desenha_x_baixo_direita		; apaga a cruz 
		CALL poe_cor_cruzes					; coloca cor de volta 
		ADD R5, 1							; adiciona 1 a R5 
		MOV [sitio_x_baixo_direita+4], R5	; coloca R5 no endereço de aceso/apagado da cruz 
		ADD R7, 1							; adiciona 1 a R7
		MOV [numero_cruzes_comidas], R7		; coloca R7 no endereço do numero de cruzes apagadas
		JMP sai_come_cruzes
		
	sai_come_cruzes:
		POP R11
		POP R10
		POP R7
		POP R6
		POP R5
		POP R4
		POP R3
		POP R2
		POP R1
		POP R0
		RET 
	
; ************************************************************************
; *	Funções auxiliares da função come_cruzes  
; ************************************************************************		
tira_cor_cruzes:	
	MOV R4, 0								; coloca 0 em R4 
	MOV [cor_cruzes], R4					; coloca R4 no endereço da cor das cruzes 
	RET 
poe_cor_cruzes:
	MOV R4, COR_VERMELHO					; coloca a cor vermelho em R4 
	MOV [cor_cruzes], R4 					; coloca R4 no endereço da cor daas cruzes 
	RET 

; ************************************************************************
; *	Nome:	colisoes							
; *	Descricao:	função responsável por detetar colisoes
; ************************************************************************
;colisoes:										
;	PUSH R0 
;	PUSH R1
;	PUSH R2
;	PUSH R3
;	PUSH R4
;	PUSH R6
;	PUSH R7
;	PUSH R8
;	PUSH R9
;	PUSH R10
;	MOV R0, [sitio_pacman_aberto]		; Coloca edereçoo da primeira linha do pacman em R0
;	MOV R1, [sitio_pacman_aberto+2]		; Coloca edereçoo da primeira coluna do pacman em R1
;	MOV R7, [sitio_pacman_aberto]		; Coloca edereçoo da primeira linha do pacman em R7
;	MOV R8, [sitio_pacman_aberto+2]		; Coloca edereçoo da primeira coluna do pacman em R8
;	ADD R7, 4							; Adiciona 4 a R7, para obter a ultima a linha do pacman
;	ADD R8, 3			  				; Adiciona 3 ao R8, para obter a ultima a coluna do pacman
;	verifica_fantasma_1:
;		MOV R2, [sitio_fantasma_1]   	; Coloca edereçoo da primeira linha do fantasma 1 em R2
;		MOV R3, [sitio_fantasma_1+2] 	; Coloca edereçoo da primeira coluna do fantasma 1 em R3
;		MOV R6, [sitio_fantasma_1]   	; Coloca edereçoo da primeira linha do fantasma 1 em R6
;		MOV R9, [sitio_fantasma_1+2] 	; Coloca edereçoo da primeira coluna do fantasma 1 em R9
;		ADD R6, 3						; Adiciona 3 a R6, para obter a ultima a linha do fantasma 1
;		ADD R9, 3						; Adiciona 3 a R9, para obter a ultima a coluna do fantasma 1
;		CMP R8, R3						; Compara se o pacman e o fantasma 1 colidem pela esquerda do fantasma 1
;		JZ colidiu_f_1
;		CMP R1, R9						; Compara se o pacman e o fantasma 1 colidem pela direita do fantasma 1
;		JZ colidiu_f_1
;		CMP R7, R2						; Compara se o pacman e o fantasma 1 colidem por cima do fantasma 1
;		JZ colidiu_f_1
;		CMP R6, R0						; Compara se o pacman e o fantasma 1 colidem por baixo do fantasma 1
;		JZ colidiu_f_1
;		JMP sai_colisoes
;	verifica_fantasma_2:
;		MOV R2, [sitio_fantasma_2]  	; Codigo semelhante ao anterior para o fantasma 2
;		MOV R3, [sitio_fantasma_2+2] 
;		MOV R6, [sitio_fantasma_2]  
;		MOV R9, [sitio_fantasma_2+2] 
;		ADD R6, 3
;		ADD R9, 3
;		CMP R8, R3
;		JZ colidiu_f_2
;		CMP R1, R9
;		JZ colidiu_f_2
;		CMP R7, R2
;		JZ colidiu_f_2
;		CMP R6, R0
;		JZ colidiu_f_2
;	verifica_fantasma_3: 				; Codigo semelhante ao anterior para o fantasma 3
;		MOV R2, [sitio_fantasma_3]  
;		MOV R3, [sitio_fantasma_3+2]
;		MOV R6, [sitio_fantasma_3]  
;		MOV R9, [sitio_fantasma_3+2]
;		ADD R6, 3
;		ADD R9, 3
;		CMP R8, R3
;		JZ colidiu_f_3
;		CMP R1, R9
;		JZ colidiu_f_3
;		CMP R7, R2
;		JZ colidiu_f_3
;		CMP R6, R0
;		JZ colidiu_f_3
;	verifica_fantasma_4:				; Codigo semelhante ao anterior para o fantasma 4
;		MOV R2, [sitio_fantasma_4]   
;		MOV R3, [sitio_fantasma_4+2]
;		MOV R6, [sitio_fantasma_4]   
;		MOV R9, [sitio_fantasma_4+2] 
;		ADD R6, 3
;		ADD R9, 3
;		CMP R8, R3
;		JZ colidiu_f_4
;		CMP R1, R9
;		JZ colidiu_f_4
;		CMP R7, R2
;		JZ colidiu_f_4
;		CMP R6, R0
;		JZ colidiu_f_4
;		JMP sai_colisoes
;	colidiu_f_1:						; Função auxiliar da função colisoes para o fantasma 1
;		CALL tira_cor_fantasma_1 
;		CALL desenha_fantasma_1
;		CALL apaga_pacman 
;		CALL desenha_explosao
;		CALL ecra_perdeu
;		JMP sai_colisoes
;	tira_cor_fantasma_1: 
;		MOV R10, 0
;		MOV [cor_fantasmas], R10
;		RET		
;	colidiu_f_2:						; Função auxiliar da função colisoes para o fantasma 2
;		CALL tira_cor_fantasma_2 
;		CALL desenha_fantasma_2
;		CALL apaga_pacman 
;		CALL desenha_explosao
;		CALL ecra_perdeu
;		JMP sai_colisoes
;	tira_cor_fantasma_2: 
;		MOV R10, 0
;		MOV [cor_fantasmas], R10
;		RET
;	colidiu_f_3:						; Função auxiliar da função colisoes para o fantasma 3
;		CALL tira_cor_fantasma_3
;		CALL desenha_fantasma_3
;		CALL apaga_pacman 
;		CALL desenha_explosao
;		CALL ecra_perdeu
;		JMP sai_colisoes
;	tira_cor_fantasma_3: 		
;		MOV R10, 0
;		MOV [cor_fantasmas], R10
;		RET
;	colidiu_f_4:						; Função auxiliar da função colisoes para o fantasma 4
;		CALL tira_cor_fantasma_4
;		CALL desenha_fantasma_4
;		CALL apaga_pacman 
;		CALL desenha_explosao
;		CALL ecra_perdeu
;		JMP sai_colisoes
;	tira_cor_fantasma_4: 
;		MOV R10, 0
;		MOV [cor_fantasmas], R10
;		RET
;	sai_colisoes:
;		POP R10
;		POP R9
;		POP R8
;		POP R7
;		POP R6
;		POP R5
;		POP R4
;		POP R3
;		POP R2
;		POP R1
;		POP R0
		
; ************************************************************************
; *	Nome: colisoes_2 														 
; *	Descricao: função que compara a posição de referência do pacman
; * 			com a posição de referência do fantasma 1.	 	
; ************************************************************************
colisoes_2:
	PUSH R0 
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	MOV R0, [sitio_pacman_aberto]			; linha do pacman 
	MOV R1, [sitio_pacman_aberto+2]			; coluna do pacman 
	verifica_1:
		MOV R2, [sitio_fantasma_1]			; linha do fantasma 1
		MOV R3, [sitio_fantasma_1+2]		; coluna do fantasma 1
		CMP R0, R2							; compara as linhas 
		JNZ sai_colisoes_2					; se forem diferentes -> sai 
		CMP R1, R3							; compara as colunas 
		JZ sai_tocou						; se for igual -> sai tocou 
		JNZ sai_colisoes_2					; se não for igual -> sai 
	sai_tocou:
		MOV R4, [toca_fantasmas]		
		ADD R4, 1
		MOV [toca_fantasmas], R4 
	sai_colisoes_2:
		POP R4	
		POP R3
		POP R2
		POP R1
		POP R0
		RET 
		
; ************************************************************************
; *	Nome: ecra_inicial														 
; *	Descricao: função que coloca a imagem inicial no fundo	 	
; ************************************************************************
ecra_inicial:									 
	PUSH R0
	PUSH R7
	MOV R7, ECRA6						; Por o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, IMAGEM_INICIAL				; coloca o nº da imagem no R0
	MOV [DEFINE_IMA], R0				; coloca a imagem no fundo 
	POP R7
	POP R0
	RET

; ************************************************************************
; *	Nome: fundo														 
; *	Descricao: função que coloca a imagem de fundo para o jogo	 	
; ************************************************************************
fundo:	 
	PUSH R0
	PUSH R7
	MOV R7, ECRA6						; Por o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, IMAGEM_FUNDO				; coloca o nº da imagem no R0
	MOV [DEFINE_IMA], R0				; coloca a imagem no fundo 
	POP R7
	POP R0
	RET

; ************************************************************************
; *	Nome: pausa														 
; *	Descricao: função que coloca a imagem de pausa no fundo	 	
; ************************************************************************
ecra_pausa:									 
	PUSH R0
	PUSH R7
	MOV R7, ECRA6						; Por o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, IMAGEM_PAUSA				; coloca o nº da imagem no R0
	MOV [DEFINE_IMA], R0				; coloca a imagem no fundo 
	POP R7
	POP R0
	RET

; ************************************************************************
; *	Nome: ecra_ganhou														 
; *	Descricao: função que coloca a imagem de jogo ganho	 	
; ************************************************************************
ecra_ganhou:									 
	PUSH R0
	PUSH R2
	PUSH R7 
	MOV R7, ECRA1						; Por o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, IMAGEM_GANHOU				; coloca o nº da imagem no R0
	MOV [DEFINE_IMA], R0				; coloca a imagem no fundo 
	POP R7
	POP R2
	POP R0
	RET

; ************************************************************************
; *	Nome: ecra_perdeu														 
; *	Descricao: função que coloca a imagem de jogo perdido	 	
; ************************************************************************
ecra_perdeu:									 
	PUSH R0
	PUSH R2
	PUSH R7 
	MOV R7, ECRA1						; Por o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, IMAGEM_PERDEU				; coloca o nº da imagem no R0
	MOV [DEFINE_IMA], R0				; coloca a imagem no fundo 
	POP R7
	POP R2
	POP R0
	RET

; ************************************************************************
; *	Nome: ecra_final														 
; *	Descricao: função que coloca a imagem de jogo terminado	 	
; ************************************************************************
ecra_final:									 
	PUSH R0
	PUSH R2
	PUSH R7 
	MOV R7, ECRA1						; Por o valor do ecra selecionado em R7
	MOV [DEFINE_ECRA], R7
	MOV R0, IMAGEM_FINAL				; coloca o nº da imagem no R0
	MOV [DEFINE_IMA], R0				; coloca a imagem no fundo 
	POP R7
	POP R2
	POP R0
	RET

; ************************************************************************
; *	Nome: apaga_ecras														 
; *	Descricao: função que apaga tudo do ecrã  	
; ************************************************************************
apaga_ecras:
	PUSH R0 
	MOV [APAGA_TUDO], R0 
	POP R0 
	RET 

; ************************************************************************
; *	Nome: spawn														 
; *	Descricao: função que origina mais fantasmas 	
; ************************************************************************
spawn:
	PUSH R0 
	PUSH R1 
	PUSH R2 
	MOV R2, 0
	MOV R0, [numero_fantasmas+2]			; coloca o numero dado pelo contador aleatório em R0 
	MOV R1, 3								; coloca 3 em R1 
	MOD R0, R1 								; coloca o resto da divisão inteira em R0 
	CMP R0, R2								; compara se é zero 
	JZ adiciona_fantasma					; se é zer0 -> adiciona_fantasma
	JNZ sai_spawn							; se não é zero -> sai 
	adiciona_fantasma:
		MOV R0, [numero_fantasmas]			; coloca o numero de fantasmas em R0 
		ADD R0, 1							; adiciona 1 a R0 	
		MOV [numero_fantasmas], R0 			; coloca R0 no endereço do numero de fantasmas 
		JMP sai_spawn 
	sai_spawn:
		POP R2
		POP R1
		POP R0
		RET 