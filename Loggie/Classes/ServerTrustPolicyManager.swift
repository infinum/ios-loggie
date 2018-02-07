//
//  ServerTrustPolicyManager.swift
//  Loggie
//
//  Created by Filip Bec on 05/02/2018.
//  Source: Alamofire - https://github.com/Alamofire/Alamofire
//

import UIKit

@objc(LGServerTrustPolicy)
public protocol ServerTrustPolicy: NSObjectProtocol {
    func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool
}

public extension ServerTrustPolicy {

    public func trustIsValid(_ trust: SecTrust) -> Bool {
        var isValid = false

        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &result)

        if status == errSecSuccess {
            let unspecified = SecTrustResultType.unspecified
            let proceed = SecTrustResultType.proceed


            isValid = result == unspecified || result == proceed
        }
        return isValid
    }
}

public class DefaultEvaluation: NSObject, ServerTrustPolicy {
    private let validateHost: Bool

    public init(validateHost: Bool) {
        self.validateHost = validateHost
    }

    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
        SecTrustSetPolicies(serverTrust, policy)
        return trustIsValid(serverTrust)
    }
}

public class PinCertificates: NSObject, ServerTrustPolicy {
    private let pinnedCertificates: [SecCertificate]
    private let validateCertificateChain: Bool
    private let validateHost: Bool

    public init(certificates: [SecCertificate], validateCertificateChain: Bool, validateHost: Bool) {
        self.pinnedCertificates = certificates
        self.validateCertificateChain = validateCertificateChain
        self.validateHost = validateHost
    }

    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        if validateCertificateChain {
            let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
            SecTrustSetPolicies(serverTrust, policy)

            SecTrustSetAnchorCertificates(serverTrust, pinnedCertificates as CFArray)
            SecTrustSetAnchorCertificatesOnly(serverTrust, true)
            return trustIsValid(serverTrust)
        } else {
            let serverCertificatesDataArray = certificateData(for: serverTrust)
            let pinnedCertificatesDataArray = certificateData(for: pinnedCertificates)

            for serverCertificateData in serverCertificatesDataArray {
                for pinnedCertificateData in pinnedCertificatesDataArray {
                    if serverCertificateData == pinnedCertificateData {
                        return true
                    }
                }
            }
        }
        return false
    }

    private func certificateData(for trust: SecTrust) -> [Data] {
        var certificates: [SecCertificate] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
                certificates.append(certificate)
            }
        }

        return certificateData(for: certificates)
    }

    private func certificateData(for certificates: [SecCertificate]) -> [Data] {
        return certificates.map { SecCertificateCopyData($0) as Data }
    }
}

public class PinPublicKeys: NSObject, ServerTrustPolicy {
    private let pinnedPublicKeys: [SecKey]
    private let validateCertificateChain: Bool
    private let validateHost: Bool

    public init(publicKeys: [SecKey], validateCertificateChain: Bool, validateHost: Bool) {
        self.pinnedPublicKeys = publicKeys
        self.validateCertificateChain = validateCertificateChain
        self.validateHost = validateHost
    }

    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        var certificateChainEvaluationPassed = true

        if validateCertificateChain {
            let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
            SecTrustSetPolicies(serverTrust, policy)

            certificateChainEvaluationPassed = trustIsValid(serverTrust)
        }

        if certificateChainEvaluationPassed {
            outerLoop: for serverPublicKey in publicKeys(for: serverTrust) as [AnyObject] {
                for pinnedPublicKey in pinnedPublicKeys as [AnyObject] {
                    if serverPublicKey.isEqual(pinnedPublicKey) {
                        return true
                    }
                }
            }
        }
        return false
    }

    // MARK: - Private - Public Key Extraction

    private func publicKeys(for trust: SecTrust) -> [SecKey] {
        var publicKeys: [SecKey] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if
                let certificate = SecTrustGetCertificateAtIndex(trust, index),
                let publicKey = publicKey(for: certificate)
            {
                publicKeys.append(publicKey)
            }
        }

        return publicKeys
    }

    private func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)

        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }

        return publicKey
    }
}

public class RevokedEvaluation: NSObject, ServerTrustPolicy {
    let validateHost: Bool
    let revocationFlags: CFOptionFlags

    public init(validateHost: Bool, revocationFlags: CFOptionFlags) {
        self.validateHost = validateHost
        self.revocationFlags = revocationFlags
    }

    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        let defaultPolicy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
        let revokedPolicy = SecPolicyCreateRevocation(revocationFlags)
        SecTrustSetPolicies(serverTrust, [defaultPolicy, revokedPolicy] as CFTypeRef)

        return trustIsValid(serverTrust)
    }
}

public class DisableEvaluation: NSObject, ServerTrustPolicy {
    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        return true
    }
}

/// Responsible for managing the mapping of `ServerTrustPolicy` objects to a given host.
@objc(LGServerTrustPolicyManager)
open class ServerTrustPolicyManager: NSObject {
    /// The dictionary of policies mapped to a particular host.
    public let policies: [String: ServerTrustPolicy]

    public init(policies: [String: ServerTrustPolicy]) {
        self.policies = policies
    }

    public func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return policies[host]
    }
}
