#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FWMVCDEF.CH" 

/*/{Protheus.doc} MVC001
  Cadastro de Tecnicos
  @type  User Function
  @author Sidney Santos
  @since 07/11/2020
  @version 1.0
  @see Curso - MVC para Leigos do Rogerio
  /*/
User Function MVC001()

  // Instanciamento da Classe de Browse
  Local oBrw := FWMBrowse():New()

  // Definicao da tabela do Browse
  oBrw:SetAlias("ZZA")

  // Titulo da Browse
  oBrw:SetDescription("Cadastro de Técnico")

  // Definicao da legenda
  // oBrowse:AddLegend("ZZA_TIPO == '1'", "GREEN", "Ativo)

  // Definicao de filtro
  // oBrowse:SetFilterDefault( "ZA0_TIPO=='1'" )
  
  // Opcionalmente pode ser desligado a exibicao dos detalhes
  // oBrowse:DisableDetails()

  // Ativação da Classe
  oBrw:Activate()

Return NIL

/*/{Protheus.doc} ModelDef
/*/
Static Function ModelDef()

  // Cria a estrutura a ser usada no Modelo de Dados
  Local oStruZZA  := FWFormStruct(1, "ZZA")

  // Cria o objeto do Modelo de Dados
  Local oModel    := MPFormModel():New("MVC001_M") 

  // Adiciona ao modelo um componente de formulario
  oModel:AddFields("ZZAMASTER", /* cOwner */, oStruZZA)

  // Adiciona a chave primaria ao Modelo de Dados
  oModel:SetPrimaryKey({ "ZZA_FILIAL", "ZZA_COD" })

  // Adiciona a descricao do Modelo de Dados  
  oModel:SetDescription("Cadastro de Técnico")
  
  // Adiciona a descricao do Componente do Modelo de Dados 
  oModel:GetModel("ZZAMASTER"):SetDescription("Cadastro de Técnico")

  oModel:SetActivate()

// Retorna o Modelo de dados
Return oModel

/*/{Protheus.doc} ViewDef
  /*/
Static Function ViewDef()
  
  // Cria um objeto de Modelo de Dados baseado no ModelDef() do fonte informado
  Local oModel    := FWLoadModel("MVC001")

  // Cria a estrutura a ser usada na View
  Local oStruZZA  := FWFormStruct(2, "ZZA")

  // Interface de visualizacao construida
  Local oView     := FWFormView():New()

  // Define qual o Modelo de dados sera utilizado na View
  oView:SetModel(oModel)

  // Adiciona no nosso View um controle do tipo formulario
  oView:AddField("VIEW_ZZA", oStruZZA, "ZZAMASTER")

  // Cria um box horizontal para receber algum elemento da View
  oView:CreateHorizontalBox("TELA", 100)

  // Relaciona o identificador da View com o box para exibicao
  oView:SetOwnerView("VIEW_ZZA", "TELA")

// Retorna o objeto de View criado
Return oView

/*/{Protheus.doc} MenuDef
/*/
Static Function MenuDef()
  Local aRotina := {}

  ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVC001" OPERATION 2 ACCESS 0
  ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MVC001" OPERATION 3 ACCESS 0
  ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MVC001" OPERATION 4 ACCESS 0
  ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MVC001" OPERATION 5 ACCESS 0
  ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.MVC001" OPERATION 8 ACCESS 0
  ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.MVC001" OPERATION 9 ACCESS 0

Return aRotina
