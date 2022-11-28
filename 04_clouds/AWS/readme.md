## Static S3 site

The site is located at https://aws.dimalysenko.pp.ua and contains list of tutorials and labs that I've completed.

![](./images/s3.png)

## EC2 instances and EBS

Create EC2 instance:

![](./images/1.png)

Note: while creating the instance, I configured security group to allow SSH from my IP address.

Connect to the EC2 instance:

![](./images/2.png)

Snapshot of the root EBS volume of the EC2 instance:

![](./images/3.png)

Attached second EBS volume to the EC2 instance:

![](./images/4.png)

Create file system on the second volume, mount it, create some file and unmount:

![](./images/5.png)

Terminate the instance:

![](./images/6.png)

Go back to the snapshot and create AMI image from it:

![](./images/7.png)

Launch new instance from the created AMI:

![](./images/8.png)
![](./images/9.png)
![](./images/10.png)

Attach second volume from previous instance:

![](./images/11.png)

Connect to the new instance, mount the second volume and check files that were created before:

![](./images/12.png)

Terminate all EC2 instances:

![](./images/13.png)

Note: I've also removed other used resources to avoid billing (AMI image, EBS volume, EBS snapshot).
