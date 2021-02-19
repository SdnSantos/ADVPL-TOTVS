#Include 'Totvs.ch'

/*/{Protheus.doc} User Function ITEM
  Ponto de entrada no Cadastro de Produtos (MATA010)
  @type  Function
  @author user
  @since 18/02/2021
  @version 1.0
  /*/
User Function ITEM()
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

  /*
    Pega a opera��o corrente
    1 - Pesquisar, 2 - Visualizar, 3 - Incluir, 4 - Alterar, 5 - Excluir, 
    6 - Outras Fun��es, 7 - Copiar
  */
  Local nOption     := oObject:GetOperation()  

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
    Elseif cIdPonto == 'MODELCANCEL'

      If !MsgYesNo('Tem certeza que deseja sair da tela?')

        Help(NIL, NIL, 'CANCELARINCLUSAO', NIL, 'CANCEL', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
          {'Salvar/Cancelar abortado pelo usu�rio!'})

        xRet := .F.

      Endif  

    Elseif nOption == 5 // Exclus�o

      Help(NIL, NIL, 'EXCLUIRPRODUTO', NIL, 'Exclus�o do Produto inv�lida', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
          {'O produto n�o pode ser exclu�do em hip�tese alguma. <br>' +;
          'Consulte o departamento de TI desta unidade.'})

      xRet := .F.

    Endif

  Endif

Return xRet
