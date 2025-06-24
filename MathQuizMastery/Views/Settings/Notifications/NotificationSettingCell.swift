//
//  NotificationSettingCell.swift
//  MathQuizMastery
//
//  Created by System on 19.06.2025.
//

import UIKit

protocol NotificationSettingCellDelegate: AnyObject {
    func notificationSettingCell(_ cell: NotificationSettingCell, didToggle isEnabled: Bool, for setting: NotificationSetting)
    func notificationSettingCell(_ cell: NotificationSettingCell, didTapInfo setting: NotificationSetting)
}

class NotificationSettingCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Properties
    weak var delegate: NotificationSettingCellDelegate?
    private var setting: NotificationSetting?
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        self.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setting = nil
        delegate = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        setupContainerView()
        setupLabels()
        setupSwitch()
        setupButtons()
        setupImageView()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.Custom.settingBorderInactive.cgColor
        
        // Shadow
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.masksToBounds = false
    }
    
    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.Custom.settingTitle
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = UIColor.Custom.settingDescription
        descriptionLabel.numberOfLines = 2
        
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = UIColor.Custom.settingTime
        timeLabel.isHidden = true
    }
    
    private func setupSwitch() {
        toggleSwitch.onTintColor = UIColor.Custom.settingSwitchOn
        toggleSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    private func setupButtons() {
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.tintColor = UIColor.Custom.settingIcon
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    private func setupImageView() {
        iconImageView.tintColor = UIColor.Custom.settingIcon
        iconImageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - Configuration
    func configure(with setting: NotificationSetting) {
        self.setting = setting
        
        titleLabel.text = setting.title
        descriptionLabel.text = setting.description
        toggleSwitch.isOn = setting.isEnabled
        
        iconImageView.image = UIImage(systemName: setting.icon)
        
        if let defaultTime = setting.defaultTime {
            timeLabel.text = defaultTime
            timeLabel.isHidden = false
            timeLabel.numberOfLines = 1
            timeLabel.textAlignment = .right
        } else {
            timeLabel.isHidden = true
        }
        
        updateAppearance()
    }
    
    func setEnabled(_ enabled: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.toggleSwitch.setOn(enabled, animated: true)
                self.updateAppearance()
            }
        } else {
            toggleSwitch.setOn(enabled, animated: false)
            updateAppearance()
        }
    }
    
    private func updateAppearance() {
        let isEnabled = toggleSwitch.isOn
        let alpha: CGFloat = isEnabled ? 1.0 : 0.6
        
        titleLabel.alpha = alpha
        descriptionLabel.alpha = alpha
        iconImageView.alpha = alpha
        timeLabel.alpha = alpha
        
        containerView.layer.borderColor = isEnabled ?
        UIColor.Custom.settingBorderActive.cgColor :
        UIColor.Custom.settingBorderInactive.cgColor
    }
    
    // MARK: - Actions
    @objc private func switchValueChanged() {
        guard let setting = setting else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        updateAppearance()
        delegate?.notificationSettingCell(self, didToggle: toggleSwitch.isOn, for: setting)
    }
    
    @objc private func infoButtonTapped() {
        guard let setting = setting else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        delegate?.notificationSettingCell(self, didTapInfo: setting)
    }
}

// MARK: - Animation Extensions
extension NotificationSettingCell {
    func animateSelection() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
}
