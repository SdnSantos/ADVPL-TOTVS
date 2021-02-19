#Include 'Protheus.ch'

/*/{Protheus.doc} User Function MVCSZ7M
  Ponto de Entrada para a User Function MCSZ7 que est� em MVC onde o ID do modelo
  � MVCSZ7M, senfo assim este � o meu PE para esta fun��o.
  Valida o item da grid, para n�o deixara quantidade > 10
  @type  Function
  @author user
  @since 19/02/2021
  @version 1.0
   /*/
User Function MVCSZ7M()

  Local aParam      := PARAMIXB
  Local xRet        := .T.
  // Local oObject     := aParam[1] // Objeto do formul�rio ou do modelo, conforme o caso
  Local cIdPonto    := aParam[2] // ID do local de execu��o do ponto de entrada
  // Local cIdModel    := aParam[3] // ID do formul�rio

  If aParam[2] <> Nil

    If cIdPonto == 'FORMLINEPOS'

      If FwFldGet('Z7_QUANT') > 10

        Help(NIL, NIL, 'QTDPRODUTOS', NIL, 'Quantidade n�o permitida', 1, 0, NIL, NIL, NIL, NIL, NIL,{'Devido a pandemia estamos limitando as vendas em 10 intens por produto.'})

        xRet := .F.
      Endif

    Endif

  Endif

Return xRet
