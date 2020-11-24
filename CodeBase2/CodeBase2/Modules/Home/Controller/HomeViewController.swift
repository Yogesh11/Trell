//
//  HomeViewController.swift
//  CodeBase2
//
//  Created by Yogesh2 Gupta on 24/11/20.
//

import UIKit
import SVProgressHUD
import Photos
import AVKit

class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    @IBOutlet weak var tableViewLayout: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchVideos()
    }
    
    private func fetchVideos(){
        SVProgressHUD.show()
        weak var weakSelf : HomeViewController?  = self
        viewModel.fetchData { (obj, error) in
            if let err = error {
                weakSelf?.showAlert(error: err)
            }
            weakSelf?.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    fileprivate func playVideo(asset : PHAsset) {
         guard (asset.mediaType == PHAssetMediaType.video) else {
            return
        }
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (avUrlAsset, audioMix, info) in
            let newAsset = avUrlAsset as! AVURLAsset
            DispatchQueue.main.async {
                let player = AVPlayer(url: newAsset.url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
    }
    private func showAlert(error : SCError){
        let uialert = UIAlertController(title   : error.errortitle,
                                        message : error.errorMessage,
                                  preferredStyle: UIAlertController.Style.alert)
        weak var weakSelf : HomeViewController?  = self
        let action =  UIAlertAction(title: "ALLOW", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            weakSelf?.showAlert(error: error)
        }
        uialert.addAction(action)
        self.present(uialert, animated: true, completion: nil)
    }

}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell {
            cell.tag = indexPath.section
            cell.delegate = self
            cell.updateCell(viewModel.videos[indexPath.section])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    fileprivate func reloadData(){
        tableViewLayout.reloadData()
    }
    
    fileprivate func tableViewSetup(){
        tableViewLayout.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        tableViewLayout.delegate = self
        tableViewLayout.dataSource = self
        tableViewLayout.separatorColor = .clear
        tableViewLayout.separatorStyle = .none
        tableViewLayout.estimatedRowHeight = UITableView.automaticDimension
        tableViewLayout.rowHeight = UITableView.automaticDimension
        tableViewLayout.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.videos.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UIView()
          headerView.backgroundColor = .clear
          return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == viewModel.videos.count - 1 {
            return 8
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(asset: viewModel.videos[indexPath.section])
    }
    
    
}


extension HomeViewController : ProductCellDelegate {
    internal func bookMarkClicked(cell : ProductCell) {
        let asset = viewModel.videos[cell.tag]
        let model = UserDefault.shareInstance
        model.saveData(!model.getDataForKey(asset.localIdentifier), key: asset.localIdentifier)
        reloadData()
    }
}
