//
//  Extensions.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/21/23.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeading: CGFloat = 0, paddingBottom: CGFloat = 0, paddingTrailing: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func fillSuperView(inView view: UIView) {
        anchor(top: view.safeAreaLayoutGuide.topAnchor,
               leading: view.safeAreaLayoutGuide.leadingAnchor,
               bottom: view.safeAreaLayoutGuide.bottomAnchor,
               trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}

extension UITextField {
    func makeTextField(placeholder: String, isSecureField: Bool) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .bezel
        tf.textColor = .black
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.darkGray])
        tf.isSecureTextEntry = isSecureField
        return tf
    }
}

extension UILabel {
    func makeLabel(withText text: String? = nil, textColor: UIColor, withFont font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        //label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }
    
    func titleLabel(withText text: String? = nil) -> UILabel {
        return makeLabel(withText: text, textColor: .label, withFont: .boldSystemFont(ofSize: 22))
    }
    
    func headlineLabel(withText text: String? = nil) -> UILabel {
        return makeLabel(withText: text, textColor: .label, withFont: .boldSystemFont(ofSize: 20))
    }
    
    func makebodyLabel(withText text: String? = nil) -> UILabel {
        return makeLabel(withText: text, textColor: .label, withFont: .systemFont(ofSize: 18))
    }
    
    func headerTextLabel(withText text: String? = nil) -> UILabel {
        return makeLabel(withText: text, textColor: .white, withFont: .boldSystemFont(ofSize: 16))
    }
}

extension UIButton {
    func makeButton(withTitle title: String? = nil, withImage image: UIImage? = nil, titleColor: UIColor? = nil, buttonColor: UIColor? =  nil, isRounded: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setImage(image, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius =  isRounded ? 10: 0
        
        
        return button
    }
}

extension UIColor {
    static func setRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static var mainBlue: UIColor {
        return UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    static var purple: UIColor {
        return UIColor.setRGB(red: 98, green: 0, blue: 238)
    }
    
    static var pink: UIColor {
        return UIColor.setRGB(red: 255, green: 148, blue: 194)
    }
    
    static var teal: UIColor {
        return UIColor.setRGB(red: 3, green: 218, blue: 197)
    }
}

extension Decimal {
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currency
        return formatter
    }
    
    func toCurrency() -> String {
        return numberFormatter.string(for: self) ?? "$1.00"
    }
}

extension TimeInterval {
    var dateFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        return formatter
    }
    
    func toTime() -> String {
        return dateFormatter.string(from: self) ?? "1:11"
    }
}

extension Float {
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .percent
        return formatter
    }
    
    func toPercent() -> String {
        return numberFormatter.string(for: self) ?? "0%"
    }
}
