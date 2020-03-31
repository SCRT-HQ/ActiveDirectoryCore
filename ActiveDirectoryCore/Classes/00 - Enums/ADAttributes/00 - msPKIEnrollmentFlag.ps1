[Flags()]
enum msPKIEnrollmentFlag : uint {
    IncludeSymmetricAlgorithms                               = 0x00001
    PendAllRequests                                          = 0x00002
    PublishToKRAContainer                                    = 0x00004
    PublishToDS                                              = 0x00008
    AutoEnrollmentCheckUserDSCertificate                     = 0x00010
    AutoEnrollment                                           = 0x00020
    PreviousApprovalValidateReenrollment                     = 0x00040
    UserInteractionRequired                                  = 0x00100
    RemoveInvalidCertificateFromPersonalStore                = 0x00400
    AllowEnrollOnBehalfOf                                    = 0x00800
    AddOSCPNoCheck                                           = 0x01000
    EnableKeyReuseOnNTTokenKeySetStorageFull                 = 0x02000
    NoRevocationInfoInIssuedCerts                            = 0x04000
    IncludeBasicConstraintsForEECerts                        = 0x08000
    AllowPreviousApprovalKeyBasedRenewalValidateReenrollment = 0x10000
    IssuancePoliciesFromRequest                              = 0x20000
}
