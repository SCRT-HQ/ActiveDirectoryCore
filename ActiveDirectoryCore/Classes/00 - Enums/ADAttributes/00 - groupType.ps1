# https://docs.microsoft.com/en-us/windows/win32/adschema/a-grouptype
[Flags()]
enum groupType : uint {
    System      = 0x00000001
    Global      = 0x00000002
    DomainLocal = 0x00000004
    Universal   = 0x00000008
    AppBasic    = 0x00000010
    AppQuery    = 0x00000020
    Security    = 0x80000000u
}
