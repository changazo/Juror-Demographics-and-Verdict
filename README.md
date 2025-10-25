# Codebook — `jurors_case_count`  (ICPSR 03689; Parts 5 + 1 + 2 merged)

This codebook documents the consolidated dataset **`jurors_case_count`**, created by joining:
- **Part 5 – Juror Survey** (`03689-0005-Data.csv`)  → individual juror records
- **Part 1 – Case Data** (`03689-0001-Data.csv`)     → defendant/victim & case context
- **Part 2 – Count Sheet** (`03689-0002-Data.csv`)   → offense type & case-level outcomes

Join keys (normalized to consistent types/format):
- `site`  (jurisdiction code)
- `case_id`  (court case number; normalized string/integer)

All categorical variables were recoded to readable **English labels**. Common missing codes from the source (e.g., `-9`, `-8`, `9`, `99`, `999`) were set to **NA**.

--------------------------------------------------------------------------------
## 0) Identification & Join Keys

| Variable      | Description                                              | Type / Levels |
|---------------|----------------------------------------------------------|---------------|
| `site`        | Jurisdiction code. Typical mapping: `1=Los Angeles (CA)`, `2=Maricopa (AZ)`, `4=Bronx (NY)`, `5=Washington, DC)` | Factor/Int |
| `case_id`     | Case number (normalized).                                | String        |
| `juror_id`    | Juror/person identifier (if present from Part 5).        | String/Int    |
| `juror_number`| Juror’s seat number within the case (if present).        | Int           |

> Note: `juror_id` / `juror_number` depend on availability in Part 5 export.

--------------------------------------------------------------------------------
## 1) Juror Demographics (from Part 5)

| Variable                  | Description                                   | Type / Levels |
|---------------------------|-----------------------------------------------|---------------|
| `gender`                  | Juror gender                                  | `Male`, `Female` |
| `age_group`               | Juror age band                                | `<25`, `25–34`, `35–44`, `45–54`, `55–64`, `65+` |
| `race_ethnicity`          | Juror race/ethnicity                          | `White, non-Hispanic`, `White, Hispanic`, `Black, non-Hispanic`, `Black, Hispanic`, `Asian`, `Other` |
| `religion`                | Religious identity                            | `Protestant`, `Catholic`, `Jewish`, `None`, `Other` |
| `education_level`         | Highest education attained                    | `Less than HS`, `HS graduate`, `Some college`, `College graduate`, `Postgraduate` |
| `employment_status`       | Employment situation                          | `Full-time`, `Part-time`, `Unemployed`, `Retired`, `Homemaker`, `Student` |
| `occupation_text_or_code` | Occupation (free-text or coded, as provided)  | String / Code |
| `income_bracket_usd_2000` | Household income bracket (2000–2001 USD)      | `<$15k`, `$15–25k`, `$25–35k`, `$35–50k`, `$50–75k`, `$75k+` |
| `prior_jury_experience`   | Has served on a jury before                   | `Yes`, `No` |
| `was_foreperson`          | Served as foreperson in this jury             | `Yes`, `No` |

--------------------------------------------------------------------------------
## 2) Juror Voting & Deliberation (from Part 5)

| Variable                        | Description                                                  | Type / Levels |
|---------------------------------|--------------------------------------------------------------|---------------|
| `first_vote_timing`             | When the first ballot occurred                               | `Beginning`, `Within 10 min`, `Early`, `Middle`, `Late`, `Very end` |
| `first_vote_secret`             | Whether first ballot was secret                              | `Yes`, `No` (undocumented extra code mapped if present) |
| `first_vote_choice`             | Juror’s own vote on the first ballot (most serious charge)   | `Guilty`, `Not guilty`, `Undecided` |
| `first_vote_certainty_1to7`     | Self-rated certainty on first vote (Likert 1–7)              | Ordered [1–7] |
| `if_only_me_verdict`            | What verdict if only this juror decided                      | `Guilty`, `Not guilty` |
| `ease_reach_verdict_1to7`       | Ease/difficulty for the jury to reach a decision (1–7)       | Ordered [1–7] |
| `satisfaction_with_verdict`     | Satisfaction with final verdict (1–7)                        | Ordered [1–7] |
| `jury_openminded_1to7`          | Perceived open-mindedness of jurors (1–7)                    | Ordered [1–7] |
| `participation_1to7`            | Self-rated participation in deliberations (1–7)              | Ordered [1–7] |
| `influence_1to7`                | Self-rated influence in deliberations (1–7)                  | Ordered [1–7] |
| `domination_1to7`               | Degree to which 1–2 jurors dominated (1–7)                   | Ordered [1–7] |
| `conflict_1to7`                 | Level of conflict among jurors (1–7)                         | Ordered [1–7] |
| `viewpoints_considered_1to7`    | Whether viewpoints were considered (1–7)                     | Ordered [1–7] |
| `had_enough_time`               | Juror felt they had enough time to express views             | `Yes`, `No` |

