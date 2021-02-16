#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCVLD
  MVC Modelo 03
  @type  Function
  @author user
  @since 10/02/2021
  @version 1.0
  /*/
User Function MVCVLD()
  Local oBrowse := FWLoadBrw('MVCVLD')

  // Ativar o Browse
  oBrowse:Activate()

Return 

/*/{Protheus.doc} BrowseDef
  Função responsável por criar o browse e retornar para a função que invoca-la
  @type Function
  @author user
  @since 10/02/2021
  @version 1.0
  @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360016740431-MP-ADVPL-Estrutura-MVC-Pai-Filho-Neto
  @see https://tdn.totvs.com/display/framework/FWLoadBrw 
  /*/
Static Function BrowseDef()
  Local aArea     := GetArea()
  Local oBrowse   := FWMBrowse():New()

  oBrowse:SetAlias('SZ2')
  oBrowse:SetDescription('Cadastro de Chamados')

  oBrowse:AddLegend('SZ2->Z2_STATUS == "1"', 'GREEN',   'Chamado Aberto')
  oBrowse:AddLegend('SZ2->Z2_STATUS == "2"', 'RED',     'Chamado Finalizado')
  oBrowse:AddLegend('SZ2->Z2_STATUS == "3"', 'YELLOW',  'Chamado em Andamento')

  // Definição da onde vai vir o MenuDef
  oBrowse:SetMenuDef('MVCVLD')

  RestArea(aArea)

Return oBrowse

/*/{Protheus.doc} MenuDef
  Menu do programa
  @type Function
  @author user
  @since 10/02/2021
  @version 1.0
  /*/
Static Function MenuDef()
  Local aMenu     := {}
  Local aMenuAux  := FWMVCMenu('MVCVLD')

  For nX := 1 to Len(aMenuAux)
    aADD(aMenu, aMenuAux[nX])
  Next nX

  ADD OPTION aMenu TITLE 'Legenda'  ACTION 'U_zSZ2LEG'   OPERATION 6 ACCESS 0
  ADD OPTION aMenu TITLE 'Sobre'    ACTION 'U_zSZ2SOBRE' OPERATION 6 ACCESS 0

Return aMenu

/*/{Protheus.doc} ModelDef
  Modelo da função
  @type Function
  @author user
  @since 10/02/2021
  @version 1.0  
  /*/
Static Function ModelDef()
  Local oModel := MPFormModel():New('MVCVLDM'                        ,;
                                    { |oModel| MPreVld(oModel) }     ,; // bPre  
                                    /*bPos*/                         ,;
                                    /*bCommit*/                      ,;
                                    /*bCancel*/                       ;
  )

  // Criação das estruturas das tabelas
  Local oStPaiZ2      := FWFormStruct(1, 'SZ2')
  Local oStFilhoZ3    := FWFormStruct(1, 'SZ3')

  oStFilhoZ3:SetProperty('Z3_CHAMADO', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'SZ2->Z2_COD'))

  // Trigger para trazer o nome do usuário automaticamente
  aTrigUser := FwStruTrigger(      ;
    'Z2_USUARIO'                  ,; // Campo que dispara o gatilho/trigger
    'Z2_USERNAM'                  ,; // Campo que recebe o conteúdo disparado
    'USRRETNAME(M->Z2_USUARIO)'   ,; // Lógica do gatilho
    .F.                            ;
  )

  oStPaiZ2:AddTrigger(             ;
    aTrigUser[1]                  ,;
    aTrigUser[2]                  ,;
    aTrigUser[3]                  ,;
    aTrigUser[4]                   ;
  )

  oModel:AddFields('SZ2MASTER',,oStPaiZ2)
  oModel:AddGrid('SZ3DETAIL', 'SZ2MASTER', oStFilhoZ3)

  oModel:SetVldActivate({ |oModel| MActivVld(oModel) })

  oModel:SetRelation('SZ3DETAIL', {{'Z3_FILIAL', 'xFilial("SZ2")'}, {'Z3_CHAMADO', 'Z2_COD'}}, SZ3->(IndexKey(1)))

  oModel:SetPrimaryKey({'Z3_FILIAL', 'Z3_CHAMADO', 'Z3_CODIGO'})

  oModel:GetModel('SZ3DETAIL'):SetUniqueLine({'Z3_CHAMADO', 'Z3_CODIGO'})

  oModel:SetDescription('Modelo 03 - Sistema de Chamados')
  oModel:GetModel('SZ2MASTER'):SetDescription('Cabeçalho do Chamado')
  oModel:GetModel('SZ3DETAIL'):SetDescription('Comentários do Chamado')

Return oModel

