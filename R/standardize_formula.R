#' Standardize Molecular Formula Strings
#'
#' Cleans and standardizes molecular formula strings.
#'
#' @param formula_vector Character vector of molecular formulas
#'
#' @return Character vector of standardized formulas with:
#' \itemize{
#'   \item Internal spaces removed
#'   \item Leading/trailing whitespace trimmed
#' }
#'
#' @details
#' Performs:
#' \itemize{
#'   \item Removal of all internal spaces (e.g., "C6 H12 O6" → "C6H12O6")
#'   \item Trimming of leading/trailing whitespace (e.g., " H2O " → "H2O")
#' }
#'
#' @examples
#' formulas <- c(" H2O ", " C6 H12 O6 ", "Na Cl", " Fe3 O4 ")
#' standard_formulas <- standardize_formula(formulas)
#' print(standard_formulas)  # "H2O" "C6H12O6" "NaCl" "Fe3O4"
#'
#' @export

standardize_formula <- function(formula_vector) {
  # 去除所有空格并移除首尾空白
  result <- trimws(gsub(" ", "", formula_vector))
  return(result)
}
