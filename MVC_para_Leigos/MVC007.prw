#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MVC005
Chamados por Tecnicos com Acompanhamento
@type function
@version 1.0
@author sidneysantos
@since 12/11/2020
@see Curso - MVC para Leigos do Rogerio
/*/
User Function MVC007()

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
  Local oStruZZA := FWFormStruct(1, "ZZA") // PAI
  Local oStruZZD := FWFormStruct(1, "ZZD") // FILHA
  Local oStruZZE := FWFormStruct(1, "ZZE") // NETA


  // Cria o objeto do Modelo de Dados
  Local oModel := MPFormModel():New("MVC007_M" ,;
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

  //---------------------------------------------------------------
  // PRIMEIRO RELACIONAMENTO PAI E FILHA
  //---------------------------------------------------------------

  // Criacao do segundo componente da tela, componente FILHA
  oModel:AddGrid("ZZDFILHA", "ZZAPAI", oStruZZD ,;
      /* bLinePre */  ,;
      /* bPreVal */   ,;
                      ,;
      /* bLoad */     ;     
    )

  // Relacionamento das tabelas
  // Sempre inicia pela FILHA
  // SetRelation("Modelo", {{chaves}, {chaves}}, Indice_Ordenacao)
  oModel:SetRelation("ZZDFILHA", {{ "ZZD_FILIAL", "xFilial('ZZA')" }, { "ZZD_TECNIC", "ZZA_COD" } }, ZZD->(IndexKey(1)) )
  
  //---------------------------------------------------------------
  // SEGUNDO RELACIONAMENTO FILHA E NETA
  //---------------------------------------------------------------

  // Criacao do segundo componente da tela, componente FILHA
  oModel:AddGrid("ZZENETA", "ZZDFILHA", oStruZZE ,;
      /* bLinePre */  ,;
      /* bPreVal */   ,;
                      ,;
      /* bLoad */     ;     
    )

  // Relacionamento das tabelas
  // Sempre inicia pela FILHA
  // SetRelation("Modelo", {{chaves}, {chaves}}, Indice_Ordenacao)
  oModel:SetRelation("ZZENETA", {{ "ZZE_FILIAL", "xFilial('ZZD')" }, { "ZZE_CODCHA", "ZZD_COD" } }, ZZE->(IndexKey(1)) )


  // Adiciona a chave primaria ao Modelo de Dados
  oModel:SetPrimaryKey({ "ZZA_FILIAL", "ZZA_COD" })

  // Adiciona a descricao do Modelo de Dados
  oModel:SetDescription("Chamado por Tecnico")

  // Adiciona a descricao do Componente do Modelo de Dados
  oModel:GetModel("ZZAPAI"):SetDescription("Tecnicos")
  oModel:GetModel("ZZDFILHA"):SetDescription("Chamados")
  oModel:GetModel("ZZENETA"):SetDescription("Andamento")

  
  oModel:GetModel("ZZDFILHA"):SetOptional(.T.)
  oModel:GetModel("ZZENETA"):SetOptional(.T.)


  oModel:SetActivate()

// Retorna o Modelo de dados
Return oModel

/*/{Protheus.doc} ViewDef
/*/
Static Function ViewDef()

  // Cria um objeto de Modelo de Dados baseado no ModelDef() do fonte
  // Relaciona a View ao Model
  Local oModel    := FWLoadModel("MVC007")

  // Cria a estrutura a ser usada na View
  // Filtrando os campos da ZZA para aparecer na tela
  Local oStruZZA  := FWFormStruct(2, "ZZA", { |cCpo| Alltrim(cCpo)$"ZZA_COD+ZZA_NOME" })
  Local oStruZZD  := FWFormStruct(2, "ZZD")
  Local oStruZZE  := FWFormStruct(2, "ZZE")

  // Interface de visualizacao construida
  Local oView     := FWFormView():New()

  // Para nao ter aba neste fonte
  oStruZZD:SetNoFolder()

  // Define qual o Modelo de dados sera utilizado na View
  oView:SetModel(oModel)

  // Adiciona no nosso View um controle do tipo formulario
  oView:AddField("VIEW_ZZA", oStruZZA, "ZZAPAI")
  oView:AddGrid("VIEW_ZZD", oStruZZD, "ZZDFILHA")
  oView:AddGrid("VIEW_ZZE", oStruZZD, "ZZENETA")


  // Cria um box horizontal para receber algum elemento da View
  oView:CreateHorizontalBox("PAI", 20)
  oView:CreateHorizontalBox("FILHA", 40)
  oView:CreateHorizontalBox("NETA", 40)


  // Relaciona o identificador da View com o box para exibicao
  oView:SetOwnerView("VIEW_ZZA", "PAI")
  oView:SetOwnerView("VIEW_ZZD", "FILHA")
  oView:SetOwnerView("VIEW_ZZE", "NETA")


Return oView

/*/{Protheus.doc} MenuDef
/*/
Static Function MenuDef()

  Local aRotina := {}

  ADD OPTION aRotina TITLE "Vis. Chamados" ACTION "U_ChamTecA(ZZA->ZZA_COD)" OPERATION 1 ACCESS 0
 
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
User Function ChamTecA(cCodTec)

  Local lRetorno := .T.

  If !Empty(cCodTec)

    DbSelectArea("ZZD")
    DbSetOrder(1)

    If DbSeek(xFilial("ZZD") + cCodTec)

      // FWExecView para chamar a View e usar essa User
      FWExecView(Upper("Visualizar"), "VIEWDEF.MVC007", 1,;
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


