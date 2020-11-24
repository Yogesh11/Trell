//
//  HomeViewModel.swift
//  CodeBase2
//
//  Created by Yogesh2 Gupta on 24/11/20.
//

import UIKit
import Photos
class HomeViewModel: NSObject {
    var videos  = PHFetchResult<PHAsset>()
    private func fetchVideos(_ closure : Constant.CompletionBlock) {
        let options = PHFetchOptions()
        options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: true) ]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        videos  = PHAsset.fetchAssets(with: options)
        closure("" , nil)
    }
    
    func fetchData(_ closure : @escaping Constant.CompletionBlock){
        DispatchQueue.main.async {[weak self] in
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == PHAuthorizationStatus.authorized) {
                self?.fetchVideos(closure)
            }
            else if (status == PHAuthorizationStatus.denied) {
                closure(nil , SCError(errortitle  : Constant.ErrorMessage.kMediaAccessTitle,
                                      errorMessage: Constant.ErrorMessage.kMediaAccessMsg,
                                      errorCode   : Constant.ErrorMessage.kMediaErrorCode))
            }
            else if (status == PHAuthorizationStatus.notDetermined) {

                // Access has not been determined.
                weak var weakSelf : HomeViewModel? = self
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        weakSelf?.fetchVideos(closure)
                    }
                    else {
                        closure(nil , SCError(errortitle  : Constant.ErrorMessage.kMediaAccessTitle,
                                              errorMessage: Constant.ErrorMessage.kMediaAccessMsg,
                                              errorCode   : Constant.ErrorMessage.kMediaErrorCode))
                    }
                })
           }
        }
        
    }
}
