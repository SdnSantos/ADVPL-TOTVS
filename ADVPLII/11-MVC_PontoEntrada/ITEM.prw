#Include 'Totvs.ch'

/*/{Protheus.doc} User Function ITEM
  PE no cadastro de Produtos
  @type  Function
  @author user
  @since 18/02/2021
  @version 1.0
  /*/
User Function ITEM(param_name)
  /*
    Par�metro obrigat�rio nos PEs em MVC, pois eles trazem consigo informa��es 
    importantes sobre o estado e ponto de execu��o da rotina.
  */

  /*
    RETORNO NO ARRAY APARAM
    1 O Objeto do formul�rio ou do modelo, conforme o caso
    2 C ID do local de execu��o do ponto de entrada
    3 C ID do formul�rio
  */
  Local aParam      := PARAMIXB

  /*
    a vari�vel come�a com x por ser indefinida, come�a com um valor l�gico,
    mas no final pode se transformar em outro tipo e at� retornar um array
  */
  Local xRet        := .T.

  Local oObject     := aParam[1] // Objeto do formul�rio ou do modelo, conforme o caso
  Local cIdPonto    := aParam[2] // ID do local de execu��o do ponto de entrada
  Local cIdModel    := aParam[3] // ID do formul�rio

  Local cCod        := Alltrim(M->B1_COD)
  Local cDesc       := Alltrim(M->B1_DESC)

  If aParam[2] <> Nil

    // P�S VALIDA��O
    If cIdPonto == 'MODELPOS'
      If Len(cCod) < 10

        Help(NIL, NIL, 'CODPRODUTO', NIL, 'C�digo n�o permitido', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
          {'O C�digo <b> '+ cCod + ' </b> deve ter no m�nimo 10 caracteres.'})

        xRet := .F.

      Elseif Len(cDesc) < 15

        Help(NIL, NIL, 'DESCPRODUTO', NIL, 'Descri��o do Produto inv�lida', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
          {'A descri��o <b> ' + cDesc + ' </b> deve ter no m�nimo 15 caracteres.'})

        xRet := .F.

      Endif
    Endif

  Endif
 



Return xRet
