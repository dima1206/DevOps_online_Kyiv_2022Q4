- [Lecture 1](#lecture-1)
  * [Intro](#intro)
- [Lecture 2](#lecture-2)
  * [Implicit dependencies](#implicit-dependencies)
  * [Explicit dependencies](#explicit-dependencies)
  * [Variables and outputs](#variables-and-outputs)
    + [Variables](#variables)
    + [Outputs](#outputs)
    + [Outputs extra task](#outputs-extra-task)
  * [Modules](#modules)
    + [Modules main task](#modules-main-task)
    + [Modules extra](#modules-extra)

## Lecture 1

### Intro

Install Terraform ([script](./install_terraform.sh)):

![](./images/01/01.png)

Confirm installation:

![](./images/01/02.png)

Configure AWS profile using AWS CLI:

![](./images/01/03.png)

A [simple example](./01_intro/TF_intro_01.tf) with two EC2 instances:

![](./images/01/04.png)

`terraform init`:

![](./images/01/05.png)

`terraform plan`:

![](./images/01/06.png)

`terraform apply`:

![](./images/01/07.png)

The `terraform.tfstate` file is stored locally in the same folder:

![](./images/01/08.png)

`terraform destroy`:

![](./images/01/09.png)

## Lecture 2

### Implicit dependencies

[main.tf](./02_implicit_dep/main.tf):

![](./images/02/01.png)

Resource `ip` implicitly depends on resource `example_a` because the instance id will be known only after the instance is created.

`terraform apply` and created resources in the AWS console:

![](./images/02/02.png)

![](./images/02/03.png)

Elastic IP started creating only after `example_a` instance was created.

`terraform destroy`:

![](./images/02/04.png)

`example_a` instance started destroying only after the elastic IP was destroyed.

### Explicit dependencies

[main.tf](./03_explicit_dep/main.tf):

![](./images/03/01.png)

`depends_on` explicitly tells Terraform to create the resource only after the specified resources were created. In this case `example_c` depends on `example`, and `example_sqs_queue` depends on both `example` and `example_c`. It means that those 3 resources will be created/destroyed only sequentially.

`terraform init` to make sure that needed plugins and modules are installed:

![](./images/03/02.png)

`terraform apply`:

![](./images/03/03.png)

All 3 resources were created sequentially and not in parallel.

`terraform destroy`:

![](./images/03/04.png)

All 3 resource were also destroyed sequentially and not in parallel.

### Variables and outputs

Files for this task are located in the [04_vars_output](./04_vars_output) directory.

#### Variables

[main.tf](./04_vars_output/main.tf) references `instance_name` variable:

![](./images/04/vars/01.png)

[variables.tf](./04_vars_output/variables.tf) is describing the variable with default value of `ExampleInstance`:

![](./images/04/vars/02.png)

`terraform apply` tells that an EC2 instance will be created with the name `ExampleInstance`:

![](./images/04/vars/03.png)

`terraform apply` actually created the instance:

![](./images/04/vars/04.png)

`terraform apply -var 'instance_name=YetAnotherName'` shows that tags will be edited for the instance changing its name to `YetAnotherName`

![](./images/04/vars/05.png)

Actually applied changes:

![](./images/04/vars/06.png)

#### Outputs

[outputs.tf](./04_vars_output/outputs.tf) describes outputs:

![](./images/04/outputs/07.png)

`terraform apply` shows that there are changes to outputs. After applying, it shows the outputs:

![](./images/04/outputs/09.png)

Can also get outputs with `terraform output`:

![](./images/04/outputs/10.png)

Destroy recources to avoid billing:

![](./images/04/outputs/11.png)

#### Outputs extra task

Extra task was to see what happens to outputs when you manually change resources in the AWS console.

`terraform apply` to create the resources again:

![](./images/04/extra/01.png)

`terraform output` shows the outputs:

![](./images/04/extra/02.png)

Stop the instance manually:

![](./images/04/extra/04.png)

Try `terraform output` again and see that public IP is still shown even though it was removed when the instance was stopped:

![](./images/04/extra/05.png)

Check the `terraform.tfstate` file and see that the output values are still stored in there:

![](./images/04/extra/06.png)

`terraform plan` detected external changes to the public IP and tells that applying now would remove the public IP from the current state:

![](./images/04/extra/07.png)

Since the instance was only stopped and still exists, it matches the described infrastructure, so `terraform plan` didn't show restarting or recreating the instance.

Actually applying with show empty string for the public IP:

![](./images/04/extra/08.png)

Manually terminate/destroy the instance:

![](./images/04/extra/09.png)

Now `now terraform plan` shows that the instance was deleted outside of the Terraform and it will recreate the instance:

![](./images/04/extra/10.png)

### Modules

#### Modules main task

The task was to just try out the [existing code](https://github.com/hashicorp/learn-terraform-modules/blob/tags/ec2-instances) that uses existing modules.

Cloning the code with `git clone --depth 1 --branch tags/ec2-instances https://github.com/hashicorp/learn-terraform-modules.git`:

![](./images/05/main/01.png)

List of cloned files:

![](./images/05/main/02.png)

[main.tf](https://github.com/hashicorp/learn-terraform-modules/blob/tags/ec2-instances/main.tf) file:

![](./images/05/main/03.png)

I edited the file to use the profile that I configured on the system:

![](./images/05/main/04.png)

`terraform plan` shows that 22 resources will be created with just few lines of code that use 2 modules:

![](./images/05/main/05.png)

Those resources include:
- 2 EC2 instances
- 2 elastic IPs (1 for each NAT gateway)
- 1 Internet gateway
- 2 NAT gateways
- 3 routes (1 for each gateway)
- 3 route tables (1 public and 2 private)
- 4 route table associations (1 for each subnet)
- 4 subnets (2 public and 2 private)
- 1 VPC

#### Modules extra

To get better understanding of modules in Terraform, I also went trough [this guide](https://developer.hashicorp.com/terraform/tutorials/modules/module-create) that explains local modules.

Cloning the example code:

![](./images/05/extra/02.png)

List of files:

![](./images/05/extra/03.png)

`main.tf` in the module describes 4 resources - 1 S3 bucket and 3 related resources to the bucket (ACL, policy and website configuration):

![](./images/05/extra/06.png)

`variables.tf` in the module describe parameters for the module:

![](./images/05/extra/07.png)

`output.tf` describes values that can be accessed from outside of the module:

![](./images/05/extra/08.png)

I edited root files a little bit.

In `main.tf` I removed other modules, specified AWS CLI profile and a different bucket name:

![](./images/05/extra/11.png)

Note: When using module, `bucket_name` and `tags` are specified. Those are the variables that were specified in the module.

I also removed corresponding outputs in the `output.tf` file:

![](./images/05/extra/12.png)

Note: Root file references the outputs from the module that were described earlier.

I also removed `variables.tf` since it didn't contain anything related to the S3 bucket:

![](./images/05/extra/13.png)

`terraform init` initializes modules along with other things:

![](./images/05/extra/13.5.png)

`terraform plan`:

![](./images/05/extra/14.png)

`terraform apply`:

![](./images/05/extra/15.png)

Uploading files to the bucket:

![](./images/05/extra/17.png)

Content of the `index.html`:

![](./images/05/extra/18.png)

Opening the bucket in a browser:

![](./images/05/extra/20.png)

Note: SSL certificate is invalid because the bucket has dots in its name and it makes multi-level subdomain that the certificate doesn't cover.

I tried to destroy the bucket with objects in it to see how Terraform will behave in this case. It destroyed 3 other resources, but not the bucket itself:

![](./images/05/extra/21.png)

Empty the bucket:

![](./images/05/extra/22.png)

`terraform destroy` after emptying the bucket:

![](./images/05/extra/23.png)
