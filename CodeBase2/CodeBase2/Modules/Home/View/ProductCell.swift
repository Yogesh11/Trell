//
//  ProductCell.swift
//  CodeBase2
//
//  Created by Yogesh2 Gupta on 24/11/20.
//

import UIKit
import Photos

@objc protocol ProductCellDelegate : class{
    func bookMarkClicked(cell : ProductCell)
}

class ProductCell: UITableViewCell {
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    weak var delegate : ProductCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rootView.layer.applySketchShadow(color: .black, alpha: 0.16, x: 0, y: 2, blur: 4, spread: 0)
        rootView.layer.cornerRadius = 8
        rootView.layer.borderWidth = 1.0
        rootView.layer.borderColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 0.2).cgColor
    }
    
    @IBAction func bookMarkButtonTouched(_ sender: Any) {
        delegate?.bookMarkClicked(cell: self)
    }
    
    func updateCell(_ asset : PHAsset) {
        productImage.image = nil
        weak var weakSelf :ProductCell?  = self
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, userInfo) in
            weakSelf?.productImage.image = image
            weakSelf?.itemTitle.text = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
            print("asset identifier : \(asset.localIdentifier)  text : \(String(describing: weakSelf?.itemTitle.text))")
            let isSelected = UserDefault.shareInstance.getDataForKey(asset.localIdentifier)
            let titleColor : UIColor = isSelected ? .systemGreen : .systemBlue
            self.bookMarkButton.setTitleColor(titleColor , for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
