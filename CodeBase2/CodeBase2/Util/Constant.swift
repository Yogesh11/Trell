//
//  Constant.swift
//
//  Created by Yogesh2 Gupta on 24/11/20.
//  Copyright © 2020. All rights reserved.
//

import Foundation

struct Constant {
    struct CellIdentifier {
        static let kHomeCell  = "FeedCell"
    }
    
    struct XibName {
        static let kXibFeed  = "FeedCell"
    }
    
    struct ErrorMessage {
        static let kGenricErrorTitle    = "Try again!"
        static let kGenericErrorMessage = "Something went wrong. Please try again."
        static let kGenericErrorCode    = "GEC0001"
        static let kMediaAccessTitle    = "Info"
        static let kMediaAccessMsg      = "In order to properly function, please allow photos access."
        static let kMediaErrorCode      = "GEC0002"
    }

    typealias CompletionBlock        = (_ result: Any?   , _ error: SCError?) -> Void
}

