[Flags()]
enum pwdProperties : uint {
    Complex              = 0x01
    NoAnonymousChange    = 0x02
    NoClearChange        = 0x04
    LockoutAdmins        = 0x08
    StoreClearText       = 0x10
    RefusePasswordChange = 0x20
}
