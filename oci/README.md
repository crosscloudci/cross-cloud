# Oracle Cloud Infrastructure
This directory contains the assets that enable Cross-Cloud integration
with Oracle Cloud Infrastructure.

## Prerequisites

### Required
* Oracle Cloud Infrastructure Tenancy
    * User account in tenancy with api tokens set up
    * group to put user in
    * policy to apply to user group
    * coreOS container linux image uploaded to your tenancy.
* Docker

### Docker
Docker is required to provision the test environment. The environment
is provisioned using the container image defined in this project's
top-level directory:

```shell
$ docker build . --tag provisioning
```

### Oracle Cloud Infrastructure

#### Container Linux Image

The last stable version of container linux to include an oracle build was this version: https://stable.release.core-os.net/amd64-usr/current/

* Download this file: https://stable.release.core-os.net/amd64-usr/current/coreos_production_oracle_oci_qcow_image.img.bz2

* Once you have downloaded and unzipped, you will need to upload to object storage in your tenancy.
    * Create a bucket in the compartment in the OCI the console: https://console.us-phoenix-1.oraclecloud.com/a/storage/objects
    * Click 'create bucket' and fill out the info.
    * Click on the newly created bucket
    * In the objects section, click upload object and select the unzipped image.
    * Once the image is uploaded, click on "pre-authenticated requests" on the left side of the screen.
    * Click create pre authenticated request and fill out the info to point it at the object you just created. Once
    you have done this, it will spit out a URL. Copy this url and move on.
    * Navigate to compute -> custom images on the console.
    * Click import image. Select QCOW2 and native mode. Fill out the rest of the info and use the URL you copied
    from the previous step in the object storage url field. Add any tags you desire and click import image.
    * Once the image is ready, copy its OCID and save it for the provision step.  


#### User Setup

* If you are not using administrator creds, you will need set up a group with a name you choose and a policy both in the root compartment
 of your tenancy. The policy should have these permissions:

    * `Allow group <group_name> to manage all resources in compartment crosscloud-compartment`
    * `Allow group <group_name> to manage compartments in tenancy`

    * Group Documentation: https://docs.cloud.oracle.com/iaas/Content/Identity/Tasks/managinggroups.htm#Working

    * Policy Documentation: https://docs.cloud.oracle.com/iaas/Content/Identity/Concepts/policygetstarted.htm?tocpath=Services%7CIAM%7C_____1

* Follow the instructions here to add a user: https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/addingusers.htm

* Once the user is set up, add the user to the group you created, follow the instructions here to set up the required public
 and private api signing key (name the private key 'oci_api_key.pem'): https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#How

* When you are done you should have All the information you need to move to the next step.

## Getting Stared
Running the Cross-Cloud tests with OCI is separated into three phases:

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
| OCI_COREOS_OCID | The ocid if the core os container linux image you created in a previous step |


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
  -e OCI_COREOS_OCID=$OCI_COREOS_OCID \
  -e CLOUD=oci \
  -e BACKEND=file \
  -e NAME=crosscloud \
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
  -e OCI_COREOS_OCID=$OCI_COREOS_OCID \
  -e CLOUD=oci \
  -e BACKEND=file \
  -e NAME=crosscloud \
  -e COMMAND=destroy \
  -ti provisioning
```
