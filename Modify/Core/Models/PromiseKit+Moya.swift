//
//  PromiseKit+Moya.swift
//  Modify
//
//  Created by Alex Shevlyakov on 18/09/2017.
//  Copyright © 2017 Envent. All rights reserved.
//

import PromiseKit
import Moya

public extension MoyaProvider {
    
    public typealias PendingRequestPromise = (promise: Promise<Moya.Response>, cancellable: Cancellable)
    
    public func request(target: Target,
                        queue: DispatchQueue? = nil,
                        progress: Moya.ProgressBlock? = nil) -> Promise<Moya.Response> {
        return requestCancellable(target: target,
                                  queue: queue,
                                  progress: progress).promise
    }
    
    func requestCancellable(target: Target,
                            queue: DispatchQueue?,
                            progress: Moya.ProgressBlock? = nil) -> PendingRequestPromise {
        let pending = Promise<Moya.Response>.pending()
        let completion = promiseCompletion(fulfill: pending.fulfill, reject: pending.reject)
        let cancellable = request(target, callbackQueue: queue, progress: progress, completion: completion)
        
        return (pending.promise, cancellable)
    }
    
    private func promiseCompletion(fulfill: @escaping (Moya.Response) -> Void,
                                   reject: @escaping (Swift.Error) -> Void) -> Moya.Completion {
        return { result in
            switch result {
            case let .success(response):
                fulfill(response)
            case let .failure(error):
                reject(error)
            }
        }
    }
    
}
