class ADSecurityPrincipal : SecurityPrincipal {
    [string] $DomainName
    [string] $SamAccountName
    [string] $UserPrincipalName
    [Sid]    $Sid


    [string] ToString() {
        return '{0}\{1}' -f $this.DomainName, $this.SamAccountName
    }
}
