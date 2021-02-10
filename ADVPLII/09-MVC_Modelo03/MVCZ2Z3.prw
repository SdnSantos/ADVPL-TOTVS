/*/{Protheus.doc} User Function MVCZ2Z3
  (long_description)
  @type  Function
  @author user
  @since 10/02/2021
  @version 1.0
  @see (links_or_references)
  /*/
User Function MVCZ2Z3(param_name)
  Local oBrowse := FWLoadBR('MVCZ2Z3')

  // Ativar o Browse
  oBrowse:Activate()

Return 

/*/{Protheus.doc} BrowseDef
  Função responsável por criar o browse e retornar para a função que invoca-la
  @type  Static Function
  @author user
  @since 10/02/2021
  @version 1.0
  @return oBrowse, objeto, ObjetoBrowse
  @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360016740431-MP-ADVPL-Estrutura-MVC-Pai-Filho-Neto
  @see https://tdn.totvs.com/display/framework/FWLoadBrw 
  /*/
Static Function BrowseDef()
  Local aArea     := GetArea()
  Local oBrowse   := FWMBrowse():New()

  oBrowse:SetAlias('SZ2')
  oBrowse:SetDescription('Cadastro de Chamados')

  oBrowse:AddLegend('SZ2->Z2_STATUS == "1"', 'GREEN',   'Chamado Aberto')
  oBrowse:AddLegend('SZ2->Z2_STATUS == "2"', 'YELLOW',  'Chamado em Andamento')
  oBrowse:AddLegend('SZ2->Z2_STATUS == "3"', 'RED',     'Chamado Finalizado')

  // Definição da onde vai vir o MenuDef
  oBrowse:SetMenuDef('MVCZ2Z3')

  RestArea(aArea)

Return oBrowse

/*/{Protheus.doc} ModelDef
  (long_description)
  @type  Static Function
  @author user
  @since 10/02/2021
  @version 1.0
  @return oModel, objeto, objeto de modelo
  @example
  (examples)
  @see (links_or_references)
  /*/
Static Function ModelDef()
  Local oModel := MPFormModel():New('MVCZ23M',/*bPre*/,/*bPos*/,/*bCommit*/,/*bCancel*/)

  // Criação das estruturas das tabelas
  Local oStPaiZ2      := FWFormStruct(1, 'SZ2')
  Local oStFilhoZ3    := FWFormStruct(1, 'SZ3')

  oModel:AddFields('SZ2PAI',,oStPaiZ2)
  oModel:AddGrid('SZ3FILHO', 'SZ2PAI', oStFilhoZ3)

  oModel:SetRelation('SZ3FILHO', {{'Z3_FILIAL', 'xFilial("SZ2")'}, {'Z3_CHAMADO', 'Z2_COD'}}, SZ3->(IndexKey(1)))

  oModel:SetPrimaryKey({'Z3_FILIAL', 'Z3_CHAMADO', 'Z3_CODIGO'})

  oModel:GetModel('SZ3FILHO'):SetUniqueLine({'Z3_CHAMADO', 'Z3_CODIGO'})

  oModel:SetDescription('Modelo 03 - Sistema de Chamados')
  oModel:GetModel('SZ2PAI'):SetDescription('Cabeçalho do Chamado')
  oModel:GetModel('SZ3FILHO'):SetDescription('Comentários do Chamado')

Return oModel
