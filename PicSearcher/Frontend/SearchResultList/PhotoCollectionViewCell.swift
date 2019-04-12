//
//  PhotoCollectionViewCell.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import UIKit
import SDWebImage

struct PhotoCollectionViewCellUX {
    static let ImageViwePlaceHolder = "imageViewPlaceholder"
}
class PhotoCollectionViewCell: UICollectionViewCell {
    var photo: FlickrSearchApiResponseModel.Photos.PhotoModel? {
        didSet {
            if let urlStr = photo?.imageThumbUrl, let url = URL(string: urlStr) {
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: PhotoCollectionViewCellUX.ImageViwePlaceHolder))
            }
        }
    }
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit() {
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.contentView.safeAreaLayoutGuide)
        }
    }
}
