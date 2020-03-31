enum searchFlags : uint {
    Indexed              = 0x0001
    ContainerIndexed     = 0x0002
    ANRSet               = 0x0004
    IncludeInTombstone   = 0x0008
    IncludeWhenCopied    = 0x0010
    TupleIndexed         = 0x0020
    VLVIndexed           = 0x0040
    Confidential         = 0x0080
    NeverAudit           = 0x0100
    RODCFiltered         = 0x0200
    ExtendedLinkTracking = 0x0400
    BaseOnly             = 0x0800
    PartitionSecret      = 0x1000
}
