enum WellKnownSid : ulong {
    CREATORGROUP                     = 0x0100000000
    DIALUP                           = 0x0100000000
    CONSOLELOGON                     = 0x0100000000
    NETWORK                          = 0x0200000000
    CREATOROWNERSERVER               = 0x0200000000
    BATCH                            = 0x0300000000
    CREATORGROUPSERVER               = 0x0300000000
    OWNERRIGHTS                      = 0x0400000000
    INTERACTIVE                      = 0x0400000000
    SERVICE                          = 0x0600000000
    ANONYMOUSLOGON                   = 0x0700000000
    PROXY                            = 0x0800000000
    ENTERPRISEDOMAINCONTROLLERS      = 0x0900000000
    SELF                             = 0x0A00000000
    AuthenticatedUsers               = 0x0B00000000
    RESTRICTED                       = 0x0C00000000
    TERMINALSERVERUSER               = 0x0D00000000
    ThisOrganization                 = 0x0F00000000
    SYSTEM                           = 0x1200000000
    LOCALSERVICE                     = 0x1300000000
    NETWORKSERVICE                   = 0x1400000000
    Wellknown                        = 0x1500000000    # Check name
    Administrators                   = 0x2000000220
    Users                            = 0x2000000221
    Guests                           = 0x2000000222
    PowerUsers                       = 0x2000000223
    AccountOperators                 = 0x2000000224    # Check name
    ServerOperators                  = 0x2000000225    # Check name
    PrintOperators                   = 0x2000000226    # Check name
    BackupOperators                  = 0x2000000227
    Replicator                       = 0x2000000228
    PreWindows2000CompatibleAccess   = 0x200000022A    # Check name
    RemoteDesktopUsers               = 0x200000022B
    NetworkConfigurationOperators    = 0x200000022C
    IncomingForestTrustBuilders      = 0x200000022D    # Check name
    PerformanceMonitorUsers          = 0x200000022E
    PerformanceLogUsers              = 0x200000022F
    WindowsAuthorizationAccessGroup  = 0x2000000230    # Check name
    TerminalServerLicenseServers     = 0x2000000231    # Check name
    DistributedCOMUsers              = 0x2000000232
    CryptographicOperators           = 0x2000000239
    EventLogReaders                  = 0x200000023D
    CertificateServiceDCOMAccess     = 0x200000023E    # Check name
    RDSRemoteAccessServers           = 0x200000023F    # Check name
    RDSEndpointServers               = 0x2000000240    # Check name
    RDSManagementServers             = 0x2000000241    # Check name
    HyperVAdministrators             = 0x2000000242
    AccessControlAssistanceOperators = 0x2000000243
    RemoteManagementUsers            = 0x2000000244
    StorageReplicaAdministrators     = 0x2000000246    # Check name
    ALLSERVICES                      = 0x5000000000
    NTService                        = 0x5000000000    # Check name
    VirtualMachines                  = 0x5300000000    # Check name
    WindowManagerGroup               = 0x5A00000000
}
