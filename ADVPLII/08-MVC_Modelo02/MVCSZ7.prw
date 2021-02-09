#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCSZ7
  @type  Function
  @author Sistematizei
  @since 26/01/2021
  @version 1.0 
/*/
User Function MVCSZ7()
  Local aArea     := GetArea()  
  Local oBrowse   := FwMBrowse():New()

    oBrowse:SetAlias('SZ7')
    oBrowse:SetDescription('Solicita��o de Compras')

    oBrowse:Activate()

  RestArea(aArea)

Return 

/*/{Protheus.doc} MenuDef 
  @type  Static Function
  @author user
  @since 31/01/2021
  @version 1.0
  @return aRotina, array, array com op��es do menu
/*/
Static Function MenuDef()
  // Op��o 1
  Local aRotina := FWMvcMenu('MVCSZ7')

  /*
  
  1 - Pesquisar, 2 - Visualizar, 3 - Incluir, 4 - Alterar,
  5 - Excluir, 6 - Outras Fun��es, 7 - Copiar 

  // Op�ao - 2

  Local aRotina := {}

  ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVCSZ7' OPERATION 2 ACCESS 0
  ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVCSZ7' OPERATION 3 ACCESS 0
  ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVCSZ7' OPERATION 4 ACCESS 0
  ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVCSZ7' OPERATION 5 ACCESS 0
  */

  /*
  // Op�ao - 3

  Local aRotina := {}

  ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVCSZ7' OPERATION MODEL_OPERATION_VIEW    ACCESS 0
  ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVCSZ7' OPERATION MODEL_OPERATION_INSERT  ACCESS 0
  ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVCSZ7' OPERATION MODEL_OPERATION_UPDATE  ACCESS 0
  ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVCSZ7' OPERATION MODEL_OPERATION_DELETE  ACCESS 0
  */

Return aRotina

/*/{Protheus.doc} ModelDef
  Static function respons�vel pela criacao do modelo de dados
  @type  Static Function
  @author Sistematizei
  @since 27/01/2021
  @version 1.0
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @see https://tdn.totvs.com/display/framework/FWFormModelStruct
  @see https://tdn.totvs.com/display/framework/FWFormViewStruct
  @see https://tdn.totvs.com/display/framework/FWFormStruct
  @see https://tdn.totvs.com/display/framework/MPFormModel
  @see https://tdn.totvs.com/display/framework/FWBuildFeature
  @see https://tdn.totvs.com/display/framework/FWFormGridModel

  /*/
