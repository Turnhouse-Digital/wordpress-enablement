#checkov:skip=CKV_AWS_274: The role needs admin access to deploy/destroy anything
module "oidc_github" {
  source = "git::https://github.com/unfunco/terraform-aws-oidc-github.git?ref=80358ac71bcbb49dd5807486682a2b1d81cdf15c" # v1.8.0

  github_repositories = [
    "Turnhouse-Digital/wordpress-enablement",
  ]
  iam_role_name       = "GithubActionsTerraformDeployRole"
  attach_admin_policy = true
}