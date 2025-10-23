setwd("C:\\Users\\rexma\\OneDrive\\Desktop\\ICPSR_03689\\Archivos")

require(tidyverse)
require(ggplot2)

raw_data <- read_csv("03689-0005-Data.csv")

# 1. LIMPIEZA Y REFACTORIZACIÓN COMPLETOS
# -----------------------------------------------------------------

# Primero, definimos los códigos que el estudio usa para "valor faltante"
# (Missing, Not Applicable, Don't Remember, etc.)
# Por los snippets, sabemos que -9 y -8 son comunes.
missing_codes <- c(-9, -8, -7, -6, -5, -4, -3, -2, -1)

# Ahora, creamos el dataframe limpio en un solo "pipe" (flujo de datos)
jurors_clean <- raw_data %>%
  
  # --- 1.1: SELECCIONAR ---
  # Elegimos solo las variables demográficas y de votación que nos interesan.
  select(
    # Demográficas
    GENDER, 
    AGE, 
    SCHOOL, 
    RACE, 
    RELIGON, 
    INCOME, 
    JOBSTAT,
    
    # Votación Individual
    HOWVOTE, 
    FINLVOTE,
    
    # Conteo Votación Grupal (Primer Voto)
    VOTEPROS, 
    VOTEDEFT, 
    VOTEUNDC,
    
    # Conteo Votación Grupal (Voto Final)
    VOTEPRO2, 
    VOTEDEF2, 
    VOTEUND2
  ) %>%
  
  # --- 1.2: LIMPIAR VALORES FALTANTES (Missing Values) ---
  # Reemplazamos todos los códigos de 'missing_codes' por NA.
  # Usamos across() para aplicar esta regla a *todas* las columnas seleccionadas.
  # La función 'replace' cambia el valor si la condición (estar en 'missing_codes')
  # es verdadera.
  mutate(across(everything(), ~ replace(., . %in% missing_codes, NA))) %>%
  
  # --- 1.3: RENOMBRAR (Rename) ---
  # Cambiamos los nombres por versiones en inglés (snake_case) más claras.
  rename(
    # Demográficas
    gender = GENDER,
    age_group = AGE,
    education_level = SCHOOL,
    race_ethnicity = RACE,
    religion_level = RELIGON,
    income_bracket = INCOME,
    job_status = JOBSTAT,
    
    # Votación Individual
    individual_first_vote = HOWVOTE,
    individual_final_vote = FINLVOTE,
    
    # Conteo Primer Voto
    group_first_vote_guilty = VOTEPROS,
    group_first_vote_not_guilty = VOTEDEFT,
    group_first_vote_undecided = VOTEUNDC,
    
    # Conteo Voto Final
    group_final_vote_guilty = VOTEPRO2,
    group_final_vote_not_guilty = VOTEDEF2,
    group_final_vote_undecided = VOTEUND2
  ) %>%
  
  # --- 1.4: RECODIFICAR (Recode) ---
  # Convertimos las variables numéricas categóricas en factores con etiquetas.
  # Esto hace que los análisis (ej. tablas, gráficos) sean mucho más fáciles.
  mutate(
    
    # GENDER (Asumiendo 1=Male, 2=Female)
    gender = factor(gender,
                    levels = c(1, 2),
                    labels = c("Male", "Female")),
    
    # AGE
    age_group = factor(age_group,
                       levels = 1:6,
                       labels = c("18-25", "26-35", "36-45", "46-55", "56-65", "Over 65"),
                       ordered = TRUE), # 'ordered = TRUE' indica que es una categoría ordinal
    
    # EDUCATION (SCHOOL)
    education_level = factor(education_level,
                             levels = 1:5,
                             labels = c("Less than high school", 
                                        "High school graduate", 
                                        "Some college", 
                                        "College graduate", 
                                        "Post-graduate work"),
                             ordered = TRUE),
    
    # RACE
    # Nota: El codebook tiene categorías que se solapan (ej. White/Hispanic).
    # Usamos las etiquetas exactas del snippet del Questionnaire.
    race_ethnicity = factor(race_ethnicity,
                            levels = 1:7,
                            labels = c("Black/African American",
                                       "White/Hispanic",
                                       "White/Caucasian",
                                       "Nonwhite/Hispanic",
                                       "Asian/Pacific Islander",
                                       "Native American",
                                       "Other")),
    
    # RELIGON
    religion_level = factor(religion_level,
                            levels = 1:5,
                            labels = c("Very religious",
                                       "Religious",
                                       "Neither",
                                       "Somewhat non-religious",
                                       "Very non-religious"),
                            ordered = TRUE),
    
    # INCOME
    income_bracket = factor(income_bracket,
                            levels = 1:7,
                            labels = c("Under $10,000",
                                       "$10,000 - $19,999",
                                       "$20,000 - $29,999",
                                       "$30,000 - $39,999",
                                       "$40,000 - $49,999",
                                       "$50,000 - $75,000",
                                       "Over $75,000"),
                            ordered = TRUE),
    # JOBSTAT
    job_status = case_when(
      job_status == 1 ~ "Employed full time",
      job_status == 2 ~ "Employed part time",
      job_status == 3 ~ "Self-employed",
      job_status == 4 ~ "Homemaker",
      job_status == 4 ~ "Retired",
      job_status == 5 ~ "Student",
      job_status == 6 ~ "Unemployed, and a student",
      job_status == 7 ~ "Unemployed, seeking employment",
      job_status == 8 ~ "Unemployed, not seeking employment",
      # Si hay otros códigos (ej. 7, 8), se convertirán en NA
      TRUE ~ NA_character_ 
    ) %>% factor(), # Lo convertimos en factor al final
    
    
    # --- Recodificación de Votos Individuales ---
    
    # HOWVOTE (Asumiendo 1=Culpable, 2=No Culpable, 3=Indeciso)
    individual_first_vote = factor(individual_first_vote,
                                   levels = 1:3,
                                   labels = c("Guilty", "Not Guilty", "Undecided")),
    
    # FINLVOTE (Misma codificación que HOWVOTE)
    individual_final_vote = factor(individual_final_vote,
                                   levels = 1:3,
                                   labels = c("Guilty", "Not Guilty", "Undecided"))
    
    # NOTA: Las variables de conteo de votos (ej. group_first_vote_guilty)
    # se dejan como numéricas ('numeric' o 'integer'), ya que representan
    # un conteo (0, 1, 2... 12 jurados), no una categoría.
  )

