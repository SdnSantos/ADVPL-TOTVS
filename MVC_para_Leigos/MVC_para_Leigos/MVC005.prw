#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MVC005
Chamados
@type function
@version 1.0
@author sidneysantos
@since 11/9/2020
@see Curso - MVC para Leigos do Rogerio
/*/
User Function MVC005()

  // Instanciamento da Classe de Browse
  Local oBrw := FWMBrowse():New()

  // Definicao da tabela do Browse
  oBrw:SetAlias("ZZA")

  // Titulo do Browse
  oBrw:SetDescription("Chamados por Tecnico")

  // Definicao da legenda
  // oBrw:AddLegend("ZZD_STATUS == '1'", "GREEN",   "Aberto")
  // oBrw:AddLegend("ZZD_STATUS == '2'", "BLUE",    "Em Atendimento")
  // oBrw:AddLegend("ZZD_STATUS == '3'", "YELLOW",  "Aguardando Usuário")
  // oBrw:AddLegend("ZZD_STATUS == '4'", "BLACK",   "Encerrado")
  // oBrw:AddLegend("ZZD_STATUS == '5'", "RED",     "Atrasado")
  
  // Definicao de filtro
  // oBrw:SetFilterDefault(" ZA0_TIPO == '1' ")

  // Opcionalmente pode ser desligado a exibicao dos detalhes
  // oBrw:DisableDetails()

  // Ativacao da Classe
  oBrw:Activate()

Return ()

/*/{Protheus.doc} ModelDef
/*/
Static Function ModelDef()

  // Cria a estrutura a ser usada no Modelo de Dados
  Local oStruZZA := FWFormStruct(1, "ZZA")
  Local oStruZZD := FWFormStruct(1, "ZZD")

  // Cria o objeto do Modelo de Dados
  Local oModel := MPFormModel():New("MVC005_M" ,;
      /* bPreValidacao */ ,; // abre o modelo
      /* bPosValidacao */ ,; // grava o modelo
      /* bCommit */       ,; 
      /* bCancel */       ;
    )

  // Adiciona ao modelo um componente de formulario
  oModel:AddFields("ZZAPAI", /* cOwner */, oStruZZA,;
      /* bPreValidacao */ ,;
      /* bPosValidacao */ ,;
      /* bCarga */        ; // carga de dados    
    )

  //Relacionamento das tabelas
  oModel:AddGrid("ZZDFILHA", "ZZAPAI", oStruZZD ,;
      /* bLinePre */  ,;
      /* bPreVal */   ,;
                      ,;
      /* bLoad */     ;     
    )

  oModel:SetRelation("ZZDFILHA", {{ "ZZD_FILIAL", "xFilial('ZZA')" }, { "ZZD_TECNIC", "ZZA_COD" } }, ZZD->(IndexKey(1)) )
  
  // Adiciona a chave primaria ao Modelo de Dados
  oModel:SetPrimaryKey({ "ZZA_FILIAL", "ZZA_COD" })

  // Adiciona a descricao do Modelo de Dados
  oModel:SetDescription("Chamado por Técnico")

  // Adiciona a descricao do Componente do Modelo de Dados
  oModel:GetModel("ZZAPAI"):SetDescription("Chamados por Técnico")

  oModel:GetModel("ZZDFILHA"):SetOptional(.T.)
  oModel:SetActivate()

// Retorna o Modelo de dados
Return oModel

/*/{Protheus.doc} ViewDef
/*/
Static Function ViewDef()

  // Cria um objeto de Modelo de Dados baseado no ModelDef() do fonte
  Local oModel    := FWLoadModel("MVC005")

  // Cria a estrutura a ser usada na View
  // Filtrando os campos da ZZA para aparecer na tela
  Local oStruZZA  := FWFormStruct(2, "ZZA", { |cCpo| Alltrim(cCpo)$"ZZA_COD+ZZA_NOME" })
  Local oStruZZD  := FWFormStruct(2, "ZZD")

  // Interface de visualizacao construida
  Local oView     := FWFormView():New()

  // Para nao ter aba neste fonte
  oStruZZD:SetNoFolder()

  // Define qual o Modelo de dados sera utilizado na View
  oView:SetModel(oModel)

  // Adiciona no nosso View um controle do tipo formulario
  oView:AddField("VIEW_ZZA", oStruZZA, "ZZAPAI")
  oView:AddGrid("VIEW_ZZD", oStruZZD, "ZZDFILHA")

  // Cria um box horizontal para receber algum elemento da View
  oView:CreateHorizontalBox("CABECALHO", 15)
  oView:CreateHorizontalBox("DETALHES", 85)

  // Relaciona o identificador da View com o box para exibicao
  oView:SetOwnerView("VIEW_ZZA", "CABECALHO")
  oView:SetOwnerView("VIEW_ZZD", "DETALHES")

Return oView

/*/{Protheus.doc} MenuDef
/*/
Static Function MenuDef()

  Local aRotina := {}

  ADD OPTION aRotina TITLE "Vis. Chamados" ACTION "U_ChamTec(ZZA->ZZA_COD)" OPERATION 1 ACCESS 0
 
Return aRotina

/*/{Protheus.doc} ChamTec
Funcao para visualizar os chamados dos atendentes
@type function
@version 1.0
@author sidneysantos
@since 11/9/2020
@see Curso - MVC para Leigos do Rogerio
@params cCodAtend - codigo do tecnico
/*/
User Function ChamTec(cCodTec)

  Local lRetorno := .T.

  If !Empty(cCodTec)

    DbSelectArea("ZZD")
    DbSetOrder(1)

    If DbSeek(xFilial("ZZD") + cCodTec)

      // FWExecView para chamar a View e usar essa User
      FWExecView(Upper("Visualizar"), "VIEWDEF.MVC005", 1,;
      /* oDlg */          ,; // 
      /* bCloseOnOk */    ,; // 
      /* bOk */           ,; //
      /* nPercReducao */  ,; //
    )

    EndIf

  Else
    
    MsgAlert("Selecione um técnico para visualizar", "Atenção")

  EndIf

Return lRetorno


