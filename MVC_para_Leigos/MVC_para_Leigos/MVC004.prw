#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MVC004
Chamados
@type function
@version 1.0
@author sidneysantos
@since 11/8/2020
@see Curso - MVC para Leigos do Rogerio
/*/
User Function MVC004()

  // Instanciamento da Classe de Browse
  Local oBrw := FWMBrowse():New()

  // Definicao da tabela do Browse
  oBrw:SetAlias("ZZD")

  // Titulo do Browse
  oBrw:SetDescription("Chamados")

  // Definicao da legenda
  oBrw:AddLegend("ZZD_STATUS == '1'", "GREEN",   "Aberto")
  oBrw:AddLegend("ZZD_STATUS == '2'", "BLUE",    "Em Atendimento")
  oBrw:AddLegend("ZZD_STATUS == '3'", "YELLOW",  "Aguardando Usuário")
  oBrw:AddLegend("ZZD_STATUS == '4'", "BLACK",   "Encerrado")
  oBrw:AddLegend("ZZD_STATUS == '5'", "RED",     "Atrasado")
  
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
  Local oStruZZD := FWFormStruct(1, "ZZD")

  // Cria o objeto do Modelo de Dados
  Local oModel := MPFormModel():New("MVC004_M")

  // Adiciona ao modelo um componente de formulario
  oModel:AddFields("ZZDMASTER", /* cOwner */, oStruZZD)

  // Adiciona a chave primaria ao Modelo de Dados
  oModel:SetPrimaryKey({ "ZZD_FILIAL", "ZZD_COD" })

  // Adiciona a descricao do Modelo de Dados
  oModel:SetDescription("Chamados")

  // Adiciona a descricao do Componente do Modelo de Dados
  oModel:GetModel("ZZDMASTER"):SetDescription("Chamados")

  oModel:SetActivate()

// Retorna o Modelo de dados
Return oModel

/*/{Protheus.doc} ViewDef
/*/
Static Function ViewDef()

  // Cria um objeto de Modelo de Dados baseado no ModelDef() do fonte
  Local oModel    := FWLoadModel("MVC004")

  // Cria a estrutura a ser usada na View
  Local oStruZZD  := FWFormStruct(2, "ZZD")

  // Interface de visualizacao construida
  Local oView     := FWFormView():New()

  // Define qual o Modelo de dados sera utilizado na View
  oView:SetModel(oModel)

  // Adiciona no nosso View um controle do tipo formulario
  oView:AddField("VIEW_ZZD", oStruZZD, "ZZDMASTER")

  // Cria um box horizontal para receber algum elemento da View
  oView:CreateHorizontalBox("TELA", 100)

  // Relaciona o identificador da View com o box para exibicao
  oView:SetOwnerView("VIEW_ZZD", "TELA")

Return oView

/*/{Protheus.doc} MenuDef
/*/
Static Function MenuDef()

  Local aRotina := {}

  ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVC004" OPERATION 2 ACCESS 0
  ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MVC004" OPERATION 3 ACCESS 0
  ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MVC004" OPERATION 4 ACCESS 0
  ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MVC004" OPERATION 5 ACCESS 0
  ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.MVC004" OPERATION 8 ACCESS 0
  ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.MVC004" OPERATION 9 ACCESS 0

Return aRotina

