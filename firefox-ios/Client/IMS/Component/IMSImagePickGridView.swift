//
//  IMSImagePickGridView.swift

import Foundation
import UIKit

/// 图片选取View代理
@objc
public protocol IMSImagePickGridViewDelegte {
    /// 添加图片
    /// - Parameter IMSImagePickGridView: IMSImagePickGridView
    @objc
    optional func addImage(IMSImagePickGridView: IMSImagePickGridView)

    /// 点击图片
    /// - Parameters:
    ///   - IMSImagePickGridView: IMSImagePickGridView
    ///   - index: 点击索引
    @objc
    optional func clickImage(IMSImagePickGridView: IMSImagePickGridView, index: Int)

    /// frame变化
    /// - Parameter IMSImagePickGridView: IMSImagePickGridView
    @objc
    optional func frameChange(IMSImagePickGridView: IMSImagePickGridView)

    ///
    /// - Parameters:
    ///   - IMSImagePickGridView: IMSImagePickGridView
    ///   - count: 当前图片数量
    @objc
    optional func imageCountChange(IMSImagePickGridView: IMSImagePickGridView, count: Int)
}

/// 图片选取View
open class IMSImagePickGridView: UIView {
    // MARK: - 共有属性

    /// 列数
    public var colCount: Int = 4 {
        didSet {
            setNeedsLayout()
        }
    }

    /// 图片数据
    public private(set) var imageList = [PickImageModel]() {
        didSet {
            delegte?.imageCountChange?(IMSImagePickGridView: self, count: imageList.count)
        }
    }

    /// 是否需要图片添加按钮
    public var isNeedAddButton: Bool = true
    /// 是否需要图片删除按钮
    public var isNeedDeleteButton: Bool = true
    /// 图片最大数量
    /// 小于等于0表示没有最大限制
    public var maxImageCount: Int = 3
    /// 代理
    public weak var delegte: IMSImagePickGridViewDelegte?

    // MARK: - 私有属性

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0 // 最小行间距
        layout.minimumInteritemSpacing = 8 // 最小左右间距
        return layout
    }()

    private var collectionView: UICollectionView?
    private var heightConstraint: NSLayoutConstraint?
    private var itemWidth: CGFloat?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let margin = 8 * (colCount - 1)
        itemWidth = (frame.width - CGFloat(margin)) / CGFloat(colCount)
        if layout.itemSize == .zero {
            layout.itemSize = CGSize(width: itemWidth ?? 0, height: itemWidth ?? 0)
        }
        collectionView?.tx.height = frame.height
        collectionView?.tx.width = frame.width
        reloadDataAndFrame()
    }

    private func setupView() {
        layout.itemSize = CGSize.zero
        /// 如果设置frame为空，不会走cellForItemAt代理
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: layout)
        collectionView?.register(IMSImagePickGridViewCell.self, forCellWithReuseIdentifier: IMSImagePickGridViewCell.description())
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = backgroundColor
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        addSubview(collectionView!)
    }

    private func reloadDataAndFrame() {
        let heightInfo = (itemWidth ?? 0) * CGFloat(Int(ceil(Float(showImageCount) / Float(colCount))))
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: heightInfo)
            addConstraint(heightConstraint!)
        }
        collectionView?.reloadData()
        if heightInfo != heightConstraint?.constant {
            heightConstraint!.constant = heightInfo
            setNeedsLayout()
            superview?.layoutIfNeeded()
            delegte?.frameChange?(IMSImagePickGridView: self)
        }
    }
}

// MARK: - 公有方法

extension IMSImagePickGridView {
    /// 删除图片
    /// - Parameter index: 删除图片索引
    public func removeImage(index: Int) {
        imageList.remove(at: index)
        reloadDataAndFrame()
    }

    /// 添加图片
    /// - Parameter imageArr: 图片列表
    public func addImage(imageArr: [PickImageModel]) {
        for item in imageArr {
            if item.id == nil ||
                (item.id != nil && !imageList.compactMap { $0.id }.contains(item.id!)) {
                imageList.append(item)
            }
        }

        if maxImageCount > 0, imageList.count > maxImageCount {
            imageList = Array(imageList.prefix(upTo: maxImageCount))
        }
        reloadDataAndFrame()
    }

    /// 剩余可选最大数量
    public var canPickResidueMaxCount: Int {
        if maxImageCount <= 0 {
            return -1
        } else {
            let count = maxImageCount - imageList.count
            return count < 0 ? 0 : count
        }
    }
}

// MARK: - 私有方法

extension IMSImagePickGridView {
    private var showImageCount: Int {
        if maxImageCount > 0, imageList.count >= maxImageCount {
            return maxImageCount
        } else {
            if isNeedAddButton {
                return imageList.count + 1
            } else {
                return imageList.count
            }
        }
    }
}

// MARK: - 协议

extension IMSImagePickGridView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showImageCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IMSImagePickGridViewCell.description(), for: indexPath) as? IMSImagePickGridViewCell
        if indexPath.item > 0 || imageList.count >= maxImageCount {
            let index = imageList.count >= maxImageCount ? indexPath.item : indexPath.item - 1
            cell?.imageView.image = imageList[index].image
            cell?.deleteButton.isHidden = !isNeedDeleteButton
            if isNeedDeleteButton {
                cell?.deleteButton.addTapGesture { [weak self] _ in
                    self?.removeImage(index: index)
                }
            }
        } else if indexPath.item == 0 && imageList.count < maxImageCount {
            cell?.imageView.image = UIImage(named: "setting_image_add")
            cell?.deleteButton.isHidden = true
        }
        return cell!
    }
}

extension IMSImagePickGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item > 0 || imageList.count >= maxImageCount {
            let index = imageList.count >= maxImageCount ? indexPath.item : indexPath.item - 1
            delegte?.clickImage?(IMSImagePickGridView: self, index: index)
        } else if indexPath.item == 0 && imageList.count < maxImageCount {
            delegte?.addImage?(IMSImagePickGridView: self)
        }
    }
}

/// 文件信息
public class PickImageModel: NSObject {
    /// 图片数据
    public var image: UIImage?
    /// 图片名称
    public var name: String?
    /// 图片尺寸
    public var size: String?
    /// 图片格式
    public var type: String?
    /// id，唯一标志符号
    public var id: String?
    /// 携带数据
    public var data: ImgUploadModel?

    /// 构造函数
    /// - Parameters:
    ///   - image: 图片数据
    public init(image: UIImage?, id: String?, data: ImgUploadModel?) {
        self.image = image
        self.id = id
        self.data = data
    }

    /// 构造函数
    /// - Parameters:
    ///   - image: 图片数据
    ///   - id: id
    public init(image: UIImage?, id: String?) {
        self.image = image
        self.id = id
    }

    /// 构造函数
    /// - Parameters:
    ///   - image: 图片数据
    public init(image: UIImage?) {
        self.image = image
    }
}

public class IMSImagePickGridViewCell: UICollectionViewCell {
    public static var deleteButtonWidth: CGFloat = 14

    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    public lazy var deleteButton: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "setting_image_delete")
        return imageView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(hexString: "#ECF0F7").cgColor
        
        contentView.addSubview(imageView)
  
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.width,
                                 height: frame.height)

        contentView.addSubview(deleteButton)
        deleteButton.frame = CGRect(x: frame.width - 20,
                                    y: 6,
                                    width: IMSImagePickGridViewCell.deleteButtonWidth,
                                    height: IMSImagePickGridViewCell.deleteButtonWidth)
    }
}
