# Codebook para el dataset 'jurors_clean'

Este codebook describe las variables contenidas en el dataset `jurors_clean`, que fue procesado a partir del dataset original `03689-0005-Data.csv` correspondiente a encuestas a jurados entre 2000 y 2001 en Washington DC, Estados Unidos. Se renombraron las variables a un formato más legible (snake_case) y se recodificaron las variables categóricas a factores con etiquetas descriptivas en inglés.

---

## 1. Variables demográficas

| Nombre de variable     | Descripción                                   | Tipo de variable | Niveles (valores recodificados)                                             |
| :--------------------- | :-------------------------------------------- | :--------------- | :-------------------------------------------------------------------------- |
| `gender`               | Género del miembro del jurado.                | Factor           | `Male`, `Female`                                                            |
| `age_group`            | Rango de edad del miembro del jurado.         | Factor (Ordenado)| `18-25`, `26-35`, `36-45`, `46-55`, `56-65`, `Over 65`                        |
| `education_level`      | Nivel educativo más alto alcanzado.           | Factor (Ordenado)| `Less than high school`, `High school graduate`, `Some college`, `College graduate`, `Post-graduate work` |
| `race_ethnicity`       | Raza o etnicidad del miembro del jurado.      | Factor           | `Black/African American`, `White/Hispanic`, `White/Caucasian`, `Nonwhite/Hispanic`, `Asian/Pacific Islander`, `Native American`, `Other` |
| `religion_level`       | Nivel de religiosidad del miembro del jurado. | Factor (Ordenado)| `Very religious`, `Religious`, `Neither`, `Somewhat non-religious`, `Very non-religious` |
| `income_bracket`       | Rango de ingresos anuales del hogar.          | Factor (Ordenado)| `Under $10,000`, `$10,000 - $19,999`, `$20,000 - $29,999`, `$30,000 - $39,999`, `$40,000 - $49,999`, `$50,000 - $75,000`, `Over $75,000` |
| `job_status`           | Situación laboral del miembro del jurado.     | Factor           | `Employed full time`, `Employed part time`, `Self-employed`, `Homemaker`, `Retired`, `Student`, `Unemployed, and a student`, `Unemployed, seeking employment`, `Unemployed, not seeking employment` |

---

## 2. Variables de votación individual

| Nombre de variable        | Descripción                                                                          | Tipo de variable | Niveles (valores recodificados)                 |
| :------------------------ | :----------------------------------------------------------------------------------- | :--------------- | :---------------------------------------------- |
| `individual_first_vote`   | Voto individual inicial del miembro del jurado en la primera votación o sondeo.    | Factor           | `Guilty` (Culpable), `Not Guilty` (No Culpable), `Undecided` (Indeciso) |
| `individual_final_vote`   | Voto individual final del miembro del jurado después de las deliberaciones.        | Factor           | `Guilty` (Culpable), `Not Guilty` (No Culpable), `Undecided` (Indeciso) |

---

## 3. Variables de votación grupal (Conteo de votos)

Estas variables representan el conteo total de votos para cada categoría, según lo recordado por el miembro del jurado que responde la encuesta.

### Primer voto grupal

| Nombre de variable                  | Descripción                                                                     | Tipo de variable | Rango           |
| :---------------------------------- | :------------------------------------------------------------------------------ | :--------------- | :-------------- |
| `group_first_vote_guilty`           | Número de votos para Culpable en la primera votación grupal.                  | Numérico         | 0-12            |
| `group_first_vote_not_guilty`       | Número de votos para No Culpable en la primera votación grupal.               | Numérico         | 0-12            |
| `group_first_vote_undecided`        | Número de votos para Indeciso en la primera votación grupal.                  | Numérico         | 0-12            |

### Voto final grupal

| Nombre de variable                 | Descripción                                                                    | Tipo de variable | Rango           |
| :--------------------------------- | :----------------------------------------------------------------------------- | :--------------- | :-------------- |
| `group_final_vote_guilty`          | Número de votos para Culpable en la votación grupal final.                     | Numérico         | 0-12            |
| `group_final_vote_not_guilty`      | Número de votos para No Culpable en la votación grupal final.                  | Numérico         | 0-12            |
| `group_final_vote_undecided`       | Número de votos para Indeciso en la votación grupal final.                     | Numérico         | 0-12            |

---
