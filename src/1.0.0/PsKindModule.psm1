function Sync-PsKindConfig{
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string] $Version = "0.14.0"
    )

    Write-Verbose "Syncing PsKindConfig"
    $dataUrl = "https://raw.githubusercontent.com/DotNet-Ninja/PsKindModule/main/data/kind.$Version.config.json"
    $destination = Get-KindDataPath $Version
    Write-Verbose "Downloading $dataUrl to $destination"
    Invoke-RestMethod $dataUrl -OutFile $destination | Out-Null
    Write-Verbose "Download Complete"
}

function Get-PsKindConfigPath{
    $directory = [System.IO.Path]::Combine($HOME, ".pskind")
    if(!(Test-Path($directory))){
        Write-Verbose "Creating Data Directory ($directory)"
        New-Item -Path $directory -ItemType Directory | Out-Null
    }
    $file = [System.IO.Path]::Combine($directory, "pskind.config.json")
    return $file
}

function Get-PsKindConfig{
    $version = Get-KindVersion
    $path = Get-PsKindConfigPath
    if(!(Test-Path($path))){        
        Write-Verbose "PsKindConfig not found,  Initiating Sync"
        Sync-PsKindConfig $Version
    }
    [string]$data = Get-Content $path
    $config = ConvertFrom-Json $data
    $configVersion = $config.Version
    if($configVersion -ne $version){
        Write-Verbose "PsKindConfig version mismatch.  Expected $version but found $configVersion"
        Write-Verbose "Initiating PsConfigSync"
        Sync-PsKindConfig $version
        [string]$data = Get-Content $path
        $config = ConvertFrom-Json $data
    }
    return $config
}

function Get-KindVersion{
    $response = kind --version
    $version = $response.SubString($response.LastIndexOf(" ")).Trim()
    return $version
}

Export-ModuleMember -Function Get-PsKindConfig
Export-ModuleMember -Function Sync-PsKindConfig
Export-ModuleMember -Function Get-PsKindConfigPath
Export-ModuleMember -Function Get-KindVersion
