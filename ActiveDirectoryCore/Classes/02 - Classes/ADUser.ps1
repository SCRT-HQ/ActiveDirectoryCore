class ADUser : ADPrincipal {
    [string] $SamAccountName
    [string] $UserPrincipalName
    [GUID]   $objectGUID
    [SID]    $objectSID

}
