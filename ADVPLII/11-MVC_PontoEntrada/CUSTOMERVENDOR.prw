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

  // Local oObject     := aParam[1] // Objeto do formulário ou do modelo, conforme o caso
  Local cIdPonto    := aParam[2] // ID do local de execução do ponto de entrada
  // Local cIdModel    := aParam[3] // ID do formulário

  Local cRazSoc     := Alltrim(M->A2_NOME)
  Local cFantasia   := Alltrim(M->A2_NREDUZ)

  If aParam[2] <> Nil

    // PÓS VALIDAÇÃO
    If cIdPonto == 'MODELPOS'
      If Len(cRazSoc) < 20

        Help(NIL, NIL, 'RAZSOC', NIL, 'Razão Social Inválida', 1, 0, NIL, NIL, NIL, NIL, NIL,;
          {'O Razão Social <b> '+ cRazSoc + ' </b> deve ter no mínimo 20 caracteres.'})

        xRet := .F.

      Elseif Len(cFantasia) < 10

        Help(NIL, NIL, 'NOMEFAN', NIL, 'Nome Fantasia inválido', 1, 0, NIL, NIL, NIL, NIL, NIL,;
          {'O Nome Fantasia <b> ' + cFantasia + ' </b> deve ter no mínimo 10 caracteres.'})

        xRet := .F.

      Endif
    Elseif cIdPonto == 'BUTTONBAR'

        xRet := {{'Produto x Fornecedor', 'Produto x Fornecedor', { || MATA061() }, 'Chama a amarração Prod x Forn'}}

    Endif
  Endif

Return xRet
