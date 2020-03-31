[Flags()]
enum msPKIPrivateKeyFlag : uint {
    AttestNone
    RequirePrivateKeyArchival          = 0x00001
    ExportableKey                      = 0x00010
    StrongKeyProtectionRequired        = 0x00020
    RequireAlternateSignatureAlgorithm = 0x00040
    RequireSameKeyRenewal              = 0x00080
    UseLegacyProvider                  = 0x00100
    EKTrustOnUse                       = 0x00200
    EKValidateKey                      = 0x00800
    AttestPreferred                    = 0x01000
    AttestRequired                     = 0x02000
    AttestationWithoutPolicy           = 0x04000
}
