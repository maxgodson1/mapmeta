#' Search KEGG ID by Formula and Name Similarity
#'
#' Identifies best matching KEGG compound ID using formula search and name similarity.
#'
#' @param name Compound name to match
#' @param formula Molecular formula to search
#' @param similarity_threshold Minimum similarity for auto-acceptance (default = 0.8)
#'
#' @return List containing:
#' \itemize{
#'   \item `KEGG_ID`: KEGG compound ID (e.g., "C00031")
#'   \item `KEGG_Name`: Official KEGG compound name
#'   \item `Similarity`: Name similarity score (0-1)
#'   \item `Status`: Match status ("Auto-accepted", "Needs verification", etc.)
#' }
#'
#' @details
#' Matching process:
#' \itemize{
#'   \item Searches KEGG for formula matches
#'   \item If no matches, returns "No match" status
#'   \item For each match:
#'   \itemize{
#'     \item Retrieves official KEGG name
#'     \item Calculates name similarity
#'   }
#'   \item Selects compound with highest similarity
#'   \item Returns status based on threshold
#' }
#'
#' @note
#' Important:
#' \itemize{
#'   \item Requires internet connection
#'   \item Formula search is case-sensitive
#'   \item Name comparison is case-insensitive
#'   \item Respect KEGG API rate limits
#' }
#'
#' @examples
#' \dontrun{
#' # Glucose search
#' keggidsearching("Glucose", "C6H12O6")
#'
#' # Low similarity
#' keggidsearching("Sugar", "C6H12O6", similarity_threshold = 0.9)
#'
#' # No match
#' keggidsearching("Unknown", "Xyz123")
#' }
#'
#' @importFrom KEGGREST keggFind keggGet
#' @seealso \code{\link{calculate_name_similarity}},
#'          \code{\link{keggidbatchsearching}}
#' @export

keggidsearching <- function(name, formula, similarity_threshold = 0.8) {
  tryCatch({
    # 1. 在KEGG中按分子式搜索化合物
    formula_results <- KEGGREST::keggFind("compound", formula, "formula")

    # 2. 如果没有匹配结果，返回NA
    if (length(formula_results) == 0) {
      return(list(
        KEGG_ID = NA,
        KEGG_Name = NA,
        Similarity = NA,
        Status = "No match"
      ))
    }

    # 3. 初始化最佳匹配变量
    best_match_id <- NULL
    best_match_name <- NULL
    best_similarity <- -1  # 初始化为最小值

    # 4. 遍历所有匹配结果
    for (id in names(formula_results)) {
      # 4.1 获取KEGG化合物详细信息
      compound_info <- KEGGREST::keggGet(id)[[1]]

      # 4.2 提取KEGG中的名称(取第一个名称)
      kegg_name <- compound_info$NAME[1]

      # 4.3 计算名称相似度
      similarity <- calculate_name_similarity(name, kegg_name)

      # 4.4 更新最佳匹配
      if (similarity > best_similarity) {
        best_similarity <- similarity
        best_match_id <- id
        best_match_name <- kegg_name
      }
    }

    # 5. 根据相似度阈值确定状态
    status <- ifelse(
      best_similarity >= similarity_threshold,
      "Auto-accepted",
      "Needs verification"
    )

    # 6. 返回匹配结果
    return(list(
      KEGG_ID = best_match_id,
      KEGG_Name = best_match_name,
      Similarity = best_similarity,
      Status = status
    ))

  }, error = function(e) {
    # 7. 错误处理
    return(list(
      KEGG_ID = NA,
      KEGG_Name = NA,
      Similarity = NA,
      Status = paste("Error:", e$message)
    ))
  })
}

