//
//  ServerTrustPolicy.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// MARK: - ServerTrustPolicy

/// The `ServerTrustPolicy` evaluates the server trust generally provided by an `NSURLAuthenticationChallenge` when
/// connecting to a server over a secure HTTPS connection. The policy configuration then evaluates the server trust
/// with a given set of criteria to determine whether the server trust is valid and the connection should be made.
///
/// Using pinned certificates or public keys for evaluation helps prevent man-in-the-middle (MITM) attacks and other
/// vulnerabilities. Applications dealing with sensitive customer data or financial information are strongly encouraged
/// to route all communication over an HTTPS connection with pinning enabled.
///
/// - performDefaultEvaluation: Uses the default server trust evaluation while allowing you to control whether to
///                             validate the host provided by the challenge. Applications are encouraged to always
///                             validate the host in production environments to guarantee the validity of the server's
///                             certificate chain.
///
/// - performRevokedEvaluation: Uses the default and revoked server trust evaluations allowing you to control whether to
///                             validate the host provided by the challenge as well as specify the revocation flags for
///                             testing for revoked certificates. Apple platforms did not start testing for revoked
///                             certificates automatically until iOS 10.1, macOS 10.12 and tvOS 10.1 which is
///                             demonstrated in our TLS tests. Applications are encouraged to always validate the host
///                             in production environments to guarantee the validity of the server's certificate chain.
///
/// - pinCertificates:          Uses the pinned certificates to validate the server trust. The server trust is
///                             considered valid if one of the pinned certificates match one of the server certificates.
///                             By validating both the certificate chain and host, certificate pinning provides a very
///                             secure form of server trust validation mitigating most, if not all, MITM attacks.
///                             Applications are encouraged to always validate the host and require a valid certificate
///                             chain in production environments.
///
/// - pinPublicKeys:            Uses the pinned public keys to validate the server trust. The server trust is considered
///                             valid if one of the pinned public keys match one of the server certificate public keys.
///                             By validating both the certificate chain and host, public key pinning provides a very
///                             secure form of server trust validation mitigating most, if not all, MITM attacks.
///                             Applications are encouraged to always validate the host and require a valid certificate
///                             chain in production environments.
///
/// - disableEvaluation:        Disables all evaluation which in turn will always consider any server trust as valid.
///
/// - customEvaluation:         Uses the associated closure to evaluate the validity of the server trust.
public enum ServerTrustPolicy {
	case performDefaultEvaluation(validateHost: Bool)
	case performRevokedEvaluation(validateHost: Bool, revocationFlags: CFOptionFlags)
	case pinCertificates(certificates: [SecCertificate], validateCertificateChain: Bool, validateHost: Bool)
	case pinPublicKeys(publicKeys: [SecKey], validateCertificateChain: Bool, validateHost: Bool)
	case disableEvaluation
	case customEvaluation((_ serverTrust: SecTrust, _ host: String) -> Bool)

	// MARK: - Bundle Location

	/// Returns all certificates within the given bundle with a `.cer` file extension.
	///
	/// - parameter bundle: The bundle to search for all `.cer` files.
	///
	/// - returns: All certificates within the given bundle.
	public static func certificates(in bundle: Bundle = Bundle.main) -> [SecCertificate] {
		var certificates: [SecCertificate] = []

		let paths = Set([".cer", ".CER", ".crt", ".CRT", ".der", ".DER"].map { fileExtension in
			bundle.paths(forResourcesOfType: fileExtension, inDirectory: nil)
			}.joined())

		for path in paths {
			if
				let certificateData = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData,
				let certificate = SecCertificateCreateWithData(nil, certificateData)
			{
				certificates.append(certificate)
			}
		}

		return certificates
	}

	/// Returns all public keys within the given bundle with a `.cer` file extension.
	///
	/// - parameter bundle: The bundle to search for all `*.cer` files.
	///
	/// - returns: All public keys within the given bundle.
	public static func publicKeys(in bundle: Bundle = Bundle.main) -> [SecKey] {
		var publicKeys: [SecKey] = []

		for certificate in certificates(in: bundle) {
			if let publicKey = publicKey(for: certificate) {
				publicKeys.append(publicKey)
			}
		}

		return publicKeys
	}

	// MARK: - Evaluation

	/// Evaluates whether the server trust is valid for the given host.
	///
	/// - parameter serverTrust: The server trust to evaluate.
	/// - parameter host:        The host of the challenge protection space.
	///
	/// - returns: Whether the server trust is valid.
	public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
		var serverTrustIsValid = false

		switch self {
		case let .performDefaultEvaluation(validateHost):
			let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
			SecTrustSetPolicies(serverTrust, policy)

			serverTrustIsValid = trustIsValid(serverTrust)
		case let .performRevokedEvaluation(validateHost, revocationFlags):
			let defaultPolicy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
			let revokedPolicy = SecPolicyCreateRevocation(revocationFlags)
			SecTrustSetPolicies(serverTrust, [defaultPolicy, revokedPolicy] as CFTypeRef)

			serverTrustIsValid = trustIsValid(serverTrust)
		case let .pinCertificates(pinnedCertificates, validateCertificateChain, validateHost):
			if validateCertificateChain {
				let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
				SecTrustSetPolicies(serverTrust, policy)

				SecTrustSetAnchorCertificates(serverTrust, pinnedCertificates as CFArray)
				SecTrustSetAnchorCertificatesOnly(serverTrust, true)

				serverTrustIsValid = trustIsValid(serverTrust)
			} else {
				let serverCertificatesDataArray = certificateData(for: serverTrust)
				let pinnedCertificatesDataArray = certificateData(for: pinnedCertificates)

				outerLoop: for serverCertificateData in serverCertificatesDataArray {
					for pinnedCertificateData in pinnedCertificatesDataArray {
						if serverCertificateData == pinnedCertificateData {
							serverTrustIsValid = true
							break outerLoop
						}
					}
				}
			}
		case let .pinPublicKeys(pinnedPublicKeys, validateCertificateChain, validateHost):
			var certificateChainEvaluationPassed = true

			if validateCertificateChain {
				let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
				SecTrustSetPolicies(serverTrust, policy)

				certificateChainEvaluationPassed = trustIsValid(serverTrust)
			}

			if certificateChainEvaluationPassed {
				outerLoop: for serverPublicKey in ServerTrustPolicy.publicKeys(for: serverTrust) as [AnyObject] {
					for pinnedPublicKey in pinnedPublicKeys as [AnyObject] {
						if serverPublicKey.isEqual(pinnedPublicKey) {
							serverTrustIsValid = true
							break outerLoop
						}
					}
				}
			}
		case .disableEvaluation:
			serverTrustIsValid = true
		case let .customEvaluation(closure):
			serverTrustIsValid = closure(serverTrust, host)
		}

		return serverTrustIsValid
	}

	// MARK: - Private - Trust Validation

	private func trustIsValid(_ trust: SecTrust) -> Bool {
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

	// MARK: - Private - Certificate Data

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

	// MARK: - Private - Public Key Extraction

	private static func publicKeys(for trust: SecTrust) -> [SecKey] {
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

	private static func publicKey(for certificate: SecCertificate) -> SecKey? {
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
