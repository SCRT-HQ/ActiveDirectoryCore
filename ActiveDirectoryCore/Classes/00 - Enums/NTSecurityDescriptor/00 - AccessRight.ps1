[Flags()]
enum AccessRight : uint {
    GenericRead          = 0x80000000u
    GenericWrite         = 0x40000000
    GenericExecute       = 0x20000000
    GenericAll           = 0x10000000
    AccessSystemSecurity = 0x01000000
    Synchronize          = 0x00100000
    WriteOwner           = 0x00080000
    WriteDacl            = 0x00040000
    ReadControl          = 0x00020000
    Delete               = 0x00010000
    ControlAccess        = 0x00000100
    CreateChild          = 0x00000001
    DeleteChild          = 0x00000002
    ReadProperty         = 0x00000010
    WriteProperty        = 0x00000020
    ValidatedWrite       = 0x00000008
}
