#checkov:skip=CKV_AWS_274: The role needs admin access to deploy/destroy anything
module "oidc_github" {
  source = "git::https://github.com/unfunco/terraform-aws-oidc-github.git?ref=6aed749fc1cdbff25a0052eec5ae9a2d584507e9" # v1.7.1

  github_repositories = [
    "tomvaughan77/wordpress-enablement",
  ]
  iam_role_name       = "GithubActionsTerraformDeployRole"
  attach_admin_policy = true
}