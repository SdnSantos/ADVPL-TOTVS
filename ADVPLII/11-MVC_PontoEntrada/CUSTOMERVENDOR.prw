#Include 'Totvs.ch'

/*/{Protheus.doc} User Function CustomerVendor
  Ponto de entrada no Cadastro de Fornecedores (MATA020)
  @type  Function
  @author user
  @since 19/02/2021
  @version 1.0
  /*/
User Function CustomerVendor()
  Local aParam      := PARAMIXB
  Local xRet        := .T.

  // Local oObject     := aParam[1] // Objeto do formul�rio ou do modelo, conforme o caso
  Local cIdPonto    := aParam[2] // ID do local de execu��o do ponto de entrada
  // Local cIdModel    := aParam[3] // ID do formul�rio

  Local cRazSoc     := Alltrim(M->A2_NOME)
  Local cFantasia   := Alltrim(M->A2_NREDUZ)

  If aParam[2] <> Nil

    // P�S VALIDA��O
    If cIdPonto == 'MODELPOS'
      If Len(cRazSoc) < 20

        Help(NIL, NIL, 'RAZSOC', NIL, 'Raz�o Social Inv�lida', 1, 0, NIL, NIL, NIL, NIL, NIL,;
          {'O Raz�o Social <b> '+ cRazSoc + ' </b> deve ter no m�nimo 20 caracteres.'})

        xRet := .F.

      Elseif Len(cFantasia) < 10

        Help(NIL, NIL, 'NOMEFAN', NIL, 'Nome Fantasia inv�lido', 1, 0, NIL, NIL, NIL, NIL, NIL,;
          {'O Nome Fantasia <b> ' + cFantasia + ' </b> deve ter no m�nimo 10 caracteres.'})

        xRet := .F.

      Endif
    Elseif cIdPonto == 'BUTTONBAR'

        xRet := {{'Produto x Fornecedor', 'Produto x Fornecedor', { || MATA061() }, 'Chama a amarra��o Prod x Forn'}}

    Endif
  Endif

Return xRet
