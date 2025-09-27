//
//  FSPagerViewCell.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//


open class FSPagerViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    @objc
    open var textLabel: UILabel? {
        if let _ = _textLabel {
            return _textLabel
        }
        let containerView = UIView(frame: .zero)
        containerView.isUserInteractionEnabled = false
        
        let textLabel = UILabel(frame: .zero)
        textLabel.textColor = .white
//        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        textLabel.applyCustomFont(18)
        textLabel.numberOfLines = 1
        
        self.contentView.addSubview(containerView)
        containerView.addSubview(textLabel)
        setBlackGradientBackground(view: containerView)
        
        textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)
        
        _textLabel = textLabel
        _textContainer = containerView
        return textLabel
    }
    
    /// New description label
    @objc
    open var descriptionLabel: UILabel? {
        if let _ = _descriptionLabel {
            return _descriptionLabel
        }
        guard let containerView = _textContainer else {
            return nil
        }
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        descriptionLabel.applyCustomFont(10)
//        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.numberOfLines = 2
        containerView.addSubview(descriptionLabel)
        
        _descriptionLabel = descriptionLabel
        return descriptionLabel
    }
    
    @objc
    open var imageView: UIImageView? {
        if let _ = _imageView {
            return _imageView
        }
        let imageView = UIImageView(frame: .zero)
        self.contentView.addSubview(imageView)
        _imageView = imageView
        return imageView
    }
    
    // MARK: - Private Properties
    
    fileprivate weak var _textLabel: UILabel?
    fileprivate weak var _descriptionLabel: UILabel?
    fileprivate weak var _imageView: UIImageView?
    fileprivate weak var _textContainer: UIView?
    
    fileprivate let kvoContext = UnsafeMutableRawPointer(bitPattern: 0)
    fileprivate let selectionColor = UIColor(white: 0.2, alpha: 0.2)
    
    fileprivate weak var _selectedForegroundView: UIView?
    
    // MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 5
        self.contentView.layer.shadowOpacity = 0.75
        self.contentView.layer.shadowOffset = .zero
    }
    
    deinit {
        if let textLabel = _textLabel {
            textLabel.removeObserver(self, forKeyPath: "font", context: kvoContext)
        }
    }
    
    // MARK: - Layout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let imageView = _imageView {
            imageView.frame = self.contentView.bounds
        }
        
        if let containerView = _textContainer,
           let textLabel = _textLabel {
            containerView.frame = {
                var rect = self.contentView.bounds
                let height = textLabel.font.pointSize * 4 // give extra space for description
                rect.size.height = height
                rect.origin.y = self.contentView.frame.height - height
                return rect
            }()
            
            textLabel.frame = {
                var rect = containerView.bounds
                rect = rect.insetBy(dx: 10, dy: 0)
                rect.size.height = textLabel.font.lineHeight
//                rect.origin.y += 5
                return rect
            }()
            
            if let descriptionLabel = _descriptionLabel {
                descriptionLabel.frame = {
                    var rect = containerView.bounds
                    rect = rect.insetBy(dx: 10, dy: 0)
                    rect.origin.y = textLabel.frame.maxY - 8
                    rect.size.height = descriptionLabel.font.lineHeight * 2
                    return rect
                }()
            }
        }
        
        if let selectedForegroundView = _selectedForegroundView {
            selectedForegroundView.frame = self.contentView.bounds
        }
    }
    
    // MARK: - Helpers
    
    func setBlackGradientBackground(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(1).cgColor,
            UIColor.black.withAlphaComponent(1).cgColor,
            UIColor.black.withAlphaComponent(1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)   // Top center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)     // Bottom center
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UILabel {
    func applyCustomFont(_ fontSize: CGFloat) {
        let customFontName = "FFShamelFamily-SansOneBook"
        
        let newFont = UIFont(name: customFontName, size: fontSize)
        self.font = newFont
    }
}


//import UIKit
//
//open class FSPagerViewCell: UICollectionViewCell {
//    
//    /// Returns the label used for the main textual content of the pager view cell.
//    @objc
//    open var textLabel: UILabel? {
//        if let _ = _textLabel {
//            return _textLabel
//        }
//        let view = UIView(frame: .zero)
//        view.isUserInteractionEnabled = false
////        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        
//        let textLabel = UILabel(frame: .zero)
//        textLabel.textColor = .white
//        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
//        self.contentView.addSubview(view)
//        view.addSubview(textLabel)
//        setBlackGradientBackground(view: view)
//        
//        textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)
//        
//        _textLabel = textLabel
//        return textLabel
//    }
//    
//    /// Returns the image view of the pager view cell. Default is nil.
//    @objc
//    open var imageView: UIImageView? {
//        if let _ = _imageView {
//            return _imageView
//        }
//        let imageView = UIImageView(frame: .zero)
//        self.contentView.addSubview(imageView)
//        _imageView = imageView
//        return imageView
//    }
//    
//    fileprivate weak var _textLabel: UILabel?
//    fileprivate weak var _imageView: UIImageView?
//    
//    fileprivate let kvoContext = UnsafeMutableRawPointer(bitPattern: 0)
//    fileprivate let selectionColor = UIColor(white: 0.2, alpha: 0.2)
//    
//    fileprivate weak var _selectedForegroundView: UIView?
//    fileprivate var selectedForegroundView: UIView? {
//        guard _selectedForegroundView == nil else {
//            return _selectedForegroundView
//        }
//        guard let imageView = _imageView else {
//            return nil
//        }
//        let view = UIView(frame: imageView.bounds)
//        imageView.addSubview(view)
//        _selectedForegroundView = view
//        return view
//    }
//    
//    open override var isHighlighted: Bool {
//        set {
//            super.isHighlighted = newValue
//            if newValue {
//                self.selectedForegroundView?.layer.backgroundColor = self.selectionColor.cgColor
//            } else if !super.isSelected {
//                self.selectedForegroundView?.layer.backgroundColor = UIColor.clear.cgColor
//            }
//        }
//        get {
//            return super.isHighlighted
//        }
//    }
//    
//    open override var isSelected: Bool {
//        set {
//            super.isSelected = newValue
//            self.selectedForegroundView?.layer.backgroundColor = newValue ? self.selectionColor.cgColor : UIColor.clear.cgColor
//        }
//        get {
//            return super.isSelected
//        }
//    }
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    
//    fileprivate func commonInit() {
//        self.contentView.backgroundColor = UIColor.clear
//        self.backgroundColor = UIColor.clear
//        self.contentView.layer.shadowColor = UIColor.black.cgColor
//        self.contentView.layer.shadowRadius = 5
//        self.contentView.layer.shadowOpacity = 0.75
//        self.contentView.layer.shadowOffset = .zero
//    }
//    
//    deinit {
//        if let textLabel = _textLabel {
//            textLabel.removeObserver(self, forKeyPath: "font", context: kvoContext)
//        }
//    }
//    
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//        if let imageView = _imageView {
//            imageView.frame = self.contentView.bounds
//        }
//        if let textLabel = _textLabel {
//            textLabel.superview!.frame = {
//                var rect = self.contentView.bounds
//                let height = textLabel.font.pointSize * 5
//                rect.size.height = height
//                rect.origin.y = self.contentView.frame.height-height
//                return rect
//            }()
//            textLabel.frame = {
//                var rect = textLabel.superview!.bounds
//                rect = rect.insetBy(dx: 10, dy: 0)
//                rect.size.height -= 1
//                rect.origin.y += 15
//                return rect
//            }()
//        }
//        if let selectedForegroundView = _selectedForegroundView {
//            selectedForegroundView.frame = self.contentView.bounds
//        }
//    }
//
//    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if context == kvoContext {
//            if keyPath == "font" {
//                self.setNeedsLayout()
//            }
//        } else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//        }
//    }
//    
//    func setBlackGradientBackground(view: UIView) {
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.frame = bounds
//            gradientLayer.colors = [
//                UIColor.black.withAlphaComponent(0).cgColor,
//                UIColor.black.withAlphaComponent(1).cgColor,
//                UIColor.black.withAlphaComponent(1).cgColor
//            ]
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)   // Top center
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)     // Bottom center
//            view.layer.insertSublayer(gradientLayer, at: 0)
//        }
//    
//}
