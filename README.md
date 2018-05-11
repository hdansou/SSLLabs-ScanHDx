# SSLLabs-ScanHDx

SSLLabs-ScanHDx is a Powershell module that uses the SSL Labs API to report the state of the SSL associated with the tested domain.


## Installation

First, check your Powershell version

```powershell
$PSVersionTable.PSVersion.Major
```

Next, choose your preferred installation method.

### Any Powershell Version

Choose the module path you want to use to store your module. The following command will list all your module directories.

```powershell
 $env:PSModulePath -split ';'
```

Download and extract the Module in your chosen module directory.
Last, import the SSLLabs-ScanHDx module by running:

```powershell
Import-Module  SSLLabs-ScanHDx
```


### Powershell version 5

```powershell
Install-Module SSLLabs-ScanHDx -Scope CurrentUser
```


## Update

To update the Module to the latest version, you may run the following command if you using Powershell version 5:

```powershell
Update-Module SSLLabs-ScanHDx -Force
```

For any powershell version, you may replace the module directory with the latest one. The process is similar to the above installation instruction.
