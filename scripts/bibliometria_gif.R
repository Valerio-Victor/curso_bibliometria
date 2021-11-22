

library(magrittr, include.only = '%>%')
library(bibliometrix)



dados_wos <- bibliometrix::convert2df(file = list.files(path = './dados/',
                                                        full.names = TRUE,
                                                        pattern = '.txt'),
                                      dbsource = 'wos',
                                      format = 'plaintext')


M <- dados_wos %>%
  dplyr::filter(DT == 'ARTICLE',
                LA != 'ENGLISH',
                PY < 2021)


dados_resultados <- bibliometrix::biblioAnalysis(M)


resumo <- summary(dados_resultados)


serie_temporal <- resumo %>%
  purrr::pluck('AnnualProduction') %>%
  janitor::clean_names() %>%
  dplyr::rename('Anos' = year, 'Artigos' = articles) %>%
  dplyr::mutate(Anos = as.Date(as.character(Anos), format = '%Y'))


graf <- serie_temporal %>%
  ggplot2::ggplot() +
  ggplot2::geom_line(mapping = ggplot2::aes(x = Anos,
                                            y = Artigos),
                     color = '#324670',
                     size = 1) +
  ggplot2::geom_point(mapping = ggplot2::aes(x = Anos,
                                             y = Artigos),
                      color = '#324670',
                      size = 2) +
  ggplot2::geom_label(mapping = ggplot2::aes(x = Anos,
                                             y = Artigos,
                                             label = paste0(Artigos)),
                     color = '#324670',
                     size = 5,
                     nudge_x = -0.1,
                     nudge_y = 1) +
  ggplot2::theme(legend.position = 'none') +
  ggplot2::labs(title =
                  'Quantidade de Publicações de Artigos Bibliométricos ',
                subtitle =
                  '(Base: Web os Science)')


graf


graf_animation <- graf +
  gganimate::transition_reveal(Anos)


graf_animation


gganimate::anim_save(animation = graf_animation, file = './divulgacao/crescimento.gif')


