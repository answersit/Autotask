﻿Function Set-AtwsDefinition
{ 
  Begin
  { 
    $EntityName = '#EntityName'
    $Prefix = '#Prefix'
        
    # Lookup Verbose, WhatIf and other preferences from calling context
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState 

    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:ESToffset))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName -Connection $Prefix

    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          $Value = $PickListValue.Value
        }
        ElseIf ($Field.Type -eq 'datetime')
        {
          # Yes, you really have to ADD the difference
          $Value = $Parameter.Value.AddHours($script:ESToffset)
        }
        Else
        {
          $Value = $Parameter.Value
        }  
        Foreach ($Object in $InputObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }
   
    $ModifiedObjects = Set-AtwsData -Entity $InputObject -Connection $Prefix

  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    
    If ($PassThru.IsPresent)
    {
      Return $ModifiedObjects
    }
  }

}
