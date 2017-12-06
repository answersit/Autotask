﻿<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsActionType
{
  <#
      .SYNOPSIS
      This function get a ActionType through the Autotask Web Services API.
      .DESCRIPTION
      This function get a ActionType through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsActionType [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsActionType
      .NOTES
      NAME: Get-AtwsActionType
  #>
	  [CmdLetBinding(DefaultParameterSetName='Filter')]
    Param
    (
                [Parameter(
          Mandatory = $true,
          ValueFromRemainingArguments = $true,
          ParameterSetName = 'Filter')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Filter ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $id
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Name
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('None','Calendar','To Do','Both')]

        [String]
         $View
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $Active
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $SystemActionType
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Active','SystemActionType')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Active','SystemActionType')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Active','SystemActionType')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Active','SystemActionType')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Active','SystemActionType')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name')]
        [String[]]
        $EndsWith
    )



          

  Begin
  { 
    If (-not($global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }   

  Process
  {     

    If (-not($Filter))
    {
        $Fields = $Atws.GetFieldInfo('ActionType')
        
        Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
        {
            $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
            If ($Field.IsPickList)
            {
              $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
              $Value = $PickListValue.Value
            }
            Else
            {
              $Value = $Parameter.Value
            }
            $Filter += $Parameter.Key
            $Filter += '-eq'
            $Filter += $Value
        }
        
    }

    Get-AtwsData -Entity ActionType -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}