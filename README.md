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

