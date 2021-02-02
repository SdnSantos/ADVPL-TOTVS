#INCLUDE "TOTVS.CH"

//--------------------------------------------------------------------
/*/{Protheus.doc} Conversor
Janela de conversão de valores computacionais
@author Klaus W. Breit Junior
@since 09/2017
@version 1
/*/
//--------------------------------------------------------------------
USER FUNCTION Conversor()

	LOCAL	oDlg		    :=	NIL
	LOCAL	oFont		    :=	NIL
	LOCAL	cTipoDe		  :=	SPACE(30)
	LOCAL	oTipoDe		  :=	NIL
	LOCAL	cTipoPara	  :=	SPACE(30)
	LOCAL	oTipoPara	  :=	NIL
	LOCAL	aTipos		  :=	{'Bit','Byte','Kilobyte','Megabyte','Gigabyte','Terabyte','Petabyte'}
	LOCAL	aTech		    :=	{'1=XmlParser','2=tWSDLManager','3=Client'}
	LOCAL	oTech		    :=	NIL
	LOCAL	aProg		    :=	{'ReqXML','ReqWSDLM','ReqClient'}
	LOCAL	cTech		    :=	SPACE(1)
	LOCAL	cValor		  :=	SPACE(30)
	LOCAL	cResultado	:=	SPACE(30)
 
	DEFINE FONT oFont NAME "Mono AS" SIZE 5, 12

	DEFINE MsDialog oDlg TITLE "Conversor" FROM 3,0 TO 350, 230 PIXEL
		@ 010, 010 SAY  "Valor a Converter" SIZE 100, 007 OF oDlg PIXEL
		@ 020, 010 MSGET cValor  PICTURE "@E" SIZE 100,007 OF oDlg PIXEL
		@ 035, 010 SAY  "Converter De"  SIZE 100, 010 OF oDlg PIXEL
		@ 045, 010 MSCOMBOBOX oTipoDe	VAR cTipoDe  ITEMS aTipos SIZE 100,007 OF oDlg PIXEL
		@ 060, 010 SAY  "Converter Para" SIZE 100, 010 OF oDlg PIXEL
		@ 070, 010 MSCOMBOBOX oTipoPara VAR cTipoPara ITEMS aTipos SIZE 100,007 OF oDlg PIXEL
		
		// @ 085, 010 SAY	"Tecnologia" SIZE	100,010	OF oDlg PIXEL
		// @ 100, 010 MSCOMBOBOX oTech		VAR cTech	ITEMS aTech SIZE 100,007 OF oDlg PIXEL
		
		@ 115, 010 BUTTON "CONVERTER" SIZE 100, 015 PIXEL OF oDlg ACTION ReqXML(cValor, cTipoDe, cTipoPara, @cResultado)
		@ 135, 010 SAY  "Resultado"   SIZE 100, 020 OF oDlg PIXEL
		@ 145, 010 MSGET cResultado PICTURE "@E" SIZE 100,020 OF oDlg PIXEL WHEN .F.
	ACTIVATE MsDialog oDlg CENTER
 
RETURN

/*/{Protheus.doc} ReqXML
  (long_description)
  @type  Static Function
  @author user
  @since 07/12/2020
  @version version
  @param cValor, cTipoDe, cTipoPara, cResultado
  @return return_var, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
  /*/
Static Function ReqXML(cValor, cTipoDe, cTipoPara, cResultado)
  Local oXml        := NIL
  Local cErro       := ''
  Local cAlertas    := ''
  Local cUrl        := ''
  Local cXml        := ''

  cUrl	:=	"http://webservicex.com/ConvertComputer.asmx/ChangeComputerUnit?"
	cUrl	+=	"ComputerValue=" + cValToChar(Val(cValor))
	cUrl	+=	"&fromComputerUnit=" + Alltrim(cTipoDe)
	cUrl	+=	"&toComputerUnit=" + Alltrim(cTipoPara)

  MsgRun('Convertendo dados...', 'Aguarde', { || cXml := HTTPGET(cUrl) })

  // XMLParser executa uma requisicao http
  // _ caracter que definirá as variáveis do objeto
  oXml := XmlParser(cXml, '_', @cErro, @cAlertas)

  cResultado := oXml:_double:Text

  If cResultado $ 'INF|NaN'
    MsgInfo('Não foi possível processar os dados informados!')
  EndIf

Return 

