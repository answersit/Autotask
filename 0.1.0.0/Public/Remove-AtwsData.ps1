﻿<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Remove-AtwsData 
{
    <#
      .SYNOPSIS
      This function updates one or more Autotask entities with new or modified properties.
      .DESCRIPTION
      This function updates one or more Autotask entities with new or modified properties
      .INPUTS
      Autotask.Entity[]. One or more Autotask entities to delete.
      .OUTPUTS
      Nothing.
      .EXAMPLE
      Remove-AtwsData -Entity $Entity
      Passes all Autotask entities in $Entity to the Autotask webservices API and deletes them.
      .NOTES
      NAME: Remove-AtwsData
      .LINK
      Get-AtwsData
      New-AtwsData
      Set-AtwsData
  #>
 
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [Autotask.Entity[]]
        $Entity
    )
    
    
    
    If (-not($global:atws.Url))
    {
        
        Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    

    #$Result = $atws.delete($Entity)
    
    
    If ($Result.Errors.Count -eq 0)
    {
      Return $Result
    }
    Else
    {
      Foreach ($AtwsError in $Result.Errors)
      {
        Write-Error $AtwsError
      }
    }

}

