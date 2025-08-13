//
//  TicketCell.swift
//  maGmayApp
//
//  Created by ezz on 23/05/2025.
//
import UIKit

class TicketCell: UICollectionViewCell {
    
    static let identifier = "TicketCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ticketNumberLabel = TicketLabel(title: "رقم التذكرة", value: "#24567")
    private let statusLabel = TicketLabel(title: "الحالة", value: "قيد المعالجة", isBold: true)
    private let dateLabel = TicketLabel(title: "تاريخ الطلب", value: "25 سبتمبر 2024")

    private let lastReplyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "آخر رد:"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .right
        label.textColor = .darkGray
        return label
    }()

    private let replyLabel: UILabel = {
        let label = UILabel()
        label.text = "تم تحويل طلبك إلى فريق الصيانة، وسيتم التواصل معك قريباً."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()

    private let warningIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        iv.tintColor = .systemOrange
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(containerView)
        
        let topRow = UIStackView(arrangedSubviews: [ticketNumberLabel, statusLabel, dateLabel])
        topRow.axis = .horizontal
        topRow.distribution = .fillEqually
        topRow.spacing = 8
        topRow.translatesAutoresizingMaskIntoConstraints = false

        let replyRow = UIStackView(arrangedSubviews: [replyLabel, warningIcon])
        replyRow.axis = .horizontal
        replyRow.alignment = .top
        replyRow.spacing = 6
        replyRow.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(topRow)
        containerView.addSubview(lastReplyTitleLabel)
        containerView.addSubview(replyRow)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            topRow.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            topRow.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            topRow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            lastReplyTitleLabel.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 12),
            lastReplyTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            replyRow.topAnchor.constraint(equalTo: lastReplyTitleLabel.bottomAnchor, constant: 4),
            replyRow.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            replyRow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            replyRow.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            warningIcon.widthAnchor.constraint(equalToConstant: 18),
            warningIcon.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
}
class TicketLabel: UIView {
    init(title: String, value: String, isBold: Bool = false) {
        super.init(frame: .zero)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = isBold ? .boldSystemFont(ofSize: 15) : .systemFont(ofSize: 15)
        valueLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
