import UIKit

@IBDesignable
class CustomTextField: UITextField {

    private let iconImageView = UIImageView()
    private let padding: CGFloat = 8
    private let backgroundView = UIView()
    private let gradientLayer = CAGradientLayer()

    @IBInspectable var iconName: String? {
        didSet {
            updateIcon()
        }
    }

    @IBInspectable var placeholderText: String? {
        didSet {
            updatePlaceholder()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Gradient background
        gradientLayer.colors = UIStyle.textFieldGradientColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = UIStyle.cornerRadius
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        backgroundView.layer.cornerRadius = UIStyle.cornerRadius
        backgroundView.layer.shadowColor = UIStyle.shadowColor.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowRadius = 6
        backgroundView.layer.masksToBounds = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = false
        insertSubview(backgroundView, at: 0)
        sendSubviewToBack(backgroundView)

        // Border & text
        layer.cornerRadius = UIStyle.cornerRadius
        layer.borderWidth = 2
        layer.borderColor = UIStyle.borderDefault.cgColor
        backgroundColor = .clear
        textColor = UIStyle.textColor
        font = UIStyle.textFont
        contentVerticalAlignment = .center

        // Icon
        iconImageView.contentMode = .scaleAspectFit
        updateIcon()
        updatePlaceholder()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
        gradientLayer.frame = backgroundView.bounds
    }

    private func updateIcon() {
        guard let iconName = iconName else {
            leftView = nil
            return
        }
        iconImageView.image = UIImage(systemName: iconName)?.withTintColor(UIStyle.iconColor, renderingMode: .alwaysOriginal)
        iconImageView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        iconImageView.center = CGPoint(x: 19, y: 19)
        container.addSubview(iconImageView)
        leftView = container
        leftViewMode = .always
    }

    private func updatePlaceholder() {
        guard let placeholderText = placeholderText else { return }
        attributedPlaceholder = NSAttributedString(
            string: " \(placeholderText)",
            attributes: [
                .foregroundColor: UIStyle.placeholderColor,
                .font: UIStyle.placeholderFont
            ]
        )
    }

    // Padding for text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 8))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
} 
