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
    Parâmetro obrigatório nos PEs em MVC, pois eles trazem consigo informações 
    importantes sobre o estado e ponto de execução da rotina.
  */

  /*
    RETORNO NO ARRAY APARAM
    1 O Objeto do formulário ou do modelo, conforme o caso
    2 C ID do local de execução do ponto de entrada
    3 C ID do formulário
  */
  Local aParam      := PARAMIXB

  /*
    a variável começa com x por ser indefinida, começa com um valor lógico,
    mas no final pode se transformar em outro tipo e até retornar um array
  */
  Local xRet        := .T.

  Local oObject     := aParam[1] // Objeto do formulário ou do modelo, conforme o caso
  Local cIdPonto    := aParam[2] // ID do local de execução do ponto de entrada
  Local cIdModel    := aParam[3] // ID do formulário

  Local cCod        := Alltrim(M->B1_COD)
  Local cDesc       := Alltrim(M->B1_DESC)

  If aParam[2] <> Nil

    // PÓS VALIDAÇÃO
    If cIdPonto == 'MODELPOS'
      If Len(cCod) < 10

        Help(NIL, NIL, 'CODPRODUTO', NIL, 'Código não permitido', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
          {'O Código <b> '+ cCod + ' </b> deve ter no mínimo 10 caracteres.'})

        xRet := .F.

      Elseif Len(cDesc) < 15

        Help(NIL, NIL, 'DESCPRODUTO', NIL, 'Descrição do Produto inválida', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
          {'A descrição <b> ' + cDesc + ' </b> deve ter no mínimo 15 caracteres.'})

        xRet := .F.

      Endif
    Endif

  Endif
 



Return xRet
