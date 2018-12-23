//
//  NetworkTask.swift
//  Avenue
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//
//	See this blog post for more information why are these extensions needed:
//	http://aplus.rs/2017/urlsession-in-operation/

import Foundation

extension URLSessionTask {
	public typealias NetworkTaskErrorCallback = (NetworkError) -> Void
	public typealias NetworkTaskResponseCallback = (HTTPURLResponse) -> Void
	public typealias NetworkTaskDataCallback = (Data) -> Void
	public typealias NetworkTaskFinishCallback = () -> Void


	private struct AssociatedKeys {
		static var error 	= "Error"
		static var response = "Response"
		static var data 	= "Data"
		static var finish 	= "Finish"
	}

	public var errorCallback: NetworkTaskErrorCallback {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.error) as? NetworkTaskErrorCallback ?? {_ in}
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.error, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}

	public var responseCallback: NetworkTaskResponseCallback {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.response) as? NetworkTaskResponseCallback ?? {_ in}
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.response, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}

	public var dataCallback: NetworkTaskDataCallback {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.data) as? NetworkTaskDataCallback ?? {_ in}
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.data, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}

	public var finishCallback: NetworkTaskFinishCallback {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.finish) as? NetworkTaskFinishCallback ?? {}
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.finish, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
}
