[Flags()]
enum msPKICertificateNameFlag : uint {
    EnrolleeSuppliesSubject          = 0x00000001
    OldCertSuppliesSubjectAndAltName = 0x00000008
    EnrolleeSuppliesSubjectAltName   = 0x00010000
    SubjectAltRequireDomainDns       = 0x00400000
    SubjectAltRequireDirectoryGUID   = 0x01000000
    SubjectAltRequireUPN             = 0x02000000
    SubjectAltRequireEmail           = 0x04000000
    SubjectAltRequireDns             = 0x08000000
    SubjectRequireDnsAsCN            = 0x10000000
    SubjectRequireEmail              = 0x20000000
    SubjectRequireCommonName         = 0x40000000
    SubjectRequireDirectoryPath      = 0x80000000u
}
