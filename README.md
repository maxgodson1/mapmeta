# mapmeta - KEGG Metabolite ID Mapping Package

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

mapmeta 是一个用于将代谢物名称和分子式映射到KEGG ID的R包，提供高效的批量映射和结果验证功能。

## 核心功能

- 标准化代谢物名称和分子式
- 基于名称相似度的KEGG ID匹配
- 批量处理大规模代谢物数据集
- 匹配结果自动验证与分类

## 主要函数

- `standardize_name()`: 标准化代谢物名称（KEGG专用）
- `standardize_formula()`: 标准化分子式格式
- `calculate_name_similarity()`: 计算名称相似度得分
- `keggidsearching()`: 单个代谢物KEGG ID匹配
- `keggidbatchsearching()`: 批量代谢物KEGG ID匹配

## 安装

```r
# 从GitHub安装开发版
if (!require("devtools")) install.packages("devtools")
devtools::install_github("maxgodson1/mapmeta")
```

## 使用教程

```r
vignette("tutorial", package = "mapmeta")
```

## 完整工作流示例

```r
library(mapmeta)

# 1. 创建示例数据集
data <- data.frame(
  Raw_Name = c("Glucose", "Testosterone", "Caffeine"),
  Raw_Formula = c("C6H12O6", "C19H28O2", "C8H10N4O2")
)

# 2. 数据标准化
data$Name <- standardize_name(data$Raw_Name)
data$Formula <- standardize_formula(data$Raw_Formula)

# 3. 匹配KEGG ID
# 单个匹配
glucose_match <- keggidsearching(
  name = "Glucose",
  formula = "C6H12O6",
  similarity_threshold = 0.8
)
# 批量匹配
mapped_data <- keggidbatchsearching(data, similarity_threshold = 0.8)

# 4. 筛选自动接受的匹配
auto_accepted <- subset(mapped_data, Status == "Auto-accepted")

# 5. 保存结果
write.csv(mapped_data, "kegg_mapping_results.csv", row.names = FALSE)
```

## 许可证
GPL-3
