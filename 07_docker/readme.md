- [Lecture 1](#lecture-1)
  * [Intro with Ubuntu container](#intro-with-ubuntu-container)
  * [Intro with CentOS container](#intro-with-centos-container)
  * [Pruning](#pruning)
- [Lecture 2](#lecture-2)
  * [Flask app](#flask-app)
  * [Dockerhub](#dockerhub)
  * [Frequently used Docker commands](#frequently-used-docker-commands)
    + [Existing images and containers](#existing-images-and-containers)
    + [Searching and pulling images, running containers](#searching-and-pulling-images--running-containers)
- [Lecture 3](#lecture-3)
  * [Docker Compose](#docker-compose)

## Lecture 1

### Intro with Ubuntu container

[Script](./userdata-docker-ubuntu.sh) to install Docker on Ubuntu:

![](./images/l1/01/01.png)

I've also made a similar script for Amazon Linux: [userdata-docker-amazon-linux.sh](./userdata-docker-amazon-linux.sh)

Make sure that Docker is installed:

![](./images/l1/01/02.png)

Run a simple container to see that Docker works fine:

![](./images/l1/01/03.png)

[Dockerfile](./01_intro_ubuntu/Dockerfile) with few changes:

![](./images/l1/01/04.png)

What was changed in the Dockerfile: using latest Ubuntu version (`22.10` instead of `20.04`), using the new name for the timezone (`Europe/Kyiv` instead of `Europe/Kiev`), added `tzdata` package to actually change the timezone.

Build the image:

![](./images/l1/01/05.png)

![](./images/l1/01/06.png)

Move `Dockerfile` to a subdirectory `dockerfiles` and build again using cache:

![](./images/l1/01/07.png)

List of images saved locally:

![](./images/l1/01/08.png)

Running a container from the image, listing all containers in the system, making sure that the port is open:

![](./images/l1/01/09.png)

Checking apache server in the container using browser and public IP:

![](./images/l1/01/10.png)

Command from the lecture that didn't work:

![](./images/l1/01/11.png)

The lecturer said that the error appeared because there is no container with such name. In fact, the command references an image and tries to create a new container. The error is caused by wrong parameter at the end. It expects a command to run, but `.` isn't a valid command.

Example of the right command:

![](./images/l1/01/16.png)

On the screenshot you can see that time is different for container and host.

Stopping the container:

![](./images/l1/01/17.png)

### Intro with CentOS container

[Dockerfile](./02_intro_centos/Dockerfile):

![](./images/l1/02/01.png)

Building an image:

![](./images/l1/02/02.png)

![](./images/l1/02/03.png)

Running container based on the image:

![](./images/l1/02/04.png)

Making sure the web server works using public IP and browser:

![](./images/l1/02/05.png)

The container in the list of running containers:

![](./images/l1/02/06.png)

### Pruning

Pruning most of the docker data:

![](./images/l1/02/07.png)

Docker warns about what data will be removed:

![](./images/l1/02/08.png)

By default it removes stopped containers, unused networks, dangling images ([untagged images](https://docs.docker.com/engine/reference/commandline/images/#show-untagged-images-dangling)) and dangling build cache.

With the `-a` option it also removes tagged images that don't have associated containers and all build cache.

## Lecture 2

### Flask app

The project files are located [here](./03_flask/flask-app). Most changes are fixes and upgrades.

`index.html` (added missing `img` tag, added CSS style for `img` to properly display images):

![](./images/l2/03/flask/08.png)

`app.py` (no important changes):

![](./images/l2/03/flask/09.png)

`Dockerfile` (newer versions of Alpine Linux, Python and pip):

![](./images/l2/03/flask/10.png)

`requirements.txt` (newer version of Flask):

![](./images/l2/03/flask/11.png)

Uploading the project to EC2 instance with installed Docker:

![](./images/l2/03/flask/02.png)

Building the image:

![](./images/l2/03/flask/03.png)

![](./images/l2/03/flask/04.png)

Running container:

![](./images/l2/03/flask/05.png)

Checking it via public IP:

![](./images/l2/03/flask/06.png)

Logs are printed to the terminal:

![](./images/l2/03/flask/07.png)

### Dockerhub

Created access token:

![](./images/l2/03/dockerhub/01.png)

Logged in:

![](./images/l2/03/dockerhub/02.png)

Add a name that references repository and push the image:

![](./images/l2/03/dockerhub/03.png)

The image on Dockerhub:

![](./images/l2/03/dockerhub/04.png)

### Frequently used Docker commands

#### Existing images and containers

List running containers and all containers:

![](./images/l2/04/common/01.png)

Stop all containers:

![](./images/l2/04/common/02.png)

Remove container:

![](./images/l2/04/common/03.png)

Remove all images that aren't used by any container:

![](./images/l2/04/common/04.png)

Remove all images even if they're used by a container:

![](./images/l2/04/common/06.png)

#### Searching and pulling images, running containers

Searching for tomcat images:

![](./images/l2/04/web/01.png)

Pulling tomcat images:

![](./images/l2/04/web/02.png)

Searching nginx images:

![](./images/l2/04/web/03.png)

Pulling nginx image:

![](./images/l2/04/web/04.png)

Running tomcat container with attached terminal that is connected to my stdin:

![](./images/l2/04/web/05.png)

Exit with Ctrl+C (stops container):

![](./images/l2/04/web/06.png)

Running nginx container in the same way:

![](./images/l2/04/web/07.png)

Exiting with Ctrl+C:

![](./images/l2/04/web/08.png)

Running nginx server in detached mode (my terminal is not connected to the container terminal), the container keeps running:

![](./images/l2/04/web/09.png)

## Lecture 3

### Docker Compose

[docker-compose.yml](./05_compose/my_wordpress/docker-compose.yml):

![](./images/l3/05/05.png)

Start containers and do other things that are required (pulling, building): 

![](./images/l3/05/01.png)

![](./images/l3/05/02.png)

Running the command again only outputs that containers are already running:

![](./images/l3/05/04.png)

List of running containers using `docker ps`:

![](./images/l3/05/06.png)

List of running containers using `docker compose ps`:

![](./images/l3/05/08.png)

Setting up the WordPress site:

![](./images/l3/05/07.png)

After creating an admin account, I successfully logged in, so database is working:

![](./images/l3/05/09.png)

Inspect the volume that was created with Docker Compose:

![](./images/l3/05/10.png)

Create, inspect and remove a volume without Docker Compose:

![](./images/l3/05/11.png)
