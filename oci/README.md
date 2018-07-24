# Oracle Cloud Infrastructure
This directory contains the assets that enable Cross-Cloud integration
with Oracle Cloud Infrastructure.

## Prerequisites

### Required
* Oracle Cloud Infrastructure Tenancy
    * User account in tenancy with api tokens set up
    * group to put user in
    * policy to apply to user group
* Docker

### Docker
Docker is required to provision the test environment. The environment
is provisioned using the container image defined in this project's
top-level directory:

```shell
$ docker build . --tag provisioning
```

### Oracle Cloud Infrastructure

#### User Setup

* If you are not using administrator creds, you will need set up a group with a name you choose and a policy both in the root compartment
 of your tenancy. The policy should have these permissions:

    * `Allow group <group_name> to manage all resources in compartment crosscloud-compartment`

    * Group Documentation: https://docs.cloud.oracle.com/iaas/Content/Identity/Tasks/managinggroups.htm#Working

    * Policy Documentation: https://docs.cloud.oracle.com/iaas/Content/Identity/Concepts/policygetstarted.htm?tocpath=Services%7CIAM%7C_____1 

* Follow the instructions here to add a user: https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/addingusers.htm

* Once the user is set up, add the user to the group you created, follow the instructions here to set up the required public
 and private api signing key (name the private key 'oci_api_key.pem'): https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#How

* When you are done you should have All the information you need to move to the next step.

## Getting Stared
Running the Cross-Cloud tests with vSphere is separated into three phases:

* [Configure](#configure)
* [Deploy](#deploy)
* [Destroy](#destroy)

### Configure
The following environment variables are used to configure Cross-Cloud
integration with Oracle Cloud Infrastructure:

| Name | Description |
|------|-------------|
| OCI_TENANCY_OCID | The ocid of your cloud tenancy, can be copied to the web console |
| OCI_USER_OCID | The ocid of the user you created, can be copied from the web console |
| OCI_FINGERPRINT | The fingerprint of the api key you created for the user in the previous step |


You should also create a folder named 'keys' with the private key you created above inside. This is crucial as terraform requires
the keys folder to be mounted in to the container.

### Deploy
The following command can be used to provision a Cross-Cloud environment
to OCI:

```shell
$ docker run \
  --rm \
  --dns 147.75.69.23 --dns 8.8.8.8 \
  -v $(pwd)/data:/cncf/data \
  -v $(pwd)/keys:/cncf/keys \
  -e OCI_TENANCY_OCID=$OCI_TENANCY_OCID \
  -e OCI_USER_OCID=$OCI_USER_OCID \
  -e OCI_FINGERPRINT=$OCI_FINGERPRINT \
  -e CLOUD=oci \
  -e BACKEND=file \
  -e NAME=cross-cloud \
  -e COMMAND=deploy \
  -ti provisioning
```

### Destroy
The following command can be used to deprovision a Cross-Cloud 
environment deployed to OCI:

```shell
$ docker run \
  --rm \
  --dns 147.75.69.23 --dns 8.8.8.8 \
  -v $(pwd)/data:/cncf/data \
  -v $(pwd)/keys:/cncf/keys \
  -e OCI_TENANCY_OCID=$OCI_TENANCY_OCID \
  -e OCI_USER_OCID=$OCI_USER_OCID \
  -e OCI_FINGERPRINT=$OCI_FINGERPRINT \
  -e CLOUD=oci \
  -e BACKEND=file \
  -e NAME=cross-cloud \
  -e COMMAND=destroy \
  -ti provisioning
```