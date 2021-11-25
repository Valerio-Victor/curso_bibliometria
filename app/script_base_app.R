

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(magrittr, include.only = '%>%')


ui <- dashboardPage(

title = 'Nome do App', skin = 'yellow',

dashboardHeader(titleWidth = 280, title = span(tagList(icon('sitemap'), '  Nome do App'))),

dashboardSidebar(width = 280,

    sidebarMenu(

    menuItem('SOBRE', tabName = 'informacao_total', icon = icon('info-circle'),

             menuSubItem('Sobre o App', tabName = 'info', icon = icon('book')),

             menuSubItem('Desenvolvedores', tabName = 'pessoas', icon = icon('users'))),

    menuItem('TRATAMENTO DOS DADOS', tabName = 'tratamento', icon = icon('cogs'),

             menuSubItem('Agregação', tabName = 'agregacao', icon = icon('database')))

)),

dashboardBody(

  tabItems(

    tabItem(tabName = 'info',
            fluidRow(
              box(
                title = 'Objetivo do Aplicativo',
                width = 12,
                status = 'warning',
                solidHeader = TRUE,
                collapsible = FALSE,
                closable = FALSE,
                'Este aplicativo, ainda em fase de teste e desenvolvimento, foi
                estruturado com a finalidade de facilitar o processo de arrumação
                de uma base de metadados científicos e/ou agregação
                de metadados científicos provenientes de diferentes bases de modo
                a viabilizar, em seguida, a implementação de análise bibliométrica
                no R (com o pacote Bibliometrix). Mais especificamente, nesta
                primeira versão só será possível agregar os metadados das bases
                SCOPUS e Web of Science.
                Cumpre ressaltar que o app foi desenvolvido para o I Curso de
                Introdução à Análise Bibliométrica com R e é útil para quem ainda
                não possui familiaridade com programação, mas pretende
                implementar uma análise bibliométrica a partir das supracitadas
                bases.'
              ),
              box(
                title = 'Como Utilizar?',
                width = 12,
                status = 'warning',
                solidHeader = TRUE,
                collapsible = FALSE,
                closable = FALSE,
                'Para esta primeira versão o processo ainda ocorrerá em uma
                sequência maior de passos (mais burocrático). Em primeiro lugar,
                você deverá gerar os arquivos em formato "Rdata" para as bases
                SCOPUS e/ou Web of Science a partir do pacote bibliometrix
                (utilizando o biblioshiny). Na sequência, você deverá importar
                estes arquivos neste app para posterior arrumação e/ou agregação
                e download da base consolidada (o dowload sempre será em formato
                "xlsx"). Por fim, o arquivo poderá ser utilizado em posterior
                análise no pacote Bibliometrix (mais uma vez, utilizando o
                biblioshiny).'
              ))),
    tabItem(tabName = 'pessoas',
            fluidRow(
              box(
                title = 'Desenvolvedor',
                width = 6,
                status = 'warning',
                solidHeader = TRUE,
                collapsible = FALSE,
                closable = FALSE,
                h4('Victor Valerio'),
                br(),
                'Possui graduação em ciências econômicas pela Universidade
                Estadual Paulista Júlio de Mesquita Filho (2011), mestrado em
                engenharia de produção pela Universidade Federal de Itajubá
                (2015) e doutorado em engenharia de produção pela Universidade
                Federal de Itajubá (2018), foi bolsista da CAPES em ambos os
                casos. Atualmente é professor adjunto da Universidade Federal
                de Itajubá no Instituto de Engenharia de Produção e Gestão. É
                revisor de congressos nacionais na área de análise financeira
                de investimentos, pesquisa operacional, projetos de energia
                renovável e previsão. Tem experiência profissional e acadêmica
                na área de economia e engenharia de produção.'
              ),
              box(
                title = 'Contribuidora',
                width = 6,
                status = 'warning',
                solidHeader = TRUE,
                collapsible = FALSE,
                closable = FALSE,
                h4('Andréa Mineiro'),
                br(),
                'Possui graduação em Administração de Empresas (Empreendedorismo
                e Negócios pela Universidade Federal de Itajubá (2003),
                Especialização em Qualidade e Produtividade (2005), Mestrado
                em Engenharia de Produção pela Universidade Federal de Itajubá
                (2007) e Doutorado em Administração pela Universidade Federal
                de Lavras (2019). Atualmente é professor Adjunto nível 3 - de
                da Universidade Federal de Itajubá e professor-pesquisador da
                Universidade Federal de Itajubá. Tem experiência na área de
                Administração, com ênfase em Empreendedorismo, atuando
                principalmente nos seguintes temas: investidores anjos,
                empreendedorismo tecnológico, empreendedorismo social, empresa
                de base tecnológica e inovação, Parques Tecnológicos, Hélice
                Tríplice, Quádrupla e Quíntupla.'))),
    tabItem(tabName = 'agregacao',
            fluidRow(
              box(
                title = 'IMPORTAÇÃO DOS DADOS',
                width = 7,
                status = 'warning',
                solidHeader = TRUE,
                collapsible = FALSE,
                closable = FALSE,
                column(width = 10,
                fluidRow(fileInput('dados_wos', 'Insira os Metadados da Base Web Of Science (WOS):', accept = 'Rdata'))
                ),
                column(width = 10,
                       fluidRow(fileInput('dados_scopus', 'Insira os Metadados da Base SCOPUS:', accept = 'Rdata'))
                ),
                column(width = 10,
                       actionButton('importacao', '  EXECUTAR IMPORTAÇÃO', icon = icon('upload'))
                )),
              box(
                title = 'EXPORTAÇÃO DOS DADOS',
                width = 5,
                status = 'warning',
                solidHeader = TRUE,
                collapsible = FALSE,
                closable = FALSE,
                column(width = 10,
                       fluidRow(downloadButton('download', 'BAIXAR OS DADOS AGREGADOS'))
                ))
              ))
)))


server <- function(input, output, session) {


  observeEvent(input$importacao,{

  caminho_scopus <- input$dados_scopus
  dados_scopus <- load(caminho_scopus$datapath)
  dados_scopus <- M

  caminho_wos <- input$dados_wos
  dados_wos <- load(caminho_wos$datapath)
  dados_wos <- M

  dados <- bibliometrix::mergeDbSources(dados_wos,
                                    dados_scopus,
                                    remove.duplicated = TRUE)

  output$download <- downloadHandler(
    filename <-  function() {
      paste0('base_agregada', '.Rdata')
    },
    content <-  function(file) {
      save(dados, file = file)
    }
  )


  })


}


shinyApp(ui, server)



