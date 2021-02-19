#Include 'Protheus.ch'

/*/{Protheus.doc} User Function MATA070
  Ponto de Entrada para Bancos(MATA070), neste caso em especial o ID da Model
  tem o mesmo nome da Function, fonte padrão para isto, eu criei o fonte como
  MATA070_pe
  @type  Function
  @author user
  @since 19/02/2021
  @version 1.0
  /*/
User Function MATA070()
  Local aParam      := PARAMIXB
  Local xRet        := .T.

  // Local oObject     := aParam[1] // Objeto do formulário ou do modelo, conforme o caso
  Local cIdPonto    := aParam[2] // ID do local de execução do ponto de entrada
  // Local cIdModel    := aParam[3] // ID do formulário

  If aParam <> NIL
    If cIdPonto == 'MODELPOS'
      If Empty(M->A6_DVAGE) .OR. Empty(M->A6_DVCTA)

        Help(NIL, NIL, 'MATA070', NIL, 'DV da Agência ou Conta está em branco', 1, 0, NIL, NIL, NIL, NIL, NIL,;
            {'O dígito verificado da <b>Agência</b> e da <b>Conta</b> são obrigatórios..'})

        xRet := .F.
      Endif
    Endif
  Endif

Return xRet
