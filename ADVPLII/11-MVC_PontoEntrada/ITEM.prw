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

  /*
    Pega a operação corrente
    1 - Pesquisar, 2 - Visualizar, 3 - Incluir, 4 - Alterar, 5 - Excluir, 
    6 - Outras Funções, 7 - Copiar
  */
  Local nOption     := oObject:GetOperation()  

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
    Elseif cIdPonto == 'MODELCANCEL'

      If !MsgYesNo('Tem certeza que deseja sair da tela?')

        Help(NIL, NIL, 'CANCELARINCLUSAO', NIL, 'CANCEL', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
          {'Salvar/Cancelar abortado pelo usuário!'})

        xRet := .F.

      Endif  

    Elseif nOption == 5 // Exclusão

      Help(NIL, NIL, 'EXCLUIRPRODUTO', NIL, 'Exclusão do Produto inválida', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
          {'O produto não pode ser excluído em hipótese alguma. <br>' +;
          'Consulte o departamento de TI desta unidade.'})

      xRet := .F.

    Endif

  Endif

Return xRet
