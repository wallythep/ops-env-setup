<#
.SYNOPSIS
    Gets secret value from key vault
.DESCRIPTION
    Gets a secret value from Azure key vault by vault name and secret name.
.PARAMETER VaultName
    The name of the Key Vault in Azure.
.PARAMETER Name
    The secret name.
.OUTPUTS
    String. The value of the secret.
.EXAMPLE
    Get-SecretValue -VaultName "my-key-vault-name" -Name "my-secret-name"
    Returns the unencrypted value of the secret stored in the key vault.
#>

function Get-SecretValue {
    [CmdletBinding()]
    param (
        # Key Vault Name
        [Parameter(Mandatory=$true)]
        [string]
        $VaultName,

        # Secret Name
        [Parameter(Mandatory=$true)]
        [string]
        $Name
    )
    
    begin {
        
    }
    
    process {
        $secret = az keyvault secret show --vault-name $VaultName -n $Name | ConvertFrom-Json
        
    }
    
    end {
        if ($secret) {
            return $secret.value
        }
    }
}

<#
.SYNOPSIS
    Set environment variable with key vault secret.
.DESCRIPTION
    Set an environment variable with a value from an Azure key vault.
.PARAMETER VaultName
    The name of the Key Vault in Azure.
.PARAMETER SecretName
    The secret name.
.PARAMETER EnvironmentVariable
    The name of the environment variable to set.
.OUTPUTS
    None.
.EXAMPLE
    Set-EnvironmentSecret -VaultName "my-key-vault-name" -SecretName "my-secret-name" -EnvironmentVariable TEST_1
    Sets the environment variable with the secret value from Azure key vault.
#>
function Set-EnvironmentSecret {
    [CmdletBinding()]
    param (
        # Key Vault Name
        [Parameter(Mandatory=$true)]
        [string]
        $VaultName,

        # Secret Name
        [Parameter(Mandatory=$true)]
        [string]
        $SecretName,

        # Environment Variable Name
        [Parameter(Mandatory=$true)]
        [string]
        $EnvironmentVariable
        
    )
    
    begin {
        
    }
    
    process {
        $secret_value = Get-SecretValue -VaultName $VaultName -Name $SecretName
    }
    
    end {
        if ($secret_value){
            Set-Item -Path "Env:/$($EnvironmentVariable)" -Value $secret_value
        }
    }
}

<#
.SYNOPSIS
    Clear environment variable
.DESCRIPTION
    Clears an environment variable secret value
.PARAMETER EnvironmentVariable
    The variable to clear.
.EXAMPLE
    Clear-EnvironmentSecret -EnvironmentVariable TEST_1
    Sets the 'TEST_1' variable value to blank, which effectively removes the variable from the environment.
#>
function Clear-EnvironmentSecret {
    [CmdletBinding()]
    param (
        # Environment Variable Name
        [Parameter(Mandatory=$true)]
        [string]
        $EnvironmentVariable        
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        Set-Item -Path "Env:/$($EnvironmentVariable)" -Value ''
    }
}

<#
.SYNOPSIS
    Sets environment from config file
.DESCRIPTION
    Sets the operations environment from a given configuration file.
.NOTES
    See the example config for document structure.
.EXAMPLE
    Set-OpsEnvironment -ConfigFile .\env_config.json
    Reads the given file and sets the variables given therein.
#>
function Set-OpsEnvironment {
    [CmdletBinding()]
    param (
        # Environment Config File Path
        [Parameter(Mandatory=$true)]
        [string]
        $ConfigFile
    )
    
    begin {
        # Check that the file exists
        $isConfig = Test-Path($ConfigFile)
        
    }
    
    process {
        if ($isConfig) {
            # Write-Output "hello"
            $config = Get-Content -Raw $ConfigFile | ConvertFrom-Json -Depth 99
            Write-Output "Setting environment: $($config.environment.name)."
            $config.variables | ForEach-Object {
                # Write-Output $_.variableName
                Set-EnvironmentSecret `
                    -VaultName $config.environment.keyVault `
                    -SecretName $_.secretName `
                    -EnvironmentVariable $_.variableName
            }
        }
    }
    
    end {
        if (!$isConfig){
            Write-Error "File '$($ConfigFile)' not found."
        }
    }
}

<#
.SYNOPSIS
    Clears environment from config file
.DESCRIPTION
    Clears the operations environment from a given configuration file.
.NOTES
    See the example config for document structure.
.EXAMPLE
    Clear-OpsEnvironment -ConfigFile .\env_config.json
    Reads the given file and clears all the variables given therein.
#>

function Clear-OpsEnvironment {
    [CmdletBinding()]
    param (
        # Environment Config File Path
        [Parameter(Mandatory=$true)]
        [string]
        $ConfigFile
    )
    
    begin {
        # Check that the file exists
        $isConfig = Test-Path($ConfigFile)
        
    }
    
    process {
        if ($isConfig) {
            # Write-Output "hello"
            $config = Get-Content -Raw $ConfigFile | ConvertFrom-Json -Depth 99
            Write-Output "Clearing environment: $($config.environment.name)."
            $config.variables | ForEach-Object {
                # Write-Output $_.variableName
                Clear-EnvironmentSecret -EnvironmentVariable $_.variableName
            }
        }
    }
    
    end {
        if (!$isConfig){
            Write-Error "File '$($ConfigFile)' not found."
        }
    }
}