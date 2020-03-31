[Flags()]
enum systemFlags : uint {
    NotReplicated              = 0x00000001
    Domain                     = 0x00000002
    Constructed                = 0x00000004
    Category1Object            = 0x00000010
    DeletedImmediately         = 0x02000000
    CannotBeMoved              = 0x04000000
    CannotBeRenamed            = 0x08000000
    CanBeMovedWithRestrictions = 0x10000000
    CanBeMoved                 = 0x20000000
    CanBeRenamed               = 0x40000000
    CannotBeDeleted            = 0x80000000u
}
