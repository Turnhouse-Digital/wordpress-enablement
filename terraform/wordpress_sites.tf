data "external" "get_wordpress_sites" {
  program = ["python", "../python/get_wordpress_sites.py"]
}

output "html_files" {
  value = jsondecode(data.external.get_wordpress_sites.result)
}
