//
//  NetworkSession.swift
//  Avenue
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//
//	Relevant documentation:
//	(1) ATS (Advanced Transport Security):
//	https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33
//	(2) TN2232: HTTPS Server Trust Evaluation
//	https://developer.apple.com/library/content/technotes/tn2232/
//
//	Helpful articles:
//	https://www.nowsecure.com/blog/2017/08/31/security-analysts-guide-nsapptransportsecurity-nsallowsarbitraryloads-app-transport-security-ats-exceptions/
//	https://github.com/Alamofire/Alamofire#app-transport-security
//	https://github.com/Alamofire/Alamofire/issues/876
//	https://infinum.co/the-capsized-eight/how-to-make-your-ios-apps-more-secure-with-ssl-pinning
//
//	Tools:
//	https://badssl.com
//	nscurl --help (in your macOS Terminal)



import Foundation

///	Base class that handles URLSession-level stuff. Subclass it to build your API / web-endpoint wrapper.
///
///	This is very shallow class; its purpose is to handle Authentication challenges, but due to
///	general URLSession/DataTask architecture, it also must handle the task-level URLSessionDelegate methods.
///
///	This is accomplished by forcefully expanding URLSessionDataTask, see NetworkTask.swift
///
///	Auth challenges like ServerTrust will be automatically handled, using URLSession.serverTrustPolicy value (defined elsewhere).
///	`userCancelledAuthentication` error will be returned if evaluation fails.
class NetworkSession: NSObject {
	var urlSessionConfiguration: URLSessionConfiguration
	var urlSession: URLSession!

	private override init() {
		fatalError("Must use `init(urlSessionConfiguration:)")
	}

	init(urlSessionConfiguration: URLSessionConfiguration = .default) {
		self.urlSessionConfiguration = urlSessionConfiguration
		super.init()

		urlSession = URLSession(configuration: urlSessionConfiguration,
								delegate: self,
								delegateQueue: nil)
	}

	deinit {
		//	this cancels immediatelly
//		urlSession.invalidateAndCancel()
		//	this will allow background tasks to finish-up first
		urlSession.finishTasksAndInvalidate()
	}
}

extension NetworkSession: URLSessionDataDelegate {
	//	MARK: Authentication callbacks

	func urlSession(_ session: URLSession,
					didReceive challenge: URLAuthenticationChallenge,
					completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
	{
		handleURLSession(session, task: nil, didReceive: challenge, completionHandler: completionHandler)
	}

	func urlSession(_ session: URLSession,
					task: URLSessionTask,
					didReceive challenge: URLAuthenticationChallenge,
					completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
	{
		handleURLSession(session, task: task as? URLSessionDataTask, didReceive: challenge, completionHandler: completionHandler)
	}

	private func handleURLSession(_ session: URLSession,
									 task: URLSessionDataTask?,
									 didReceive challenge: URLAuthenticationChallenge,
									 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
	{
		if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
			guard let trust = challenge.protectionSpace.serverTrust else {
				completionHandler(.performDefaultHandling, nil)
				return
			}
			let host = challenge.protectionSpace.host

			guard session.serverTrustPolicy.evaluate(trust, forHost: host) else {
				completionHandler(.rejectProtectionSpace, nil)

				if let dataTask = task {
					let authError = NetworkError.urlError( NSError(domain: NSURLErrorDomain,
																   code: URLError.userCancelledAuthentication.rawValue,
																   userInfo: nil) as? URLError )
					dataTask.errorCallback(authError)
				}
				return
			}

			let credential = URLCredential(trust: trust)
			completionHandler(.useCredential, credential)
			return
		}

		completionHandler(.performDefaultHandling, nil)
	}

	//	MARK: Data callbacks

	//	this checks the response headers
	final func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		guard let httpResponse = response as? HTTPURLResponse else {
			completionHandler(.cancel)
			dataTask.errorCallback(.invalidResponse)
			return
		}

		dataTask.responseCallback(httpResponse)

		//	always allow data to arrive in order to
		//	extract possible API error messages
		completionHandler(.allow)
	}

	//	this will be called multiple times while the data is coming in
	final func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		dataTask.dataCallback(data)
	}

	final func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
		guard let dataTask = task as? URLSessionDataTask else { return }

		if let e = error {
			dataTask.errorCallback( .urlError(e as? URLError) )
			return
		}
		dataTask.finishCallback()
	}
}

