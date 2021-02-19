#Include 'Protheus.ch'

/*/{Protheus.doc} User Function MATA070
  Ponto de Entrada para Bancos(MATA070), neste caso em especial o ID da Model
  tem o mesmo nome da Function, fonte padr�o para isto, eu criei o fonte como
  MATA070_pe
  @type  Function
  @author user
  @since 19/02/2021
  @version 1.0
  /*/
User Function MATA070()
  Local aParam      := PARAMIXB
  Local xRet        := .T.

  // Local oObject     := aParam[1] // Objeto do formul�rio ou do modelo, conforme o caso
  Local cIdPonto    := aParam[2] // ID do local de execu��o do ponto de entrada
  // Local cIdModel    := aParam[3] // ID do formul�rio

  If aParam <> NIL
    If cIdPonto == 'MODELPOS'
      If Empty(M->A6_DVAGE) .OR. Empty(M->A6_DVCTA)

        Help(NIL, NIL, 'MATA070', NIL, 'DV da Ag�ncia ou Conta est� em branco', 1, 0, NIL, NIL, NIL, NIL, NIL,;
            {'O d�gito verificado da <b>Ag�ncia</b> e da <b>Conta</b> s�o obrigat�rios..'})

        xRet := .F.
      Endif
    Endif
  Endif

Return xRet
