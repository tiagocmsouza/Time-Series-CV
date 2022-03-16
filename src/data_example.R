# DOWNLOAD AND TIDY DATA FOR EXAMPLE ----

data_links <- list(
  manufacturing = "https://apisidra.ibge.gov.br/values/t/3653/v/3134/c544/129316/p/all/n1/all",
  retail = "https://apisidra.ibge.gov.br/values/t/3417/v/1186/c11046/40312/p/all/n1/all")

download_data <- function(url) {
  data <- GET(url = url) %>% 
    content(as = "parsed") %>% 
    map_dfr(., ~.)
}

data <- map_dfr(data_links, download_data, .id = "variable") %>% 
  
  filter(NC == "1") %>% 
  
  transmute(
    variable = variable,
    date = ymd(paste0(D3C,"01")),
    value = as.numeric(V)) %>% 
  
  group_by(variable) %>% 
  
  mutate(value = value / lag(value, n=1) - 1) %>% 
  
  drop_na() %>% 
  
  ungroup()

write_csv(data, "data/data_example.csv")
