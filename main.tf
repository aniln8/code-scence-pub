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

name: Terraform Apply
on: [push]
jobs:
  terraform_apply:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Install Terraform
      env:
            TERRAFORM_VERSION: "0.12.15"
      run: |
        tf_version=$TERRAFORM_VERSION
        wget https://releases.hashicorp.com/terraform/"$tf_version"/terraform_"$tf_version"_linux_amd64.zip
        unzip terraform_"$tf_version"_linux_amd64.zip
        sudo mv terraform /usr/local/bin/

    - name: Verify Terraform version
      run: terraform --version

    - name: Terraform init
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      run: terraform init -input=false

    - name: Terraform validation
      run: terraform validate

    - name: Terraform apply
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      run: terraform apply -auto-approve -input=false
