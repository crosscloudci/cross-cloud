- [Azure Equivalence for Existing EC2](#sec-1)
  - [Locating the Equivalent CentOS Image](#sec-1-1)
- [Summary](#sec-2)

The [Terraform Azure Provider](https://www.terraform.io/docs/providers/azure/) needs a publish<sub>settings</sub> file

# Azure Equivalence for Existing EC2<a id="sec-1"></a>

## Locating the Equivalent CentOS Image<a id="sec-1-1"></a>

Currently the cncf/demo [uses the latest CentOS7 AMI](https://github.com/cncf/demo/commit/62b4ee750cea96ac18d9998cebed36660b3d5864#diff-165521d9e758a5a743ea42c6fd528156R10), so let's go find that at Azure.

```shell
az vm image list -o table
```

| Offer         | Publisher              | Sku                | Urn                                                            | UrnAlias            | Version   |
| ------------- | ---------------------- | ------------------ | -------------------------------------------------------------- | ------------------- | --------- |
| WindowsServer | MicrosoftWindowsServer | 2016-Datacenter    | MicrosoftWindowsServer:WindowsServer:2016-Datacenter:latest    | Win2016Datacenter   | latest    |
| WindowsServer | MicrosoftWindowsServer | 2012-R2-Datacenter | MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:latest | Win2012R2Datacenter | latest    |
| WindowsServer | MicrosoftWindowsServer | 2008-R2-SP1        | MicrosoftWindowsServer:WindowsServer:2008-R2-SP1:latest        | Win2008R2SP1        | latest    |
| WindowsServer | MicrosoftWindowsServer | 2012-Datacenter    | MicrosoftWindowsServer:WindowsServer:2012-Datacenter:latest    | Win2012Datacenter   | latest    |
| UbuntuServer  | Canonical              | 14.04.4-LTS        | Canonical:UbuntuServer:14.04.4-LTS:latest                      | UbuntuLTS           | latest    |
| CentOS        | OpenLogic              | 7.2                | OpenLogic:CentOS:7.2:latest                                    | CentOS              | latest    |
| openSUSE      | SUSE                   | 13.2               | SUSE:openSUSE:13.2:latest                                      | openSUSE            | latest    |
| RHEL          | RedHat                 | 7.2                | RedHat:RHEL:7.2:latest                                         | RHEL                | latest    |
| SLES          | SUSE                   | 12-SP1             | SUSE:SLES:12-SP1:latest                                        | SLES                | latest    |
| Debian        | credativ               | 8                  | credativ:Debian:8:latest                                       | Debian              | latest    |
| CoreOS        | CoreOS                 | Stable             | CoreOS:CoreOS:Stable:latest                                    | CoreOS              | latest    |

We are looking for CentOS, and looks like the default Publisher is OpenLogic. Let's see what SKU's they have in westus.

```shell
az vm image list-skus -o table --publisher OpenLogic --location westus --offer CentOS
```

| Location   | Name   |
| ---------- | ------ |
| westus     | 6.5    |
| westus     | 6.6    |
| westus     | 6.7    |
| westus     | 6.8    |
| westus     | 7.0    |
| westus     | 7.1    |
| westus     | 7.2    |
| westus     | 7.2n   |
| westus     | 7.3    |

I prefer not to use 'latest' anywhere, let's grab the precise version of CentOS 7.3.

```shell
az vm image list --offer centos -o table --publisher openlogic --sku 7.3 --all
```

| Offer   | Publisher   | Sku   | Urn                               | Version      |
| ------- | ----------- | ----- | --------------------------------- | ------------ |
| CentOS  | OpenLogic   | 7.3   | OpenLogic:CentOS:7.3:7.3.20161221 | 7.3.20161221 |

I'm comfortable using this image as our base.

# Summary<a id="sec-2"></a>