**Group tallies** (if present in your Part 5 export):
- `group_first_vote_guilty` / `group_first_vote_not_guilty` / `group_first_vote_undecided` → integers `0–12`.
- `group_final_vote_guilty` / `group_final_vote_not_guilty` / `group_final_vote_undecided` → integers `0–12`.

> If your source lacked “final vote” items, only the “first vote” fields appear populated.

--------------------------------------------------------------------------------
## 3) Defendant, Victim & Case Context (from Part 1 – Case Data)

| Variable                              | Description                                      | Type / Levels |
|---------------------------------------|--------------------------------------------------|---------------|
| `defendant_gender`                    | Defendant gender                                 | `Male`, `Female` |
| `defendant_race_ethnicity`            | Defendant race/ethnicity                         | `White, non-Hispanic`, `White, Hispanic`, `Black, non-Hispanic`, `Black, Hispanic`, `Asian`, `Other` |
| `defendant_representation`            | Representation type                              | `Private`, `Court-app. private`, `Public defender`, `Pro se` |
| `victim_gender`                       | Victim gender (if applicable)                    | `Male`, `Female` |
| `victim_race_ethnicity`               | Victim race/ethnicity (if applicable)            | Same categories as defendant |
| `victim_relationship`                 | Relationship between defendant and victim        | `Spouse/domestic partner`, `Other family`, `Employee/employer`, `Other acquaintance`, `None`, `Relationship not known` |
| `num_victims`                         | Number of victims in the case                    | Integer (≥0) |
| `defendant_criminal_history_known`    | Whether jury was informed about prior record     | `Yes`, `No` |
| `sentencing_possibilities_known`      | Whether jury was told about potential sentences  | `Yes`, `No` |

--------------------------------------------------------------------------------
## 4) Offense Type & Case-Level Outcomes (from Part 2 – Count Sheet)

| Variable             | Description                                            | Type / Levels |
|----------------------|--------------------------------------------------------|---------------|
| `case_type`          | Primary offense category (case-level typicity)         | `Murder, 1st degree`, `Murder, 2nd degree`, `Manslaughter`, `Sexual offenses / minor`, `Robbery`, `Assault (non-sexual)`, `Child abuse/neglect`, `Burglary`, `Larceny/theft`, `Arson`, `Drugs: possession`, `Drugs: sale`, `Drugs: manufacture`, `DUI/DWI`, `Attempted murder`, `Weapons`, `Forgery`, `Unlawful flight / leaving scene / failure to stop`, `Other` |
| `total_counts`       | Total number of charges considered by the jury         | Integer (≥0) |
| `total_convictions`  | # charges with **conviction**                          | Integer (≥0) |
| `total_acquittals`   | # charges with **acquittal**                           | Integer (≥0) |
| `total_hung_counts`  | # charges with **hung jury**                           | Integer (≥0) |
| `sentence_range`     | Sentence range category (case-level)                   | `<1 year`, `1–5 years`, `5–10 years`, `10–20 years`, `20+ years`, `Life` |

> Notes on totals: Typically, `total_convictions + total_acquittals + total_hung_counts` ≈ `total_counts`. Differences can occur where certain counts were not fully adjudicated or coded as “not considered”.

--------------------------------------------------------------------------------
## 5) Provenance & Processing Notes

- **Source study**: ICPSR **03689** “Evaluation of Hung Juries in Bronx County (NY), Los Angeles County (CA), Maricopa County (AZ), and Washington, DC, 2000–2001.”  
- **Files used**: `03689-0005-Data.csv` (Juror Survey), `03689-0001-Data.csv` (Case Data), `03689-0002-Data.csv` (Count Sheet).  
- **Merging**: Left-joined Part 1 and Part 2 onto Part 5 at `site` + `case_id`.  
- **Cleaning**: Missing codes (`-9`, `-8`, `9`, `99`, `999`) set to `NA`. Categorical codes mapped to human-readable labels per study codebook.  
- **Normalization**: `case_id` standardized (parse-number → string). `site` harmonized across parts.  

--------------------------------------------------------------------------------
## 6) Quick-start (R)

```r
# read
df <- readr::read_csv("jurors_case_count.csv")

# basic example: probability of 'Guilty' on first vote by defendant race & case type
library(dplyr)
library(ggplot2)
p <- df %>%
  filter(first_vote_choice %in% c("Guilty","Not guilty"),
         !is.na(defendant_race_ethnicity), !is.na(case_type)) %>%
  mutate(vote_guilty = as.integer(first_vote_choice == "Guilty")) %>%
  group_by(defendant_race_ethnicity, case_type) %>%
  summarise(p_guilty = mean(vote_guilty), n = n(), .groups = "drop") %>%
  ggplot(aes(x = case_type, y = p_guilty, group = defendant_race_ethnicity)) +
  geom_line() + geom_point() +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "Case type", y = "% Guilty (first vote)",
       color = "Defendant race/ethnicity",
       title = "First-vote 'Guilty' by defendant race & case type") +
  theme_minimal(base_size = 11)
print(p)