Static Function ModelDef()
  // Objeto responsavel pela estrutura Temporaria do cabecalho
  Local oStCabec    := FWFormModelStruct():New()

  // Objeto responsavel pela estrutura dos itens
  Local oStItens    := FWFormStruct(1, 'SZ7')

  // Chamada da fun��o que validar� o Cabe�alho (Master)
  Local bVldPos     := {|| U_VldSZ7()}

  // Chamada da fun��o que validar� a INCLUS�O, ALTERA��O e EXCLUS�O dos itens
  Local bVldCom     := {|| U_GrvSZ7()}

  //                                              /*bPre*/, /*bPos*/, /*bCommit*/, /*bCancel*/
  Local oModel      := MPFormModel():New('MVCSZ7M', /*bPre*/, bVldPos, bVldCom, /*bCancel*/)

  Local aTrigQuant  := {}
  Local aTrigPreco  := {}

  // Criacao da tabela temporaria que sera utilizada no cabecalho
  oStCabec:AddTable('SZ7', {'Z7_FILIAL', 'Z7_NUM', 'Z7_ITEM'}, 'Cabe�alho SZ7')

  // Criacao dos camposa da tabela temporaria
  oStCabec:AddField(;
    'Filial',;                // [01] C Titulo do campo
    'Filial',;                // [02] C Tooltip do campo
    'Z7_FILIAL',;             // [03] C Id do Field
    'C',;                     // [04] C Tipo do campo
    TamSX3('Z7_FILIAL')[1],;  // [05] N Tamanho do campo
    0,;                       // [06] N Decimal do campo
    Nil,;                     // [07] B Bloco de c�digo de valida��o do campo
    Nil,;                     // [08] B Bloco de c�digo de valida��o when do campo
    {},;                      // [09] A Lista de valores permitidos
    .F.,;                     // [10] L Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, 'IIF(!INCLUI, SZ7->Z7_FILIAL, FWxFilial("SZ7"))'),;                         // [11] B Bloco de c�digo de inicializa��o do campo
    .T.,;                     // [12] L Indica se trata-se de um campo chave
    .F.,;                     // [13] L Indica se o campo n�o pode receber valor em uma opera��o de update
    .F.,;                     // [14] L Indica se o campo � virtual
  )

  oStCabec:AddField(;
    "Pedido",;               // [01]  C   Titulo do campo
    "Pedido",;               // [02]  C   ToolTip do campo
    "Z7_NUM",;               // [03]  C   Id do Field
    "C",;                    // [04]  C   Tipo do campo
    TamSX3("Z7_NUM")[1],;    // [05]  N   Tamanho do campo
    0,;                      // [06]  N   Decimal do campo
    Nil,;                    // [07]  B   Code-block de valida��o do campo
    Nil,;                    // [08]  B   Code-block de valida??o When do campo
    {},;                     // [09]  A   Lista de valores permitido do campo
    .F.,;                    // [10]  L   Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_NUM,GETSXENUM('SZ7','Z7_NUM'))" ),;                        // [11]  B   Code-block de inicializacao do campo
    .T.,;                    // [12]  L   Indica se trata-se de um campo chave
    .F.,;                    // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
    .F.)                     // [14]  L   Indica se o campo virtual

  oStCabec:AddField(;
    'Emissao',;               // [01] C Titulo do campo
    'Emissao',;               // [02] C Tooltip do campo
    'Z7_EMISSAO',;            // [03] C Id do Field
    'D',;                     // [04] C Tipo do campo
    TamSX3('Z7_EMISSAO')[1],; // [05] N Tamanho do campo
    0,;                       // [06] N Decimal do campo
    Nil,;                     // [07] B Bloco de c�digo de valida��o do campo
    Nil,;                     // [08] B Bloco de c�digo de valida��o when do campo
    {},;                      // [09] A Lista de valores permitidos
    .T.,;                     // [10] L Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, 'Iif(!INCLUI, SZ7->Z7_EMISSAO, dDataBase)'),;     // [11] B Bloco de c�digo de inicializa��o do campo
    .F.,;                     // [12] L Indica se trata-se de um campo chave
    .F.,;                     // [13] L Indica se o campo n�o pode receber valor em uma opera��o de update
    .F.,;                     // [14] L Indica se o campo � virtual
  )

  oStCabec:AddField(;
    'Fornecedor',;            // [01] C Titulo do campo
    'Fornecedor',;            // [02] C Tooltip do campo
    'Z7_FORNECE',;            // [03] C Id do Field
    'C',;                     // [04] C Tipo do campo
    TamSX3('Z7_FORNECE')[1],; // [05] N Tamanho do campo
    0,;                       // [06] N Decimal do campo
    Nil,;                     // [07] B Bloco de c�digo de valida��o do campo
    Nil,;                     // [08] B Bloco de c�digo de valida��o when do campo
    {},;                      // [09] A Lista de valores permitidos
    .T.,;                     // [10] L Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, 'IIF(!INCLUI, SZ7->Z7_FORNECE, "")'),;     // [11] B Bloco de c�digo de inicializa��o do campo
    .F.,;                     // [12] L Indica se trata-se de um campo chave
    .F.,;                     // [13] L Indica se o campo n�o pode receber valor em uma opera��o de update
    .F.,;                     // [14] L Indica se o campo � virtual
  )

  oStCabec:AddField(;
    'Loja',;                  // [01] C Titulo do campo
    'Loja',;                  // [02] C Tooltip do campo
    'Z7_LOJA',;               // [03] C Id do Field
    'C',;                     // [04] C Tipo do campo
    TamSX3('Z7_LOJA')[1],;    // [05] N Tamanho do campo
    0,;                       // [06] N Decimal do campo
    Nil,;                     // [07] B Bloco de c�digo de valida��o do campo
    Nil,;                     // [08] B Bloco de c�digo de valida��o when do campo
    {},;                      // [09] A Lista de valores permitidos
    .T.,;                     // [10] L Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, 'IIF(!INCLUI, SZ7->Z7_LOJA, "")'),;     // [11] B Bloco de c�digo de inicializa��o do campo
    .F.,;                     // [12] L Indica se trata-se de um campo chave
    .F.,;                     // [13] L Indica se o campo n�o pode receber valor em uma opera��o de update
    .F.,;                     // [14] L Indica se o campo � virtual
  )

  oStCabec:AddField(;
    "Usuario",;               // [01]  C   Titulo do campo
    "Usuario",;               // [02]  C   ToolTip do campo
    "Z7_USER",;               // [03]  C   Id do Field
    "C",;                     // [04]  C   Tipo do campo
    TamSX3("Z7_USER")[1],;    // [05]  N   Tamanho do campo
    0,;                       // [06]  N   Decimal do campo
    Nil,;                     // [07]  B   Code-block de valida��o do campo
    Nil,;                     // [08]  B   Code-block de valida��o When do campo
    {},;                      // [09]  A   Lista de valores permitido do campo
    .T.,;                     // [10]  L   Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_USER,__cuserid)" ),;    // [11]  B   Code-block de inicializacao do campo
    .F.,;                     // [12]  L   Indica se trata-se de um campo chave
    .F.,;                     // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
    .F.)                      // [14]  L   Indica se o campo virtual

  // Modificando inicializadores padrao, para nao dar mensagens de colunas vazias
  oStItens:SetProperty('Z7_NUM',      MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
  oStItens:SetProperty('Z7_USER',     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '__cUserId'))
  oStItens:SetProperty('Z7_EMISSAO',  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'dDataBase'))
  oStItens:SetProperty('Z7_FORNECE',  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
  oStItens:SetProperty('Z7_LOJA',     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
  
  // FwStruTrigger monta o bloco de c�digo da Trigger
  aTrigQuant  := FwStruTrigger(    ;
    'Z7_QUANT'                    ,; // Campo que dispara o gatilho
    'Z7_TOTAL'                    ,; // Campo que ir� receber o conte�do do gartilho
    'M->Z7_QUANT * M->Z7_PRECO'   ,; // L�gica do gatilho
    .F.                            ; // Posiciona? .T. = Sim, .F. = N�o
  )

  aTrigPreco  := FwStruTrigger(    ;
    'Z7_PRECO'                    ,; // Campo que dispara o gatilho
    'Z7_TOTAL'                    ,; // Campo que ir� receber o conte�do do gartilho
    'M->Z7_QUANT * M->Z7_PRECO'   ,; // L�gica do gatilho
    .F.                            ; // Posiciona? .T. = Sim, .F. = N�o
  )

  // Adiciona a Trigger a estrutura de itens
  oStItens:AddTrigger(   ;
    aTrigQuant[1]       ,;
    aTrigQuant[2]       ,;
    aTrigQuant[3]       ,;
    aTrigQuant[4]        ;
  )

  oStItens:AddTrigger(   ;
    aTrigPreco[1]       ,;
    aTrigPreco[2]       ,;
    aTrigPreco[3]       ,;
    aTrigPreco[4]        ;
  )

  // Unindo as estruturas, vinculando o cabecalho com os itens
  oModel:AddFields('SZ7MASTER',, oStCabec)
  oModel:AddGrid('SZ7DETAIL','SZ7MASTER',oStItens)

  // Adicionando Totalizadores
  oModel:AddCalc(          ;
    'SZ7TOTAIS'           ,; // Modelo
    'SZ7MASTER'           ,; // Master
    'SZ7DETAIL'           ,; // Detail
    'Z7_PRODUTO'          ,; // Campo calculado
    'QTDPROD'             ,; // Nome personalizado
    'COUNT'               ,; // Opera��o
                          ,;
                          ,; 
    'N�mero de Produtos'   ; // Nome do totalizador
    )

    oModel:AddCalc(          ;
    'SZ7TOTAIS'           ,; // Modelo
    'SZ7MASTER'           ,; // Master
    'SZ7DETAIL'           ,; // Detail
    'Z7_QUANT'            ,; // Campo calculado
    'QTDITENS'            ,; // Nome personalizado
    'SUM'                 ,; // Opera��o
                          ,;
                          ,; 
    'Qtd de Itens'         ; // Nome do totalizador
    )

    oModel:AddCalc(        ;
    'SZ7TOTAIS'           ,; // Modelo
    'SZ7MASTER'           ,; // Master
    'SZ7DETAIL'           ,; // Detail
    'Z7_TOTAL'            ,; // Campo calculado
    'TOTAL'               ,; // Nome personalizado
    'SUM'                 ,; // Opera��o
                          ,;
                          ,; 
    'Total'                ; // Nome do totalizador
    )



  // Relacionamento do cabecalho com os itens, qual ou quais campos o grid esta vinculado com o cabecalho
  oModel:SetRelation('SZ7DETAIL', {{'Z7_FILIAL', 'Iif(!INCLUI, SZ7->Z7_FILIAL, FWxFilial("SZ7"))'}, {'Z7_NUM', 'SZ7->Z7_NUM'}}, SZ7->(IndexKey(1)) )

  // Setar a chave primaria, � obrigat�rio caso o X2_UNICO esteja vazio
  oModel:SetPrimaryKey({})

  oModel:GetModel('SZ7DETAIL'):SetUniqueLine({'Z7_ITEM'})

  // Titulo do cabecalho
  oModel:GetModel('SZ7MASTER'):SetDescription('CABE�ALHO DA SOLICITA��O DE COMPRAS')

  // Titulo do grid
  oModel:GetModel('SZ7DETAIL'):SetDescription('ITENS DA SOLICITA��O DE COMPRAS')
  
  // Setando o modelo antigo de grid, que permite pegar aHeader e aCols
  oModel:GetModel('SZ7DETAIL'):SetUseOldGrid(.T.)

Return oModel

/*/{Protheus.doc} ViewDef
  (long_description)
  @type  Static Function
  @author user
  @since 30/01/2021
  @version 1.0
  @return oView, objeto, Objeto de visualizacao do fonte MVC
  @see (links_or_references)
  /*/
Static Function ViewDef() 
  Local oView     := Nil

  Local oModel    := FWLoadModel('MVCSZ7')

  // Objeto encarregado de montar a estrutura tempor�ria do cabe�alho da View  
  Local oStCabec  := FWFormViewStruct():New()

  // Objeto encarregado de montar a parte de estrutura dos itens/grid
  Local oStItens  := FWFormStruct(2, 'SZ7')

  // Criar estrutura para totalizadores
  Local oStTotais := FWCalcStruct(oModel:GetModel('SZ7TOTAIS'))

  // Cria��o dos campos do cabe�alho dentro da estrutura View
  oStCabec:AddField(;
    'Z7_NUM',;                  // [01] C Nome do campo
    '01',;                      // [02] C Ordem
    'Pedido',;                  // [03] C Titulo do campo
    X3Descric('Z7_NUM'),;       // [04] C Descri��o do campo
    Nil,;                       // [05] A Array com help
    'C',;                       // [06] C Tipo do campo
    X3Picture('Z7_NUM'),;       // [07] C Picture
    Nil,;                       // [08] B Bloco de Picture Var
    Nil,;                       // [09] C Consulta F3
    .F.,;                       // [10] L Indica se o campo � alter�vel
    Nil,;                       // [11] C Pasta de campo
    Nil,;                       // [12] C Agrupamento do campo
    Nil,;                       // [13] A Lista de valores permitidos do campo (combo)
    Nil,;                       // [14] N Tamanho m�ximo da maior op��o do combo
    Nil,;                       // [15] C Inicializador de Browse
    Nil,;                       // [16] L Indica se o campo � virtual
    Nil,;                       // [17] C Picture vari�vel
    Nil,;                       // [18] L Se verdadeiro, indica pulo de linha ap�s o campo 
  )

  oStCabec:AddField(;
    'Z7_EMISSAO',;              // [01] C Nome do campo
    '02',;                      // [02] C Ordem
    'Emiss�o',;                 // [03] C Titulo do campo
    X3Descric('Z7_EMISSAO'),;   // [04] C Descri��o do campo
    Nil,;                       // [05] A Array com help
    'D',;                       // [06] C Tipo do campo
    X3Picture('Z7_EMISSAO'),;   // [07] C Picture
    Nil,;                       // [08] B Bloco de Picture Var
    NIL,;                       // [09] C Consulta F3
    IIF(INCLUI, .T., .F.),;     // [10] L Indica se o campo � alter�vel
    Nil,;                       // [11] C Pasta de campo
    Nil,;                       // [12] C Agrupamento do campo
    Nil,;                       // [13] A Lista de valores permitidos do campo (combo)
    Nil,;                       // [14] N Tamanho m�ximo da maior op��o do combo
    Nil,;                       // [15] C Inicializador de Browse
    Nil,;                       // [16] L Indica se o campo � virtual
    Nil,;                       // [17] C Picture vari�vel
    Nil,;                       // [18] L Se verdadeiro, indica pulo de linha ap�s o campo 
  )

  oStCabec:AddField(;
    'Z7_FORNECE',;              // [01] C Nome do campo
    '03',;                      // [02] C Ordem
    'Fornecedor',;              // [03] C Titulo do campo
    X3Descric('Z7_FORNECE'),;   // [04] C Descri��o do campo
    Nil,;                       // [05] A Array com help
    'C',;                       // [06] C Tipo do campo
    X3Picture('Z7_FORNECE'),;   // [07] C Picture
    Nil,;                       // [08] B Bloco de Picture Var
    'SA2',;                     // [09] C Consulta F3
    IIF(INCLUI, .T., .F.),;     // [10] L Indica se o campo � alter�vel
    Nil,;                       // [11] C Pasta de campo
    Nil,;                       // [12] C Agrupamento do campo
    Nil,;                       // [13] A Lista de valores permitidos do campo (combo)
    Nil,;                       // [14] N Tamanho m�ximo da maior op��o do combo
    Nil,;                       // [15] C Inicializador de Browse
    Nil,;                       // [16] L Indica se o campo � virtual
    Nil,;                       // [17] C Picture vari�vel
    Nil,;                       // [18] L Se verdadeiro, indica pulo de linha ap�s o campo 
  )

  oStCabec:AddField(;
    'Z7_LOJA',;                 // [01] C Nome do campo
    '04',;                      // [02] C Ordem
    'Loja',;                    // [03] C Titulo do campo
    X3Descric('Z7_LOJA'),;      // [04] C Descri��o do campo
    Nil,;                       // [05] A Array com help
    'C',;                       // [06] C Tipo do campo
    X3Picture('Z7_LOJA'),;      // [07] C Picture
    Nil,;                       // [08] B Bloco de Picture Var
    NIL,;                       // [09] C Consulta F3
    IIF(INCLUI, .T., .F.),;     // [10] L Indica se o campo � alter�vel
    Nil,;                       // [11] C Pasta de campo
    Nil,;                       // [12] C Agrupamento do campo
    Nil,;                       // [13] A Lista de valores permitidos do campo (combo)
    Nil,;                       // [14] N Tamanho m�ximo da maior op��o do combo
    Nil,;                       // [15] C Inicializador de Browse
    Nil,;                       // [16] L Indica se o campo � virtual
    Nil,;                       // [17] C Picture vari�vel
    Nil,;                       // [18] L Se verdadeiro, indica pulo de linha ap�s o campo 
  )

  oStCabec:AddField(;
    'Z7_USER',;                 // [01] C Nome do campo
    '05',;                      // [02] C Ordem
    'Usu�rio',;                 // [03] C Titulo do campo
    X3Descric('Z7_USER'),;      // [04] C Descri��o do campo
    Nil,;                       // [05] A Array com help
    'C',;                       // [06] C Tipo do campo
    X3Picture('Z7_USER'),;      // [07] C Picture
    Nil,;                       // [08] B Bloco de Picture Var
    NIL,;                       // [09] C Consulta F3
    .F.,;                       // [10] L Indica se o campo � alter�vel
    Nil,;                       // [11] C Pasta de campo
    Nil,;                       // [12] C Agrupamento do campo
    Nil,;                       // [13] A Lista de valores permitidos do campo (combo)
    Nil,;                       // [14] N Tamanho m�ximo da maior op��o do combo
    Nil,;                       // [15] C Inicializador de Browse
    Nil,;                       // [16] L Indica se o campo � virtual
    Nil,;                       // [17] C Picture vari�vel
    Nil,;                       // [18] L Se verdadeiro, indica pulo de linha ap�s o campo 
  )

  oStItens:RemoveField('Z7_NUM')
  oStItens:RemoveField('Z7_EMISSAO')
  oStItens:RemoveField('Z7_FORNECE')
  oStItens:RemoveField('Z7_LOJA')
  oStItens:RemoveField('Z7_USER')

  // Bloqueando a edi��o dos campos ITEM e TOTAL pois s�o preenchidos automaticamente
  oStItens:SetProperty('Z7_ITEM',   MVC_VIEW_CANCHANGE, .F.)
  oStItens:SetProperty('Z7_TOTAL',  MVC_VIEW_CANCHANGE, .F.)

  // Instanciando a view
  oView := FWFormView():New()

  // Amarrando o model a view
  oView:SetModel(oModel)

  // Cria��o da estrutura de visualiza��o do Master e Detail (Cabe�alho e Item)
  oView:AddField('VIEW_SZ7M', oStCabec, 'SZ7MASTER')
  oView:AddGrid('VIEW_SZ7D', oStItens,  'SZ7DETAIL')
  oView:AddField('VIEW_SZ7T', oStTotais, 'SZ7TOTAIS')

  // Incrementar numera��o
  oView:AddIncrementField('SZ7DETAIL', 'Z7_ITEM')

  // Cria��o da tela
  oView:CreateHorizontalBox('MASTER', 20)
  oView:CreateHorizontalBox('DETAIL', 60)
  oView:CreateHorizontalBox('ROTAPE', 20)

  // Relacionar as partes da tela criada com suas estruturas
  oView:SetOwnerView('VIEW_SZ7M', 'MASTER')
  oView:SetOwnerView('VIEW_SZ7D', 'DETAIL')
  oView:SetOwnerView('VIEW_SZ7T', 'ROTAPE')

  // Setar os t�tulos
  oView:EnableTitleView('VIEW_SZ7M', 'Cabe�alho Solicita��o de Compras')
  oView:EnableTitleView('VIEW_SZ7D', 'Itens das Solicita��es de Compras')
  oView:EnableTitleView('VIEW_SZ7T', 'Rotap� das Solicita��es de Compras')

  // M�todo que seta um bloco de c�digo para verificar se a janela deve ou n�o 
  // ser fechada ap�s a execu��o do bot�o OK. 
  oView:SetCloseOnOk({|| .T.})  

Return oView

/*/{Protheus.doc} User Function VldSZ7
  @type  Function
  @author Sistematizei
  @since 03/02/2021
  @version 1.0
  @return lRet, l�gico, retorno da valida��o de inclus�o do cabe�alho
  /*/
User Function VldSZ7()
  Local lRet    := .T.
  Local aArea   := GetArea()

   // FWModelActive retorna a refer�ncia do �ltimo modelo utilizado
  Local oModel      := FWModelActive()

  // Carregando o modelo do Cabe�alho
  Local oModelCabec := oModel:GetModel('SZ7MASTER')

  // Capturando os valores que est�o no cabe�alho atrav�s do m�todo GetValue
  Local cFillSZ7    := oModelCabec:GetValue('Z7_FILIAL')
  Local cNum        := oModelCabec:GetValue('Z7_NUM')

  Local cOption     := oModelCabec:GetOperation()

  If cOption == MODEL_OPERATION_INSERT

    DbSelectArea('SZ7')
    SZ7->(DbSetOrder(1))

    If SZ7->(DbSeek(cFillSZ7 + cNum))
      Help(NIL, NIL, 'Escolha outro n�mero de pedido', NIL, 'Este pedido/solicita��o de compras j� existe em nosso sistema', 1, 0, NIL, NIL, NIL, NIL, NIL, {'ATEN��O'})
      lRet := .F.
    Endif
  Endif

  RestArea(aArea)
  
Return lRet

/*/{Protheus.doc} User Function GrvSZ7
  (long_description)
  @type  Function
  @author user
  @since 31/01/2021
  @version 1.0
  @return lRet, l�gico, retorna .T. ou .F. para a Inclus�o, Altera��o e Exclus�o
  /*/
User Function GrvSZ7()
  Local aArea       := GetArea()
  Local lRet        := .T.

  // FWModelActive retorna a refer�ncia do �ltimo modelo utilizado
  Local oModel      := FWModelActive()

  // Carregando o modelo do Cabe�alho
  Local oModelCabec := oModel:GetModel('SZ7MASTER')

  // Carregando o modelo dos Itens
  Local oModelItem  := oModel:GetModel('SZ7DETAIL')

  // Capturando os valores que est�o no cabe�alho atrav�s do m�todo GetValue
  Local cFillSZ7    := oModelCabec:GetValue('Z7_FILIAL')
  Local cNum        := oModelCabec:GetValue('Z7_NUM')
  Local dEmissao    := oModelCabec:GetValue('Z7_EMISSAO')
  Local cFornece    := oModelCabec:GetValue('Z7_FORNECE')
  Local cLoja       := oModelCabec:GetValue('Z7_LOJA') 
  Local cUser       := oModelCabec:GetValue('Z7_USER') 


  // Vari�veis que far�o a captura dos dados da grid com base no aHeader e aCols
  Local aHeaderAux  := oModelItem:aHeader
  Local aColsAux    := oModelItem:aCols

  // Pegando a posi��o de cada campo dentro do grid
  Local nPosItem    := aScan(aHeaderAux, { |x| Alltrim(Upper(x[2])) == 'Z7_ITEM'    })
  Local nPosProd    := aScan(aHeaderAux, { |x| Alltrim(Upper(x[2])) == 'Z7_PRODUTO' })
  Local nPosQtd     := aScan(aHeaderAux, { |x| Alltrim(Upper(x[2])) == 'Z7_QUANT'   })
  Local nPosPrc     := aScan(aHeaderAux, { |x| Alltrim(Upper(x[2])) == 'Z7_PRECO'   })
  Local nPosTotal   := aScan(aHeaderAux, { |x| Alltrim(Upper(x[2])) == 'Z7_TOTAL'   })

  // Pegando a linha posicionada
  Local nLinAtu 

  // Tipo de opera��o do momento (Inclus�o / Altera��o / Exclus�o)
  Local cOption     := oModelCabec:GetOperation()

  DbSelectArea('SZ7')
  SZ7->(DbSetOrder(1))

  If cOption == MODEL_OPERATION_INSERT

    For nLinAtu := 1 to Len(aColsAux)
      // Verifi��o se a linha n�o est� deletada para salvar
      If !aColsAux[nLinAtu][Len(aHeaderAux)+1]

        Reclock('SZ7', .T.) // .T. = INCLUS�O

          // DADOS DO CABE�ALHO
          Z7_FILIAL   := cFillSZ7
          Z7_NUM      := cNum
          Z7_EMISSAO  := dEmissao
          Z7_FORNECE  := cFornece
          Z7_LOJA     := cLoja
          Z7_USER     := cUser

          // DADOS DA GRID
          Z7_ITEM     := aColsAux[nLinAtu, nPosItem]
          Z7_PRODUTO  := aColsAux[nLinAtu, nPosProd]
          Z7_QUANT    := aColsAux[nLinAtu, nPosQtd]
          Z7_PRECO    := aColsAux[nLinAtu, nPosPrc]
          Z7_TOTAL    := aColsAux[nLinAtu, nPosTotal]
        SZ7->(MsUnlock())

      Endif
    Next n

  Elseif cOption == MODEL_OPERATION_UPDATE

    For nLinAtu := 1 to Len(aColsAux)
      // Verifi��o se a linha est� deletada para salvar
      If aColsAux[nLinAtu][Len(aHeaderAux)+1]

        // Se a linha estiver deletada, eu ainda preciso verificar se a linha deletada est� inclusa ou n�o no sistema/banco
        SZ7->(DbSetOrder(2)) // Filial + Numero Pedido + Item
        If SZ7->(DbSeek(cFillSZ7 + cNum + aColsAux[nLinAtu, nPosItem]))
          Reclock('SZ7', .F.)
            DbDelete()
          SZ7->(MsUnlock())
        Endif

      // Caso a linha n�o esteja exclu�da, apenas faz as altera��es
      Else

        SZ7->(DbSetOrder(2)) // Filial + Numero Pedido + Item
        // Se encontrar alterar� 
        If SZ7->(DbSeek(cFillSZ7 + cNum + aColsAux[nLinAtu, nPosItem]))
          Reclock('SZ7', .F.)
            // DADOS DO CABE�ALHO
            Z7_FILIAL   := cFillSZ7
            Z7_NUM      := cNum
            Z7_EMISSAO  := dEmissao
            Z7_FORNECE  := cFornece
            Z7_LOJA     := cLoja
            Z7_USER     := cUser

            // DADOS DA GRID
            Z7_ITEM     := aColsAux[nLinAtu, nPosItem]
            Z7_PRODUTO  := aColsAux[nLinAtu, nPosProd]
            Z7_QUANT    := aColsAux[nLinAtu, nPosQtd]
            Z7_PRECO    := aColsAux[nLinAtu, nPosPrc]
            Z7_TOTAL    := aColsAux[nLinAtu, nPosTotal]
          SZ7->(MsUnlock())     

        // N�o conseguindo encontrar cai no else e inseri     
        Else
          Reclock('SZ7', .T.)
            // DADOS DO CABE�ALHO
            Z7_FILIAL   := cFillSZ7
            Z7_NUM      := cNum
            Z7_EMISSAO  := dEmissao
            Z7_FORNECE  := cFornece
            Z7_LOJA     := cLoja
            Z7_USER     := cUser

            // DADOS DA GRID
            Z7_ITEM     := aColsAux[nLinAtu, nPosItem]
            Z7_PRODUTO  := aColsAux[nLinAtu, nPosProd]
            Z7_QUANT    := aColsAux[nLinAtu, nPosQtd]
            Z7_PRECO    := aColsAux[nLinAtu, nPosPrc]
            Z7_TOTAL    := aColsAux[nLinAtu, nPosTotal]
          SZ7->(MsUnlock())

        Endif
      Endif
    Next n
  Elseif cOption == MODEL_OPERATION_DELETE
    
    SZ7->(DbSetOrder(1)) // Filial + Numero Pedido

    While !SZ7->(EOF()) .And. SZ7->Z7_FILIAL == cFillSZ7 .And. SZ7->Z7_NUM == cNum  
      Reclock('SZ7', .F.)
        DbDelete()
      SZ7->(MsUnlock())

      SZ7->(DbSkip())
    Enddo

  /*

  // SEGUNDA FORMA DE EXCLUIR COM BASE NO QUE EST� NO GRID

    SZ7->(DbSetOrder(2))
    For nLinAtu := 1 to Len(aColsAux)
      If SZ7->(DbSeek(cFillSZ7+cNum+aColsAux[nLinAtu][nPosItem]))
        Reclock('SZ7', .F.)
          DbDelete()
        SZ7->(MsUnlock())
      Endif
    Next nLinAtu

  */

  Endif

  RestArea(aArea)

Return lRet
