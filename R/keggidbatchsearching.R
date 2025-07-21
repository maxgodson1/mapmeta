#' Batch Search KEGG IDs for Compounds
#'
#' Performs batch search of KEGG compound IDs using molecular formula matching
#' and name similarity verification.
#'
#' @param data Data frame containing compound information with:
#' \itemize{
#'   \item `Standardized_Name`: Standardized compound names
#'   \item `Formula`: Molecular formulas
#' }
#' @param similarity_threshold Similarity threshold for auto-acceptance (default = 0.8)
#' @param delay Delay between API calls in seconds (default = 1)
#'
#' @return Input data frame with added columns:
#' \itemize{
#'   \item `KEGG_ID`: Matched KEGG compound ID
#'   \item `KEGG_Name`: Official KEGG compound name
#'   \item `Similarity`: Name similarity score (0-1)
#'   \item `Status`: Matching status ("Auto-accepted", "Needs verification", etc.)
#' }
#'
#' @details
#' This function:
#' \itemize{
#'   \item Iterates through each compound in input data
#'   \item Uses \code{\link{keggidsearching}} for individual compound matching
#'   \item Adds rate limiting to respect KEGG API policies
#'   \item Provides real-time progress messages
#' }
#'
#' @note
#' Important considerations:
#' \itemize{
#'   \item Requires internet connection to access KEGG API
#'   \item Processing time scales with dataset size (~1 compound/second)
#'   \item For large datasets, increase delay to avoid API restrictions
#'   \item Returns NA for compounds without KEGG matches
#' }
#'
#' @examples
#' \dontrun{
#' sample_data <- data.frame(
#'   Standardized_Name = c("Glucose", "Testosterone", "Caffeine"),
#'   Formula = c("C6H12O6", "C19H28O2", "C8H10N4O2")
#' )
#'
#' mapped_data <- keggidbatchsearching(sample_data)
#'
#' print(mapped_data[, c("Standardized_Name", "KEGG_ID", "Similarity", "Status")])
#' }
#'
#' @seealso \code{\link{keggidsearching}} for single compound matching
#' @export

keggidbatchsearching <- function(data, similarity_threshold = 0.8, delay = 1) {
  # 1. 验证输入数据
  required_cols <- c("Standardized_Name", "Formula")
  if (!all(required_cols %in% names(data))) {
    missing_cols <- setdiff(required_cols, names(data))
    stop("输入数据框缺少必要的列: ", paste(missing_cols, collapse = ", "))
  }

  # 2. 准备结果数据框
  results <- data.frame(
    KEGG_ID = character(nrow(data)),
    KEGG_Name = character(nrow(data)),
    Similarity = numeric(nrow(data)),
    Status = character(nrow(data)),
    stringsAsFactors = FALSE
  )

  # 3. 处理每个化合物
  for (i in seq_len(nrow(data))) {
    name <- data$Standardized_Name[i]
    formula <- data$Formula[i]

    # 3.1 使用keggidsearching函数搜索KEGG ID
    result <- keggidsearching(name, formula, similarity_threshold)

    # 3.2 存储结果
    results[i, ] <- list(
      result$KEGG_ID,
      result$KEGG_Name,
      result$Similarity,
      result$Status
    )

    # 3.3 显示进度
    message(sprintf("Processed %d/%d: %s - Status: %s",
                    i, nrow(data), name, result$Status))

    # 3.4 添加API调用延迟
    Sys.sleep(delay)
  }

  # 4. 合并结果并返回
  cbind(data, results)
}

