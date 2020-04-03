[Flags()]
enum SecurityDescriptorControl : ushort {
    SelfRelative                    = 0x0000
    RMControlValid                  = 0x0001
    SaclProtected                   = 0x0002
    DaclProtected                   = 0x0004
    SaclAutoInherited               = 0x0008
    DaclAutoInherited               = 0x0010
    SaclComputedInheritanceRequired = 0x0020
    DaclComputedInheritanceRequired = 0x0040
    ServerSecurity                  = 0x0080
    DaclTrusted                     = 0x0100
    SaclDefaulted                   = 0x0200
    SaclPresent                     = 0x0400
    DaclDefaulted                   = 0x0800
    DaclPresent                     = 0x1000
    GroupDefaulted                  = 0x2000
    OwnerDefaulted                  = 0x4000
}
