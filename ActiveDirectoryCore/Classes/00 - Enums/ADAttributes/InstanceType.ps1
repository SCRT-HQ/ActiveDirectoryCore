# https://docs.microsoft.com/en-us/windows/win32/adschema/a-instancetype

[Flags()]
enum instanceType : uint {
    HeadOfNamingContext           = 0x01
    ReplicaNotInstantiated        = 0x02
    ObjectIsWriteableOnDirectory  = 0x04
    NamingContextAboveIsHeld      = 0x08
    NamingContextBeingConstructed = 0x10
    NamingContextBeingRemoved     = 0x20
}
