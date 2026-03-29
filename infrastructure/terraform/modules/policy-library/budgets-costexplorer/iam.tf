data "aws_iam_policy_document" "this" {
  # Budgets and Cost Explorer are account-level services with no resource-level ARN scoping.
  statement {
    sid    = "Budgets"
    effect = "Allow"
    actions = [
      "budgets:CreateBudget",
      "budgets:DeleteBudget",
      "budgets:ModifyBudget",
      "budgets:ViewBudget"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "CostExplorerAnomalies"
    effect = "Allow"
    actions = [
      "ce:CreateAnomalyMonitor",
      "ce:DeleteAnomalyMonitor",
      "ce:GetAnomalyMonitors",
      "ce:UpdateAnomalyMonitor",
      "ce:CreateAnomalySubscription",
      "ce:DeleteAnomalySubscription",
      "ce:GetAnomalySubscriptions",
      "ce:UpdateAnomalySubscription"
    ]
    resources = ["*"]
  }
}
