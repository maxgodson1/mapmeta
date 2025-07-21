#' Standardize Compound Names for KEGG Matching
#'
#' Cleans chemical names optimized for KEGG database matching.
#'
#' @param names_vector Character vector of compound names
#'
#' @return Character vector of standardized names
#'
#' @details
#' **Specifically tuned for KEGG**, this function:
#' \itemize{
#'   \item Removes KEGG annotations in brackets (e.g., `"[Similar to...]"`)
#'   \item Eliminates stereochemical descriptors (e.g., `"(2S,3R)"`)
#'   \item Cleans numeric artifacts from Compound Discoverer exports
#'   \item Standardizes KEGG-specific base names (e.g., `"norchol"` → `"norcholane"`)
#'   \item Normalizes hyphens and whitespace
#' }
#'
#' @note
#' **Not suitable for other chemical databases** (e.g., HMDB, PubChem) which use
#' different naming conventions.
#'
#' @examples
#' compound_names <- c(
#'   "Testosterone [Similar to Androgen]",
#'   "D-Glucose (2S,3R)",
#'   "-123-Cholestane-1-ene",
#'   "norchol derivative"
#' )
#'
#' standardized <- standardize_name(compound_names)
#' print(standardized)  # "Testosterone" "D-Glucose" "Cholestane-ene" "norcholane derivative"
#'
#' @importFrom stringr str_replace_all str_replace
#' @export

standardize_name <- function(names_vector) {
  names_vector %>%
    str_replace_all("\\[.*?\\]", "") %>%
    str_replace_all("\\s*\\(.*?\\)", "") %>%
    str_replace_all("(?:^|\\s)-\\d+[-A-Za-z]*", "") %>%
    str_replace_all("-\\d+(-|$)", "\\1") %>%
    str_replace("norchol", "norcholane") %>%
    trimws() %>%
    str_replace_all("--+", "-")
}