/*/{Protheus.doc} ViewDef
  View da função
  @type Function
  @author user
  @since 10/02/2021
  @version 1.0
  /*/
Static Function ViewDef()
  Local oView       := FWFormView():New()
  Local oModel      := FWLoadModel('MVCVLD')

  Local oStPaiZ2    := FWFormStruct(2, 'SZ2')
  Local oStFilhoZ3  := FWFormStruct(2, 'SZ3')

  oStFilhoZ3:RemoveField('Z3_CHAMADO')

  oStFilhoZ3:SetProperty('Z3_CODIGO', MVC_VIEW_CANCHANGE, .F.)

  // Consulta Padrão
  oStPaiZ2:SetProperty('Z2_USUARIO', MVC_VIEW_LOOKUP, 'USR')

  oView:SetModel(oModel)
  oView:AddField('VIEWMASTER',   oStPaiZ2,   'SZ2MASTER')
  oView:AddGrid('VIEWDETAIL',  oStFilhoZ3, 'SZ3DETAIL')

  oView:AddIncrementField('SZ3DETAIL', 'Z3_CODIGO')

  oView:CreateHorizontalBox('CABEC', 60)
  oView:CreateHorizontalBox('GRID', 40)

  oView:SetOwnerView('VIEWMASTER',   'CABEC')
  oView:SetOwnerView('VIEWDETAIL', 'GRID')

  oView:EnableTitleView('VIEWMASTER', 'Detalhes do Chamado/Cabeçalho')
  oView:EnableTitleView('VIEWDETAIL', 'Comentários do Chamado/Itens')
  
Return oView

/*/{Protheus.doc} User Function zSZ2LEG
  Legenda do Fonte
  @type  Function
  @author user
  @since 10/02/2021
  @version 1.0
  /*/
User Function zSZ2LEG()
  Local aLegend := {}

  aADD(aLegend, {'BR_VERDE', 'Chamado Aberto'})
  aADD(aLegend, {'BR_AMARELO', 'Chamado em Andamento'})
  aADD(aLegend, {'BR_VERMELHO', 'Chamado Fechado'})

  BrwLegend('Status dos Chamados',, aLegend)
  
Return aLegend

/*/{Protheus.doc} User Function zSZ2SOBRE
  Sobre
  @type  Function
  @author user
  @since 10/02/2021
  @version 1.0  
  /*/
User Function zSZ2SOBRE()
  Local cSobre

  cSobre := '<b> Minha primeira tela em MVC Modelo 3.</b><br>'
  cSobre += 'Este Sistema de Chamados foi desenvolvido por um(a) Protheuzeiro(a) da Sistematizei.'

  MsgInfo(cSobre, 'Sobre o programador.')

Return 

/*/{Protheus.doc} MActivVld
  Função para validar se o usuário tem permissão para usar a rotina
  O código dos Usuários permitidos devem estar no parâmetro MV_XUSMVC 
  @type  Static Function
  @author user
  @since 11/02/2021
  @version 1.0
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @see (links_or_references)
  /*/
Static Function MActivVld(oModel)
  Local lRet        := .T.
  Local cUsersMVC   := SuperGetMV('MV_XUSMVC')

  // variável com o código do usuário atual
  Local cCodUser    := RetCodUsr()

  If !(cCodUser $ cUsersMVC)

    lRet := .F.
    Help(NIL, NIL, 'MActivVld', NIL, 'Usuário sem permissão', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
    {'Este usuário não tem permissão à realizar esta operação, vide parâmetro MV_XUSMVC'})
  Else
    If cCodUser != '000000' // Administrador

      // MODELO -> SUBMODELO -> ESTRUTURA -> PROPRIEDADE        -> BLOCO DE CÓDIGO -> X2_WHEN := .F.
      oModel:GetModel('SZ2MASTER'):GetStruct():SetProperty('Z2_DATA', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, '.F.'))
      oModel:GetModel('SZ2MASTER'):GetStruct():SetProperty('Z2_USUARIO', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, '.F.'))

    Endif
  Endif
  
Return lRet

/*/{Protheus.doc} MPreVld(
  Função de teste da pr?-valida??o do modelo
  @type  Function
  @author Sistematizei
  @since 15/02/2021
  @version 1.0
  @param oModel, object, objeto do modelo 
  /*/
Static Function MPreVld(oModel)
Local lRet := .T.

  If oModel:GetValue('SZ2MASTER', 'Z2_DATA') > dDatabase
    Help(NIL, NIL, 'MPreVld', NIL, 'Usuário sem permissão', 1, 0, NIL, NIL, NIL, NIL, NIL,; 
    {'Não pode incluir com data maior que a database!'})
    lRet := .F.
  Endif
  
Return lRet
