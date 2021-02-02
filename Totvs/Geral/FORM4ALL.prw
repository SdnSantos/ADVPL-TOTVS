#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TRYEXCEPTION.CH"


User Function FORM4ALL()                        

	Local _aTelaF  		:= MsAdvSize( .F., .F., 1024 )		// Size da Dialog
	Local oFuncao
	Local cFuncao := Space(2000)
	Local oSay1
	Static oDlgF

	DEFINE MSDIALOG oDlgF TITLE "Fórmulas - 4 AL" FROM _aTelaF[1],_aTelaF[2] TO _aTelaF[6] , _aTelaF[5] COLORS 0, 16777215 PIXEL

	@ 043, 029 SAY oSay1 PROMPT "Coloque sua Função: " SIZE 121, 007 OF oDlgF COLORS 0, 16777215 PIXEL
	@ 051, 029 MSGET oFuncao VAR cFuncao SIZE 200, 010 OF oDlgF picture "@!" COLORS 0, 16777215 PIXEL 
	
	@ 051, 241 BUTTON oBtnExecutar PROMPT "Executar" SIZE 037, 012 OF oDlgF PIXEL Action(fExeForm(AllTrim(cFuncao)) )
	
	@ 051, 292 BUTTON oBtnSair PROMPT "Sair" SIZE 037, 012 OF oDlgF PIXEL    Action(oDlgF:End() )

	ACTIVATE MSDIALOG oDlgF CENTERED

Return()

 	
Static Function fExeForm(cFuncao)

	 TRYEXCEPTION
		MsgRun("Executando Rotina: "+cFuncao, "Aguarde", {||  &(cFuncao) })
		Msginfo("Rotina Encerrada!","Atenção [FORMULA4ALL]")
    CATCHEXCEPTION USING oException
        MsgStop("ERRO na Sentença: "+OemToAnsi(oException:Description),"Mais Atenção")
    ENDEXCEPTION

Return()