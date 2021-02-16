#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCZ2Z3
  MVC Modelo 03
  @type  Function
  @author user
  @since 10/02/2021
  @version 1.0
  /*/
User Function MVCZ2Z3()
  Local oBrowse := FWLoadBrw('MVCZ2Z3')

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
  oBrowse:SetMenuDef('MVCZ2Z3')

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
  Local aMenuAux  := FWMVCMenu('MVCZ2Z3')

  For nX := 1 to Len(aMenuAux)
    aADD(aMenu, aMenuAux[nX])
  Next nX

  ADD OPTION aMenu TITLE 'Legenda'  ACTION 'U_SZ2LEG'   OPERATION 6 ACCESS 0
  ADD OPTION aMenu TITLE 'Sobre'    ACTION 'U_SZ2SOBRE' OPERATION 6 ACCESS 0

Return aMenu

/*/{Protheus.doc} ModelDef
  Modelo da função
  @type Function
  @author user
  @since 10/02/2021
  @version 1.0  
  /*/
Static Function ModelDef()
  Local oModel := MPFormModel():New('MVCZ23M',/*bPre*/,/*bPos*/,/*bCommit*/,/*bCancel*/)

  // Criação das estruturas das tabelas
  Local oStPaiZ2      := FWFormStruct(1, 'SZ2')
  Local oStFilhoZ3    := FWFormStruct(1, 'SZ3')

  oStFilhoZ3:SetProperty('Z3_CHAMADO', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'SZ2->Z2_COD'))

  oModel:AddFields('SZ2PAI',,oStPaiZ2)
  oModel:AddGrid('SZ3FILHO', 'SZ2PAI', oStFilhoZ3)

  oModel:SetRelation('SZ3FILHO', {{'Z3_FILIAL', 'xFilial("SZ2")'}, {'Z3_CHAMADO', 'Z2_COD'}}, SZ3->(IndexKey(1)))

  oModel:SetPrimaryKey({'Z3_FILIAL', 'Z3_CHAMADO', 'Z3_CODIGO'})

  oModel:GetModel('SZ3FILHO'):SetUniqueLine({'Z3_CHAMADO', 'Z3_CODIGO'})

  oModel:SetDescription('Modelo 03 - Sistema de Chamados')
  oModel:GetModel('SZ2PAI'):SetDescription('Cabeçalho do Chamado')
  oModel:GetModel('SZ3FILHO'):SetDescription('Comentários do Chamado')

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
  Local oModel      := FWLoadModel('MVCZ2Z3')

  Local oStPaiZ2    := FWFormStruct(2, 'SZ2')
  Local oStFilhoZ3  := FWFormStruct(2, 'SZ3')

  oStFilhoZ3:RemoveField('Z3_CHAMADO')
  

  oStFilhoZ3:SetProperty('Z3_CODIGO', MVC_VIEW_CANCHANGE, .F.)

  oView:SetModel(oModel)
  oView:AddField('VIEWPAI',   oStPaiZ2,   'SZ2PAI')
  oView:AddGrid('VIEWFILHO',  oStFilhoZ3, 'SZ3FILHO')

  oView:AddIncrementField('SZ3FILHO', 'Z3_CODIGO')

  oView:CreateHorizontalBox('CABEC', 60)
  oView:CreateHorizontalBox('GRID', 40)

  oView:SetOwnerView('VIEWPAI',   'CABEC')
  oView:SetOwnerView('VIEWFILHO', 'GRID')

  oView:EnableTitleView('VIEWPAI', 'Detalhes do Chamado/Cabeçalho')
  oView:EnableTitleView('VIEWFILHO', 'Comentários do Chamado/Itens')
  
Return oView

/*/{Protheus.doc} User Function SZ2LEG
  Legenda do Fonte
  @type  Function
  @author user
  @since 10/02/2021
  @version 1.0
  /*/
User Function SZ2LEG()
  Local aLegend := {}

  aADD(aLegend, {'BR_VERDE', 'Chamado Aberto'})
  aADD(aLegend, {'BR_AMARELO', 'Chamado em Andamento'})
  aADD(aLegend, {'BR_VERMELHO', 'Chamado Fechado'})

  BrwLegend('Status dos Chamados',, aLegend)
  
Return aLegend

/*/{Protheus.doc} User Function SZ2SOBRE
  Sobre
  @type  Function
  @author user
  @since 10/02/2021
  @version 1.0  
  /*/
User Function SZ2SOBRE()
  Local cSobre

  cSobre := '<b> Minha primeira tela em MVC Modelo 3.</b><br>'
  cSobre += 'Este Sistema de Chamados foi desenvolvido por um(a) Protheuzeiro(a) da Sistematizei.'

  MsgInfo(cSobre, 'Sobre o programador.')

Return 
