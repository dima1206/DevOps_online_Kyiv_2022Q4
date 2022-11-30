- [EC2 instances](#ec2-instances)
- [Lecture 1](#lecture-1)
  * [Install Jenkins](#install-jenkins)
  * [Configure Jenkins](#configure-jenkins)
  * [Create a simple job (+ green balls plugin)](#create-a-simple-job--green-balls-plugin)
- [Lecture 2](#lecture-2)
  * [Jenkins data in file system](#jenkins-data-in-file-system)
  * [Deploy job (freestyle project)](#deploy-job-freestyle-project)
    + [Initial job setup](#initial-job-setup)
    + [Use scp to transfer artifact](#use-scp-to-transfer-artifact)
    + [Publish Over SSH plugin](#publish-over-ssh-plugin)
    + [Pull HTML page from GitHub](#pull-html-page-from-github)
    + [Poll SCM](#poll-scm)
    + [GitHub webhook](#github-webhook)
- [Lecture 3](#lecture-3)
  * [Jenkins agents](#jenkins-agents)
    + [Simple agent](#simple-agent)
    + [Deploy directly on agent](#deploy-directly-on-agent)
  * [Jenkins CLI](#jenkins-cli)
  * [Pipeline](#pipeline)
    + [Initial pipeline setup](#initial-pipeline-setup)
    + [Pipeline script from GitHub](#pipeline-script-from-github)
    + [Maven](#maven)

## EC2 instances

| Name | Public IP | Private IP | Description |
| --- | --- | --- | --- |
| jenkins-controller-hw | 3.72.106.235 | 172.31.36.64 | Jenkins controller 2.379 |
| jenkins-node0 | 54.93.251.219 | 172.31.32.44 | An agent for Jenkins |
| dev-web-server | 52.59.56.225 | 172.31.38.18 | EC2 instance for deploy |

## Lecture 1

### Install Jenkins

I already have a template on AWS ...

![](./images/l1/1.1.png)

... with [user data](./userdata-controller.sh) that installs Jenkins:

![](./images/l1/1.2.png)

### Configure Jenkins

After the `jenkins-controller-hw` instance was launched from template and the user data script was finished, I opened Jenkins Web-interface via public IP and pasted initial admin password:

![](./images/l1/2.1.png)

I installed recommended plugins:

![](./images/l1/2.2.png)

Created first user:

![](./images/l1/2.3.png)

Kept default Jenkins URL with public IP (Note: I'll use private IP and `localhost` as well down below):

![](./images/l1/2.4.png)

Freshly installed Jenkins:

![](./images/l1/2.5.png)

Installing a plugin after Jenkins installation:

![](./images/l1/2.6.png)

### Create a simple job (+ green balls plugin)

Create a freestyle project:

![](./images/l1/3.1.png)

Add a build step that executes shell:

![](./images/l1/3.2.png)

Successful build:

![](./images/l1/3.3.png)

Edit shell script that will cause an error:

![](./images/l1/3.4.png)

Failed build:

![](./images/l1/3.5.png)

Installing the Green Balls plugin:

![](./images/l1/3.6.png)

Note: Jenkins recently changed icons and that broke the plugin. [Related issue](https://issues.jenkins.io/browse/JENKINS-66339).

Fix the error in the script:

![](./images/l1/3.7.png)

History of builds:

![](./images/l1/3.8.png)

## Lecture 2

### Jenkins data in file system

Directory with Jenkins data:

![](./images/l2/1.1.png)

Directory with builds for the `first-job` job:

![](./images/l2/1.2.png)

Configuring log rotation to discard old builds:

![](./images/l2/1.3.png)

Directory with builds for the `first-job` job after limiting number of builds to keep:

![](./images/l2/1.4.png)

### Deploy job (freestyle project)

#### Initial job setup

Create a job:

![](./images/l2/2.01.png)

Add a step to create an HTML page:

![](./images/l2/2.02.png)

Check that it works:

![](./images/l2/2.03.png)

#### Use scp to transfer artifact

Create SSH keys on `jenkins-controller-hw` that will be used for deploying, copy public key:

![](./images/l2/2.04.png)

Add the public key to authorized keys on `dev-web-server`:

![](./images/l2/2.05.png)

Change permissions on `dev-web-server` so `ec2-user` could write to the `/usr/share/nginx/html/` directory:

![](./images/l2/2.06.png)

Properly save generated keys on `jenkins-controller-hw` so `jenkins` user could use them:

![](./images/l2/2.07.png)

Add `scp` command to the script:

![](./images/l2/2.08.png)

Test that it works:

![](./images/l2/2.09.png)

#### Publish Over SSH plugin

Install the plugin:

![](./images/l2/2.10.png)

Generate another key for the plugin (Note: the plugin doesn't support the new SSH key format, [related issue](https://github.com/jenkinsci/publish-over-ssh-plugin/issues/89)):

![](./images/l2/2.12.png)

Properly save the keys and copy the public key:

![](./images/l2/2.13.png)

Add it to the authorized keys on `dev-web-server`:

![](./images/l2/2.14.png)

Configure the plugin to use the keys:

![](./images/l2/2.15.png)

Remove `scp` command from the script and change HTML content:

![](./images/l2/2.16.png)

Use 'Publish Over SSH' plugin in post-build actions:

![](./images/l2/2.17.png)

Check that it works:

![](./images/l2/2.18.png)

#### Pull HTML page from GitHub

Generate new keys to connect to GitHub:

![](./images/l2/2.19.png)

Properly store the keys:

![](./images/l2/2.20.png)

Copy the public key:

![](./images/l2/2.21.png)

Add the public key to GitHub:

![](./images/l2/2.22.png)

Add GitHub to the list of known hosts:

![](./images/l2/2.23.png)

Check that saved fingerprints are authentic using [official GitHub fingerprints list](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints):

![](./images/l2/2.24.png)

Create `index.html` file on GitHub:

![](./images/l2/2.25.png)

Start configuring SCM for the job:

![](./images/l2/2.26.png)

Copy private key for GitHub:

![](./images/l2/2.27.png)

Configure credentials for GitHub:

![](./images/l2/2.28.png)

Chose the credentials that were just configured:

![](./images/l2/2.30.png)

Remove creating HTML from the script:

![](./images/l2/2.31.png)

Leave post-build action as it was:

![](./images/l2/2.33.png)

Check if it works:

![](./images/l2/2.34.png)

#### Poll SCM

Enable 'Poll SCM' option and configure it to poll every other minute:

![](./images/l2/2.35.png)

Change content on GitHub:

![](./images/l2/2.36.png)

Check if it works:

![](./images/l2/2.37.png)

#### GitHub webhook

Disable Poll SCM and enable GitHub hook:

![](./images/l2/2.38.png)

Configure repository on GitHub to send notifications to the `jenkins-controller-hw`:

![](./images/l2/2.39.png)

Edit content on GitHub:

![](./images/l2/2.41.png)

Check if it works:

![](./images/l2/2.42.png)

## Lecture 3

### Jenkins agents

#### Simple agent

Install plugins to work with agents over SSH: 

![](./images/l3/1.01.png)

Add a new node:

![](./images/l3/1.02.png)

Create new SSH keys on `jenkins-controller-hw`:

![](./images/l3/1.03.png)

Properly store the keys:

![](./images/l3/1.04.png)

Copy the public key:

![](./images/l3/1.05.png)

On `jenkins-node0` create the `jenkins` user and save the public key to the list of authorized keys:

![](./images/l3/1.08.png)

On `jenkins-controller-hw` save fingerprints of `jenkins-node0` to the list of known hosts:

![](./images/l3/1.09.png)

Copy the private key:

![](./images/l3/1.07.png)

And add it to credentials in Jenkins:

![](./images/l3/1.10.png)

Disable executors on `jenkins-controller-hw`:

![](./images/l3/1.11.png)

List of executors now doesn't include the build-in node:

![](./images/l3/1.12.png)

Save fingerprint of GitHub on `jenkins-node0`:

![](./images/l3/1.14.png)

Create a new job:

![](./images/l3/1.15.png)

Use only nodes with the `linux` label:

![](./images/l3/1.16.png)

Check that it worked:

![](./images/l3/1.17.png)

#### Deploy directly on agent

Copy private SSH key for deploying that was created in the [Use scp to transfer artifact](#use-scp-to-transfer-artifact) section:

![](./images/l3/1.21.png)

Add it to Jenkins credentials:

![](./images/l3/1.22.png)

Use it while adding `dev-web-server` as an agent:

![](./images/l3/1.23.png)

List of executors that includes `dev-web-server`:

![](./images/l3/1.24.png)

Configure the job from the [Deploy job (freestyle project)](#deploy-job-freestyle-project) section to run only on agents with the `nginx` label:

![](./images/l3/1.25.png)

Edit the script to copy files from SCM to the `/usr/share/nginx/html/` directory:

![](./images/l3/1.26.png)

Edit the content on GitHub:

![](./images/l3/1.28.png)

Check that it works:

![](./images/l3/1.29.png)

### Jenkins CLI

Download `jenkins-cli.jar` from Jenkins controller:

![](./images/l3/2.01.png)

Check that it works:

![](./images/l3/2.02.png)

Generate API token to use instead of the password:

![](./images/l3/2.03.png)

Check that the token works:

![](./images/l3/2.04.png)

Export the token and username to the environment variables and omit the `-auth` option from the command:

![](./images/l3/2.05.png)

### Pipeline

#### Initial pipeline setup

Create a new pipeline:

![](./images/l3/3.01.png)

Create a simple pipeline script:

![](./images/l3/3.02.png)

Check that it works:

![](./images/l3/3.03.png)

#### Pipeline script from GitHub

Copy the script to GitHub:

![](./images/l3/3.04.png)

Configure the pipeline to pull the script from GitHub:

![](./images/l3/3.05.png)

![](./images/l3/3.06.png)

Check that it works:

![](./images/l3/3.08.png)

#### Maven

Install Maven on `jenkins-node0`:

![](./images/l3/3.24.png)

![](./images/l3/3.25.png)

Configure maven tool location on `jenkins-node0`:

![](./images/l3/3.27.png)

Add `mvn` label to the node:

![](./images/l3/3.11.png)

Generate a simple project with Maven:

![](./images/l3/3.13.png)

Add the project to GitHub:

![](./images/l3/3.14.png)

Create a new job:

![](./images/l3/3.15.png)

Configure the job to pull source code from GitHub:

![](./images/l3/3.16.png)

Configure the job to run Maven:

![](./images/l3/3.17.png)

Restrict the job to run only on nodes with Maven installed:

![](./images/l3/3.23.png)

Check that it works:

![](./images/l3/3.28.png)


