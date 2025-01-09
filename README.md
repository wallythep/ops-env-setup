# Devops Environment Set Up

ops-env-setup is a simple script tool to set up environment variables, especially secrets, before invoking other ops scripts and tools
that need environment variables.

# Motivation

There are many tools, such as Terraform, to code devops solutions. There are many good tutorials and examples on how to use these
tools. Many of them say to set environment variables that are used in the tool to pass secret values into the workflow. An excellent
idea, clearly, based on the principle that we should only access secrets by name and never by value.

However, the examples give one or more methods of setting the variable:

``` bash
export SECRET_NAME="SECRET_VALUE"
```

This implies that you must enter this kind of information every time you want to use the tool. Or worse, that you enter 
the secret value into a script or config file. It's humorous when you see a tutorial with the secret embedded in a config
file with the warning, "Don't do this in production." So what should you do in production?

Stick to the principle: Always access secrets by name.  That principle is expressed in cloud environments with key vaults.
Every secret value is stored securely, and, using an API, can be accessed by a given name. This project will provide simple script
tools to allow key vault access to set up your environment to run your devops scripts with the proper variables set.

# Azure

I will be using Azure tools exclusively in this project, but any cloud provider or other key store provider can be used in the 
same way, so long as they allow access via an API. Similarly, I will be using Powershell exclusively here, but any shell or scripting 
tool will work fine.

## Azure Account

We assume that you already have an account in your cloud environment.We also assume that you have created a key vault in your account and at least one secret there. In the example script and config file we have used our test vault and secret, which, clearly, will not work for you. Remember to give your cloud account access to your key vault and secrets: in Azure this can be done with an RBAC setting.

## Azure CLI

We use in our code the azure python cli--az. We do this, because it my be easier to pick this code up and move it to another shell, like bash, but if you use other tools, then you'll need to recode this in your tool of choice. These scripts assume you have already logged into Azure from the CLI: az login. If not, then these scripts will fail and tell you to log in.

# Usage

The `Example.ps1` scripts has an example of what this would look like. The key to using this is to dot source the 
`Setup-Env.ps1` scripts which has a series of functions to read from your key vault and set environment variables from them.
Our script provides several functions:

- Get-SecretValue
- Set-EnvironmentSecret
- Clear-EnvironmentSecret
- Set-OpsEnvironment
- Clear-OpsEnvironment

You can get detailed help for each by using the `Get-Help` function in Powershell.

## Assumptions

Everything here always assumes you know three things:

- Your key vault name
- Your key vault secret name(s)
- The environment variable(s) to hold you secret values

These parameters can be passed directly to the process or can be stored in a configuration file for later use.

## Configuration File

I haven't created a json schema file for the config file, but the structure is fairly easily discerned from the example. There are two parts. The main overall environment setting of which the required information is the name of the keyvault. Then there is an array of environment variables to be set, which require the vault secret name and the environment variable name to be set.

The obvious advantage of a config file is that it can be reused and save in your repository. Note, that I have set one environment per file, so you can also create and use other files for other environments.
