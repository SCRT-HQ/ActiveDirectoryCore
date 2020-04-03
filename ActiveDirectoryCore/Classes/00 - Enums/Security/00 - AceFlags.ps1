[Flags()]
enum AceFlags : byte {
    ObjectInherit      = 0x01
    ContainerInherit   = 0x02
    NoPropagateInherit = 0x04
    InheritOnly        = 0x08
    Inherited          = 0x10
    SuccessfulAccess   = 0x40
    FailedAccess       = 0x80
}
