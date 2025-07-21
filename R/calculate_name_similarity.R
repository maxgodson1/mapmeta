#' Calculate Name Similarity Score
#'
#' Computes a normalized similarity score between two names based on the
#' Levenshtein (edit) distance.
#'
#' @param name1 First name string for comparison
#' @param name2 Second name string for comparison
#'
#' @return Similarity score between 0 and 1, where:
#' \itemize{
#'   \item `1` indicates identical names
#'   \item `0` indicates completely dissimilar names
#'   \item Scores close to `1` indicate high similarity
#' }
#'
#' @details
#' This function calculates name similarity using the following process:
#' \itemize{
#'   \item Converts both names to lowercase for case-insensitive comparison
#'   \item Computes Levenshtein edit distance (minimum single-character edits)
#'   \item Normalizes distance to 0-1 scale based on maximum name length
#' }
#'
#' The similarity score is calculated as:
#' \deqn{similarity = 1 - \frac{edit\ distance}{\max(nchar(name1), nchar(name2))}}
#'
#' @examples
#' # Identical names
#' calculate_name_similarity("Glucose", "Glucose")  # returns 1.0
#'
#' # Similar names
#' calculate_name_similarity("Glucose", "Glucoze")  # returns ~0.857
#'
#' # Different names
#' calculate_name_similarity("Glucose", "Fructose") # returns ~0.286
#'
#' # Case difference
#' calculate_name_similarity("glucose", "GLUCOSE")  # returns 1.0
#'
#' @seealso
#' For advanced string matching, see the \code{stringdist} package.
#' @export

calculate_name_similarity <- function(name1, name2) {
  # 功能: 计算两个名称之间的相似度(基于编辑距离)
  # 参数: name1, name2 - 要比较的两个名称
  # 返回: 相似度分数(0-1, 1表示完全相同)

  # 1. 转换为小写以忽略大小写差异
  name1_lower <- tolower(name1)
  name2_lower <- tolower(name2)

  # 2. 计算编辑距离(Levenshtein距离)
  distance <- adist(name1_lower, name2_lower)[1, 1]

  # 3. 计算最大可能距离
  max_length <- max(nchar(name1_lower), nchar(name2_lower))

  # 4. 计算相似度分数
  similarity <- 1 - (distance / max_length)

  return(similarity)
}
