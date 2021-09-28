## terraform-gcp-ansible-sentry-ubuntu

## Requirements:

git\
Terraform v 1.0.0 or newer\
Vagrant (for testing locally)\
Ansible (install instapp python3 & python3-pip then run "python3 -m pip install --user ansible"\
GCP cloud account with permissions to create a project

## Prereqs for ansible:
Run   
```
ssh-keygen -t rsa -f ~/.ssh/ubuntu -C `whoami`   
chmod 400 ~/.ssh/ubuntu
```

## Git clone the project, or extract the zip to your ~ directory 

* git clone the project from the repository: 
     * git clone https://github.com/binbashblog/terraform-gcp-ansible-sentry-ubuntu.git or extract the zip file
	 
## Create the GCP project and obtain the JSON file for credentials

* Go to the GCP Console, create a new project with an owner role then select the project at the top.
    * Go to APIs & Services section in the project > click on Credentials > Select Service account key from Create Credentials dropdown menu and fill in the project name.
    * Click create and select JSON.
    * Rename the JSON file to terraform.json and copy it to the directory of the git repository/extracted zip file

## GCS backend bucket for the tf state file

* In GCP go to Cloud Storage to create a new bucket to store the terraform state file.
    * Click Create bucket, specify a name for the bucket, e.g. terraform-gcp-ansible-sentry-ubuntu_tfstate. Choose Region > europe-west2 (London).
    * Choose Standard storage class.
    * Under public access, ensure "Enforce public access prevention on this bucket" is enabled
    * Choose Uniform Access control
    * Choose Object versioning under Protection tools
    * Wait for the bucket to be ready.
	
* Modify the backend.tf file if required
    * When terraform init is run, the tfstate will be created in the bucket instead of locally

## Prepare the tf environment
* Rename terraform.tfvars.example to terraform.tfvars
    *Update the project id from the project you created in GCP with the project_id variable in terraform.tfvars
    * Amend the other values for your environment if they differ.

## Running terraform
* Run ```terraform init``` to initialize the terraform environment and download modules
    * At this point any errors or warnings in the config will appear, if no warnings then continue to below:

* Run ```terraform plan``` to verify the changes being made and that no errors appear

* Run ```terraform apply``` and wait for it to complete, shortly after ansible will be run.
The IP of the instance will appear.

## To access Sentry via the hostname
* Edit your hosts file as follows:   
```   
<Public IP of the instance>		sentry-vm.example.org
```   

Now open your browser and enter https://sentry-vm.example.org

* The web page will appear, due to the non interactive mode of the Sentry installation, you will need to ssh to the instance using your key pair and external ip and create a new user

## Create a superuser for Sentry
* ssh to the instance using the public ip or the hostname (if the hosts file was set as above)    
```ssh ubuntu@sentry-vm.example.org -i ~/.ssh/ubuntu```

* Run the following to create a new user:

```
cd ~/sentry_install/
docker-compose run --rm web createuser
```   

* You will be prompted for your email address, and prompted to enter a password twice. 
* Then press y to make the user a superuser.
* You can then log into sentry and complete the setup
