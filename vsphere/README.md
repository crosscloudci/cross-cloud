# VMware vSphere
This directory contains the assets that enable Cross-Cloud integration
with VMware vSphere.

## Prerequisites
This section highlights the requirements necessary to integrate Cross-Cloud
testing with VMware vSphere:

**Required**
* [Docker](#docker)
* [vSphere](#vsphere)

**Optional**
* [VMware Cloud (VMC) on AWS](#vmc)

### Docker
Docker is required to provision the test environment. The environment
is provisioned using the container image defined in this project's
top-level directory:

```shell
$ docker build . --tag provisioning
```

### vSphere
A vSphere server capable of hosting four VMs with 64GB RAM and 16-cores
each is required. The service account must have the following permissions:

// TODO vSphere Permissions

### VMC
If a local vSphere environment is not available, this provider is also
compatible with VMC on AWS. Please fill out [this form](https://cloud.vmware.com/vmc-aws/contact-sales) to begin the VMC account 
creation process.

#### AWS
An AWS [account](https://goo.gl/55j7Px) is required for VMC to utilize services 
such as an Elastic Load Balancer (ELB). 

While it is possible to use an existing AWS account with VMC, a new, distinct
account is recommended. This is because a VMC software defined data center
(SDDC) can only be linked with a single AWS account. In the [future](https://aws.amazon.com/vmware/faqs/) VMC will support linking multiple 
SDDCs with a single AWS account.

The account also requires several, [documented](https://goo.gl/RMmMsi) 
permissions.

#### SDDC
With an AWS and VMC account in hand it is time to create a VMC SDDC.
Please follow the [instructions](https://goo.gl/vMGpxc) for creating
a new SDDC and linking it to an AWS account.

## Getting Stared
Running the Cross-Cloud tests with vSphere is separated into three phases:

* [Configure](#configure)
* [Deploy](#deploy)
* [Destroy](#destroy)

### Configure
The following environment variables are used to configure Cross-Cloud
integration with vSphere:

| Name | Description |
|------|-------------|
| `VSPHERE_SERVER` | The IP/FQDN of the vSphere server |
| `VSPHERE_USER` | A vSphere username used to deploy/destroy the test environment |
| `VSPHERE_PASSWORD` | The password for `VSPHERE_USER` |

Defining the following environment variables indicates to the provider that
vSphere is running on VMC on AWS:

| Name | Description |
|------|-------------|
| `AWS_ACCESS_KEY ` | An AWS account used to deploy/destroy an ELB |
| `AWS_SECRET_ACCESS_KEY ` | The access key for `AWS_ACCESS_KEY` |

### Deploy
The following command can be used to provision a Cross-Cloud environment
to vSphere:

#### Deploy to vSphere
```shell
docker run \
  -v $(pwd)/data:/cncf/data \
  -e VSPHERE_SERVER=$VSPHERE_SERVER \
  -e VSPHERE_USER=$VSPHERE_USER \
  -e VSPHERE_PASSWORD=$VSPHERE_PASSWORD \
  -e CLOUD=vsphere \
  -e COMMAND=deploy \
  -e NAME=cross-cloud \
  -e BACKEND=file \
  -ti provisioning
```

#### Deploy to VMC on AWS
```shell
docker run \
  -v $(pwd)/data:/cncf/data \
  -e VSPHERE_SERVER=$VSPHERE_SERVER \
  -e VSPHERE_USER=$VSPHERE_USER \
  -e VSPHERE_PASSWORD=$VSPHERE_PASSWORD \
  -e AWS_ACCESS_KEY=$AWS_ACCESS_KEY \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e CLOUD=vsphere \
  -e COMMAND=deploy \
  -e NAME=cross-cloud \
  -e BACKEND=file \
  -ti provisioning
```

### Destroy
The following command can be used to deprovision a Cross-Cloud 
environment deployed to VMC on AWS:

#### Destroy on vSphere
```shell
docker run \
  -v $(pwd)/data:/cncf/data \
  -e VSPHERE_SERVER=$VSPHERE_SERVER \
  -e VSPHERE_USER=$VSPHERE_USER \
  -e VSPHERE_PASSWORD=$VSPHERE_PASSWORD \
  -e CLOUD=vsphere \
  -e COMMAND=destroy \
  -e NAME=cross-cloud \
  -e BACKEND=file \
  -ti provisioning
```

#### Destroy on VMC on AWS
```shell
docker run \
  -v $(pwd)/data:/cncf/data \
  -e VSPHERE_SERVER=$VSPHERE_SERVER \
  -e VSPHERE_USER=$VSPHERE_USER \
  -e VSPHERE_PASSWORD=$VSPHERE_PASSWORD \
  -e AWS_ACCESS_KEY=$AWS_ACCESS_KEY \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e CLOUD=vsphere \
  -e COMMAND=destroy \
  -e NAME=cross-cloud \
  -e BACKEND=file \
  -ti provisioning
```