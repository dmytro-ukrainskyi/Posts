//
//  PostCell.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

final class PostCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    // MARK: Public Properties
    
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    var previewTextLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        
        return label
    }()
    
    var likesCountLabel = UILabel()
    
    var datePostedLabel = UILabel()
    
    var expandCollapseButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    var onExpandCollapseButtonTapped: (() -> Void)?
    
    /// Bad code. As cell's bounds are calculated wrong at cellForRowAt, it needs to know actual width to setup expand/collapse button.
    private(set) var labelsLeadingConstraintConstant: CGFloat = 24
    private(set) var labelsTrailingConstraintConstant: CGFloat = -24
    var previewTextLabelExpectedWidth: CGFloat?
    
    // MARK: Private Properties
    
    private var finalBottomConstraint = NSLayoutConstraint()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(previewTextLabel)
        contentView.addSubview(likesCountLabel)
        contentView.addSubview(datePostedLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    override func prepareForReuse() {
        titleLabel.text = nil
        previewTextLabel.text = nil
        likesCountLabel.text = nil
        datePostedLabel.text = nil
        
        previewTextLabel.numberOfLines = 2
        expandCollapseButton.removeFromSuperview()
        layoutLikesCountLabel()
    }
    
    func setupUI(expanded: Bool) {
        if expanded {
            previewTextLabel.numberOfLines = 0
        }
        
        layoutTitleLabel()
        layoutPreviewTextLabel()
        layoutLikesCountLabel()
        layoutDatePostedLabel()
    }
    
    func addExpandCollapseButtonIfNeeded(cellIsExpanded: Bool) {
        guard let previewTextLabelExpectedWidth else { return }
        
        if !previewTextLabel.fits(
            numberOfLines: 2,
            withWidth: previewTextLabelExpectedWidth
        ) {
            contentView.addSubview(expandCollapseButton)
            layoutExpandCollapseButton()
            
            finalBottomConstraint.isActive = false
            finalBottomConstraint = expandCollapseButton
                .bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: -16)
            finalBottomConstraint.isActive = true
        }
        
        setupExpandCollapseButton(cellIsExpanded: cellIsExpanded)
    }
    
    // MARK: - Private Methods
    
    private func setupExpandCollapseButton(cellIsExpanded: Bool) {
        let action = UIAction { [weak self] _ in
            self?.onExpandCollapseButtonTapped?()
        }
        
        if cellIsExpanded {
            expandCollapseButton.setTitle("Collapse", for: .normal)
        } else {
            expandCollapseButton.setTitle("Expand", for: .normal)
        }
        
        expandCollapseButton.addAction(action, for: .touchUpInside)
    }
    
    private func layoutTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel
            .setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        titleLabel
            .setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        NSLayoutConstraint.activate([
            titleLabel
                .topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: labelsLeadingConstraintConstant),
            titleLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: labelsTrailingConstraintConstant)
        ])
    }
    
    private func layoutPreviewTextLabel() {
        previewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        previewTextLabel
            .setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        previewTextLabel
            .setContentHuggingPriority(UILayoutPriority(0), for: .vertical)
        
        NSLayoutConstraint.activate([
            previewTextLabel
                .topAnchor
                .constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            previewTextLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: labelsLeadingConstraintConstant),
            previewTextLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: labelsTrailingConstraintConstant)
        ])
    }
    
    private func layoutLikesCountLabel() {
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likesCountLabel
                .topAnchor
                .constraint(equalTo: previewTextLabel.bottomAnchor, constant: 16),
            likesCountLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: labelsLeadingConstraintConstant)
        ])
        
        //Lowering final bottom constraint priority fixes conflicting constraints warning UIKit bug
        finalBottomConstraint = likesCountLabel
            .bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor, constant: -16)
        
        finalBottomConstraint.priority = UILayoutPriority(999)
        
        finalBottomConstraint.isActive = true
    }
    
    private func layoutDatePostedLabel() {
        datePostedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePostedLabel
                .bottomAnchor
                .constraint(equalTo: likesCountLabel.bottomAnchor),
            datePostedLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: labelsTrailingConstraintConstant)
        ])
    }
    
    private func layoutExpandCollapseButton() {
        expandCollapseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            expandCollapseButton
                .topAnchor
                .constraint(equalTo: likesCountLabel.bottomAnchor, constant: 16),
            expandCollapseButton
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16),
            expandCollapseButton
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -16),
            expandCollapseButton
                .heightAnchor
                .constraint(equalToConstant: 50)
        ])
    }
    
}
