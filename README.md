# Wordpress Enablement

![CI Status](https://github.com/tomvaughan77/wordpress-enablement/actions/workflows/terraform-ci.yml/badge.svg?branch=main)

## What is this?

The **wordpress-enablement** project is a side-project to help my partner rapidly deploy websites she's built using `wordpress` and exported to static files. This repository consists of the AWS infrastructure for this.

## Credits

Created with love by:
* `Tom Vaughan` - [Github](https://github.com/tomvaughan77) - [LinkedIn](https://www.linkedin.com/in/tom-vaughan-dev/)
* `Sam Fallowfield` - [Github](https://github.com/samfallowfield) - [LinkedIn](https://www.linkedin.com/in/sam-fallowfield-517286211/)

## Architecture

![high level architecture diagram](assets/wordpress_enablement_architecture.drawio.png)

## Dev Setup

### Linux (ubuntu, also works on wsl2)

#### 1. Python and Terraform

Ensure you have the `python` version in `.python-version` and the `terraform` version in `.terraform-version` installed. If you want to set these up, I'd recommend installing `pyenv` for python and `tfenv` for terraform. You can do this with your package manager of choice (I've used [linuxbrew](https://brew.sh/) here).
```bash
    brew update && brew install pyenv tfenv
    pyenv install && python --version
    tfenv install && terraform --version
```

#### 2. Install packages

Install all required packages using `apt` and `linuxbrew`. Again, most of these packages can be installed from your prefered package manager.
```bash
    sudo apt update && sudo apt install git git-lfs pipx awscli jq pass gnupg
    git lfs install
    pipx ensurepath
    pipx install checkov
    brew update && brew install aws-vault go-task tflint trivy
```

#### 3. Set up GPG keys

Set up or link an existing `gpg` key. You'll need this in order to push commits to the project and to help with your `aws-vault` backend if you're on linux. Follow the tutorial written by [Github](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key).

**Gottchas**:
* Don't forget to set `git` to use your gpg key to sign commits at the end!
* Make sure you select `4096` when gpg asks you how long you want your key to be - otherwise Github will reject it!

#### 4. Set up aws-vault backend using gpg

Set up aws-vault backend. I'm using `pass` so the instructions will be specific to that. Pass needs a gpg key added to it when we set it up so it can use that key to encrypt your aws credentials.
```bash
    # List the PUBLIC keys in your gpg keyring
    gpg --list-keys

    # ** See the below image to see which bit is your public key **

    # Add your public key to pass (change this value to correspond with that you see)
    pass init "844E426A53A64C2A916CBD1F522014D5FDBF6E3D"

    # Add the following to your ~/.bashrc file (~/.zshrc file or other if relevant)
    export AWS_VAULT_BACKEND=pass
    export GPG_TTY="$( tty )"
```

![example gpg key with arrow to public key value](assets/gpg_public_key_example.png)

#### 5. Set up aws-vault

Set up your AWS credentials using `aws-vault` and the aws cli.
```bash
    # Change the profile name to whatever you like - here I'm using 'tom'
    aws-vault add tom
    # ... follow the prompts, paste in your access_key and secret_key

    # Set your default region (change your profile name)
    printf "[profile tom]\nregion = eu-west-2\n" > ~/.aws/config

    # Test it works - you should see the buckets currently in s3
    aws-vault exec tom -- aws s3 ls
```

#### 6. Create a .env file

Create a `.env` file to tell our scripts the name of your aws-vault profile.
```bash
    # Remember to change your profile name
    printf "AWS_VAULT_PROFILE=tom\n" > .env
```

#### 7. Initialise Terraform

Set up remote terraform backend and you're done! You can now run the commands in `Taskfile.yml` to help you develop with.
```bash
    task init



    # Example further commands - you don't need to run these now
    # Plan out and analyse infrastructure change
    task plan

    # Deploy infrastructure changes
    task apply

    # Tear down all infrastructure
    task destroy
```

### Windows (git bash)

#### 1. Chocolatey, Python, and Terraform 

Ensure you have the [Python](https://www.python.org/downloads/) version in `.python-version` and the [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform#Windows) version in `.terraform-version` installed. Also install [Chocolatey](https://chocolatey.org/install) if you don't have it. Ensure your chocolately bin file is in your bash path - this tends to be `/c/ProgramData/Chocolatey/bin` or something very similar.

You can install both `Python` and `Terraform` using choco as follows
```bash
    choco install terraform --version=1.7.2 # Change depending on contents of .terraform-version file
    choco install python --version=3.12.2 # Change depending on contents of .python-version file
```

You will also need to add your Python scripts path to your `local` Windows environment variables.
* Type `Edit the system environment variables` into control panel
* Select `Environment Variables` under the `Advanced` tab.
* Click on `Path` under the `User variables` (not the system variables) section, then click `Edit`.
* Add the Python scripts path as a new variable. This will depend on your version of Python, but mine was `C:\Users\tomv\AppData\Roaming\Python\Python312\Scripts`.

#### 2. Install packages

Install all required packages using `choco` and manually if not possible. `choco` commands might need to be run in an admin version of powershell.
```bash
    choco install awscli aws-vault jq gnupg go-task tflint trivy
    pip install --user checkov
    git lfs install
```

#### 3. Set up GPG keys

Set up or link an existing `gpg` key. You'll need this in order to push commits to the project and to help with your `aws-vault` backend if you're on linux. Follow the tutorial written by [Github](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key).

**Gottchas**:
* Don't forget to set `git` to use your gpg key to sign commits at the end!
* Make sure you select `4096` when gpg asks you how long you want your key to be - otherwise Github will reject it!

#### 4. Create .env file

Create a `.env` file to tell our scripts the name of your aws-vault profile and that we're running on windows.
```bash
    # Remember to change your profile name
    printf "AWS_VAULT_PROFILE=tom\nWINDOWS_PROFILE=true\n" > .env
```

#### 5. Set up aws-vault

Set up your AWS credentials using `aws-vault` and the aws cli. Make sure your profile name (`tom` in my case) matches what's in your `.env` file!
```bash
    # Change the profile name to whatever you like - here I'm using 'tom'
    aws-vault add tom
    # ... follow the prompts, paste in your access_key and secret_key

    # Set your default region (change your profile name)
    printf "[profile tom]\nregion = eu-west-2\n" > ~/.aws/config

    # Test it works - you should see the buckets currently in s3
    aws-vault exec tom -- aws s3 ls
```

#### 6. Initialise Terraform

Set up remote terraform backend and you're done! You can now run the commands in `Taskfile.yml` to help you develop with.
```bash
    task init



    # Example further commands - you don't need to run these now
    # Plan out and analyse infrastructure change
    task plan

    # Deploy infrastructure changes
    task apply

    # Tear down all infrastructure
    task destroy
```

### Plugins

If you're using `vscode` to develop on, I'd recommend the following plugins to make your life a bit easier:

* taskfile
* yaml
* terraform (official)
* github actions
* trivy
