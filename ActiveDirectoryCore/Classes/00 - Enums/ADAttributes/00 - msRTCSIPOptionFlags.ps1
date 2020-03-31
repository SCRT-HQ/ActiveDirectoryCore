[Flags()]
enum msRTCSIPOptionFlags : uint {
    EnabledForPublicIMConnectivity                = 0x001
    RCCEnabled                                    = 0x010
    AllowOrganizeMeetingWithAnonymousParticipants = 0x040
    UCEnabled                                     = 0x080
    EnabledForEnhancedPresence                    = 0x100
    RemoteCallControlDualMode                     = 0x200
    EnabledAutoAttendant                          = 0x400
}
