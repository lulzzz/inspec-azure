# CIS Benchmark Controls for Azure

One of the main attractions of Inspec is to be able to take Centre for Internet Security (CIS) profiles and turn them into controls that can be used to test systems that contain things that the profiles can test.

Inpsec for Azure follows this and has initial controls for the following CIS Azure Benchmark profiles:

 - Storage Accounts
   - 3.1 - Ensure that 'Secure transfer required' is set to Enabled
   - 3.2 - Ensure that 'Storage service encryption' is set to Enabled for Blob Service
   - 3.6 - Ensure that 'Storage service encryption' is set to Enabled for File Service
 - Networking
   - 6.1 - Disable RDP access on Network Security Groups from Internet
   - 6.2 - Disable SSH access on Network Security Groups from Internet

## Executing the Controls

In order to execute the controls access to Azure has to be configured as defined in the [README](../../README.md) file.

Then a file that holds the attributes for what is going to be tested needs to be created. This is so that the controls know what things are to be tested in Azure. An example file is located in the repo `examples/profile-attrbutes.yml`.

This file contains the following information:

```yml
sa_resource_group_name: Inspec-Azure
sa_name: kghbxoujxjnvuwo

nsg_resource_group_name: Inspec-Azure
nsg_name: Inspec-NSG
```

These items inform the controls what resources are to be tested in Azure and what resource group they are in. These particular ones will test the resources that the integration tests create.

Note: The storage account name is randomly generated when the integration tests are run.

Use the following command to run the tests. This assumes that the command is being run in the root of the repo and that the example attributes file is being used.

```
inspec exec . --attrs examples/profile-attributes.yml 
```