#write.csv(jurors_clean, "jurors_clean.csv", row.names = FALSE)

theme_set(theme_minimal(base_size = 12))

# --- Gráfico 1: Voto Final por Género ---
# Pregunta: ¿Existe alguna diferencia notable en el voto final entre hombres y mujeres?
# Tipo de gráfico: Barras apiladas (proporciones)
# Usamos 'position = "fill"' para ver proporciones, no conteos absolutos.
ggplot(jurors_clean, aes(x = gender, fill = individual_final_vote)) +
  geom_bar(position = "fill", color = "white") + # Añadir color blanco a los bordes de las barras
  scale_fill_viridis_d(option = "cividis", name = "Final Vote") + # Paleta de colores más agradable
  labs(
    title = "Proporción del Voto Final por Género",
    x = "Género",
    y = "Proporción",
    caption = "Fuente: Evaluación de Jurados Colgados"
  ) +
  theme(legend.position = "bottom") # Leyenda en la parte inferior

# --- Gráfico 2: Voto Final por Nivel Educativo ---
# Pregunta: ¿Varía el voto final según el nivel de educación del jurado?
# Tipo de gráfico: Barras apiladas (proporciones)
ggplot(jurors_clean, aes(x = education_level, fill = individual_final_vote)) +
  geom_bar(position = "fill", color = "white") +
  scale_fill_viridis_d(option = "cividis", name = "Final Vote") +
  labs(
    title = "Proporción del Voto Final por Nivel Educativo",
    x = "Nivel Educativo",
    y = "Proporción",
    caption = "Fuente: Evaluación de Jurados Colgados"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + # Rotar etiquetas del eje X
  theme(legend.position = "bottom")

################

# Más gráficos

################

ggplot(jurors_clean, 
       aes(x = education_level, fill = individual_final_vote)) +
  
  # Usamos position = "fill" para ver proporciones (normaliza cada barra a 100%)
  geom_bar(position = "fill", color = "white", alpha = 0.8) +
  
  # La magia: crea un sub-gráfico para cada valor de 'race_ethnicity'
  facet_wrap(~ race_ethnicity, ncol = 3) + 
  
  # --- Estética y Etiquetas ---
  scale_fill_manual(values = c("Guilty" = "#d95f02", 
                               "Not Guilty" = "#1b9e77", 
                               "Undecided" = "#7570b3"),
                    name = "Voto Final") +
  labs(
    title = "Voto Final por Educación y Etnia",
    subtitle = "Distribución proporcional del voto final dentro de cada nivel educativo",
    x = "Nivel Educativo",
    y = "Proporción"
  ) +
  theme(
    # Rotar etiquetas del eje X para que no se solapen
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    legend.position = "bottom",
    # Títulos de las facetas más claros
    strip.text = element_text(face = "bold", size = 10) 
  )

ggplot(jurors_clean, 
       aes(x = income_bracket, fill = individual_final_vote)) +
  
  geom_bar(position = "fill", color = "white", alpha = 0.8) +
  
  # Crear facetas para "Male" y "Female"
  facet_wrap(~ gender) +
  
  # --- Estética y Etiquetas ---
  scale_fill_manual(values = c("Guilty" = "#d95f02", 
                               "Not Guilty" = "#1b9e77", 
                               "Undecided" = "#7570b3"),
                    name = "Voto Final") +
  labs(
    title = "Voto Final por Nivel de Ingresos y Género",
    subtitle = "Distribución proporcional del voto final dentro de cada rango de ingresos",
    x = "Rango de Ingresos",
    y = "Proporción"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    legend.position = "bottom",
    strip.text = element_text(face = "bold", size = 12)
  )

ggplot(jurors_clean, 
       aes(x = age_group, fill = individual_final_vote)) +
  
  geom_bar(position = "fill", color = "white", alpha = 0.8) +
  
  # Crear facetas para cada nivel de religiosidad
  facet_wrap(~ religion_level, ncol = 3) +
  
  # --- Estética y Etiquetas ---
  scale_fill_manual(values = c("Guilty" = "#d95f02", 
                               "Not Guilty" = "#1b9e77", 
                               "Undecided" = "#7570b3"),
                    name = "Voto Final") +
  labs(
    title = "Voto Final por Edad y Nivel de Religiosidad",
    subtitle = "Distribución proporcional del voto final dentro de cada grupo de edad",
    x = "Rango de Edad",
    y = "Proporción"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    legend.position = "bottom",
    strip.text = element_text(face = "bold", size = 10)
  )

