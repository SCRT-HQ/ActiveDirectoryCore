[Flags()]
enum userAccountControl : uint {
    Script                             = 0x00000001
    AccountDisable                     = 0x00000002
    HomeDirectoryRequired              = 0x00000008
    LockedOut                          = 0x00000010
    PasswordNotRequired                = 0x00000020
    PasswordCannotChange               = 0x00000040
    EncryptedTextPasswordAllowed       = 0x00000080
    TemporaryDuplicateAccount          = 0x00000100
    NormalAccount                      = 0x00000200
    InterdomainTrustAccount            = 0x00000800
    WorkstationTrustAccount            = 0x00001000
    ServerTrustAccount                 = 0x00002000
    DoNotExpirePassword                = 0x00010000
    MNSLogonAccount                    = 0x00020000
    SmartcardRequired                  = 0x00040000
    TrustedForDelegation               = 0x00080000
    NotDelegated                       = 0x00100000
    UseDESKeyOnly                      = 0x00200000
    DoNotRequirePreAuth                = 0x00400000
    PasswordExpired                    = 0x00800000
    TrustedToAuthenticateForDelegation = 0x01000000
}
