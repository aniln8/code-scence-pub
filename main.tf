terraform {
 backend "remote" {
   organization = "antest-wp"

   workspaces {
     name = "code-scence-pub"
   }
 }
}

resource "null_resource" "terraform-github-actions" {
 triggers = {
   value = "This resource was created using GitHub Actions!"
 }
}
