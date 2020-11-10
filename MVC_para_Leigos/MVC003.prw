#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MVC003
Cadastro de Tipo de Atendimento
@type function
@version 1.0
@author sidneysantos
@since 11/8/2020
@see Curso - MVC para Leigos do Rogerio
/*/
User Function MVC003()

  // Instanciamento da Classe de Browse
  Local oBrw := FWMBrowse():New()

  // Definicao da tabela do Browse
  oBrw:SetAlias("ZZC")

  // Titulo do Browse
  oBrw:SetDescription("Cadastro de Tipos de Chamados")

  // Definicao da legenda
  // oBrowse:AddLegend("ZA0_TIPO == '1'", "GREEN", "Ativo")

  // Definicao de filtro
  // oBrw:SetFilterDefault(" ZA0_TIPO == '1' ")

  // Opcionalmente pode ser desligado a exibicao dos detalhes
  // oBrw:DisableDetails()

  // Ativacao da Classe
  oBrw:Activate()

Return Nil

/*/{Protheus.doc} ModelDef
/*/
Static Function ModelDef()

  // Cria a estrutura a ser usada no Modelo de Dados
  Local oStruZZC := FWFormStruct(1, "ZZC")

  // Cria o objeto do Modelo de Dados
  Local oModel := MPFormModel():New("MVC003_M")

  // Adiciona ao modelo um componente de formulario
  oModel:AddFields("ZZCMASTER", /* cOwner */, oStruZZC)

  // Adiciona a chave primaria ao Modelo de Dados
  oModel:SetPrimaryKey({ "ZZC_FILIAL", "ZZC_COD" })

  // Adiciona a descricao do Modelo de Dados
  oModel:SetDescription("Cadastro de Tipos de Chamados")

  // Adiciona a descricao do Componente do Modelo de Dados
  oModel:GetModel("ZZCMASTER"):SetDescription("Cadastro de Tipos de Chamados")

  oModel:SetActivate()

// Retorna o Modelo de dados
Return oModel

/*/{Protheus.doc} ViewDef
/*/
Static Function ViewDef()

  // Cria um objeto de Modelo de Dados baseado no ModelDef() do fonte
  Local oModel    := FWLoadModel("MVC003")

  // Cria a estrutura a ser usada na View
  Local oStruZZC  := FWFormStruct(2, "ZZC")

  // Interface de visualizacao construida
  Local oView     := FWFormView():New()

  // Define qual o Modelo de dados sera utilizado na View
  oView:SetModel(oModel)

  // Adiciona no nosso View um controle do tipo formulario
  oView:AddField("VIEW_ZZC", oStruZZC, "ZZCMASTER")

  // Cria um box horizontal para receber algum elemento da View
  oView:CreateHorizontalBox("TELA", 100)

  // Relaciona o identificador da View com o box para exibicao
  oView:SetOwnerView("VIEW_ZZC", "TELA")

Return oView

/*/{Protheus.doc} MenuDef
/*/
Static Function MenuDef()

  Local aRotina := {}

  ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVC003" OPERATION 2 ACCESS 0
  ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MVC003" OPERATION 3 ACCESS 0
  ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MVC003" OPERATION 4 ACCESS 0
  ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MVC003" OPERATION 5 ACCESS 0
  ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.MVC003" OPERATION 8 ACCESS 0
  ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.MVC003" OPERATION 9 ACCESS 0

Return aRotina
