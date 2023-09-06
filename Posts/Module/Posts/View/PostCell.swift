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
        
        label.font = .boldSystemFont(ofSize: Constants.titleLabelFontSize)
        label.numberOfLines = Constants.titleLabelNumberOfLines
        
        return label
    }()
    
    var previewTextLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = Constants.previewTextLabelNumberOfLines
        
        return label
    }()
    
    var likesCountLabel = UILabel()
    
    var datePostedLabel = UILabel()
    
    var expandCollapseButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = Constants.buttonCornerRadius
        
        return button
    }()
    
    var onExpandCollapseButtonTapped: (() -> Void)?
    
    /// Bad code. As cell's bounds are calculated wrong at cellForRowAt, it needs to know actual width to setup expand/collapse button.
    private(set) var labelsLeadingConstraintConstant: CGFloat = Constants.horizontalSpacing * 3
    private(set) var labelsTrailingConstraintConstant: CGFloat = Constants.horizontalSpacing * -3
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
        
        layoutTitleLabel()
        layoutPreviewTextLabel()
        layoutLikesCountLabel()
        layoutDatePostedLabel()
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
        
        previewTextLabel.numberOfLines = Constants.previewTextLabelNumberOfLines
        
        finalBottomConstraint.isActive = false
        finalBottomConstraint = likesCountLabel
            .bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor,
                        constant: Constants.verticalSpacing * -2)
        finalBottomConstraint.isActive = true
        
        expandCollapseButton.removeFromSuperview()
    }
    
    func setupUI(expanded: Bool) {
        if expanded {
            previewTextLabel.numberOfLines = Constants.previewTextLabelNumberOfLinesToExpand
        }
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
                .constraint(equalTo: contentView.bottomAnchor,
                            constant: Constants.verticalSpacing * -2)
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
            expandCollapseButton.setTitle(Constants.buttonCollapseTitle, for: .normal)
        } else {
            expandCollapseButton.setTitle(Constants.buttonExpandTitle, for: .normal)
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
                .constraint(equalTo: contentView.topAnchor,
                            constant: Constants.verticalSpacing),
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
                .constraint(equalTo: titleLabel.bottomAnchor,
                            constant: Constants.verticalSpacing),
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
                .constraint(equalTo: previewTextLabel.bottomAnchor,
                            constant: Constants.verticalSpacing * 2),
            likesCountLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: labelsLeadingConstraintConstant)
        ])
        
        finalBottomConstraint = likesCountLabel
            .bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor,
                        constant: Constants.verticalSpacing * -2)
        
        //Lowering final bottom constraint priority fixes conflicting constraints warning UIKit bug
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
                .constraint(equalTo: likesCountLabel.bottomAnchor,
                            constant: Constants.verticalSpacing * 2),
            expandCollapseButton
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: Constants.horizontalSpacing * 2),
            expandCollapseButton
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: Constants.horizontalSpacing * -2),
            expandCollapseButton
                .heightAnchor
                .constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
}

// MARK: - Constants

private extension PostCell {
    
    enum Constants {
        
        static let titleLabelFontSize: CGFloat = 20
        static let titleLabelNumberOfLines: Int = 0
        
        static let previewTextLabelNumberOfLines: Int = 2
        static let previewTextLabelNumberOfLinesToExpand: Int = 0
        
        static let buttonCornerRadius: CGFloat = 10
        static let buttonHeight: CGFloat = 50
        static let buttonExpandTitle = "Expand"
        static let buttonCollapseTitle = "Collapse"
        
        static let verticalSpacing: CGFloat = 8
        static let horizontalSpacing: CGFloat = 8
        
    }
    
}
