## Terraform

At first, the infrastructure was created through the **AWS Management Console.** However, this was not the ideal way to do it, as ***it couldn't be instantly replicated, easily destroyed, effectively managed or version controlled.*** Therefore, I decided that I'd use **[Terrafrom](https://www.terraform.io/) as my Infrastructure as Code (IaC) tool.**

I tried to follow all the stablished conventions and good practices that are explained in the documentation while migrating my infrastructure to IaC. I made use of variables and outputs to keep everything organized and easy to refactor/scale in the future. Furthermore, I kept all credentials away from the files that were going to be stored on the public Github repository.

Additionally, I set up another **Github Actions workflow to implement CI/CD, but this time with my back-end.** This workflows runs only when changes are pushed to the master branch and the files affected belong to the back-end directory (/back-end/\*\*).

In Terraform there are two types of files:

 - The *plan* file contains a description of a set of changes that will be made when the plan file is passed in to `terraform apply`.

 - A  *state* file contains a snapshot of the current state of all of the extant resources as of the last time Terraform "refreshed" them. **Terraform always needs this file in order to perform the correct operations.**
 
Consequently, I modified the first version of this workflow to save the `terraform.tfstate` to an S3 bucket so that it could be retrieved later. **Then, for development purposes, I created a new Github Actions workflow (that coud be manually triggered) for destroying the whole infrastructure**. This workflow needs the `terraform.tfstate` so that `terraform apply -destroy` is aware of the current infrastructure and knows what it should destroy.

>**NOTE: Github Actions Secrets are used to safely store and use credentials**

## Resources

 - [Learn Terraform](https://learn.hashicorp.com/collections/terraform/aws-get-started)
 - [Terraform best practices](https://www.terraform-best-practices.com/naming)
 - [Terraform API Gateway tutorial](https://hands-on.cloud/managing-amazon-api-gateway-using-terraform/#h-api-gateway-lambda-integration-using-terraform)