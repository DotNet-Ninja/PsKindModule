function Sync-KindData{
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string] $Version = "0.14"
    )

    $dataUrl = "https://raw.githubusercontent.com/DotNet-Ninja/PsKindModule/main/data/kind.$Version.json"
    $destination = Get-KindDataPath $Version
    Invoke-RestMethod $dataUrl -OutFile $destination -Force
}

function Get-KindDataPath{
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string] $Version = "0.14"
    )
    return "$HOME\.pskind\kind.$Version.json"
}

function Get-KindData{
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string] $Version = "0.14"
    )
    $path = Get-KindDataPath $Version
    if(!(Test-Path($path))){
        Sync-KindData $Version
    }
    $data = Get-Content $path
    $result = ConvertFrom-Json $data
    return $result
}

Export-ModuleMember -Function Get-KindData
Export-ModuleMember -Function Sync-KindData
Export-ModuleMember -Function Get-KindDataPath