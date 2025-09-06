import UIKit
import Then

final class WeatherImageView: UIView {
  var onDeleteImageButtonTapped: (() -> Void)?
  
  private let imageView = UIImageView().then {
    $0.layer.cornerRadius = 15
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let imageDeleteButton = UIButton().then {
    $0.setImage(.xmark.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    $0.backgroundColor = .black.withAlphaComponent(0.3)
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 16
    $0.isHidden = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setView()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setView()
    setAutoLayout()
  }
  
  private func setView() {
    addSubview(imageView)
    addSubview(imageDeleteButton)
    imageDeleteButton.addTarget(self, action: #selector(onDeleteImage), for: .touchUpInside)
  }
  
  private func setAutoLayout() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: imageView, attribute: .top,      relatedBy: .equal, toItem: self, attribute: .top,      multiplier: 1.0, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .leading,  relatedBy: .equal, toItem: self, attribute: .leading,  multiplier: 1.0, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .bottom,   relatedBy: .equal, toItem: self, attribute: .bottom,   multiplier: 1.0, constant: 0)
    ])
    
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: imageDeleteButton, attribute: .width,    relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 32),
      NSLayoutConstraint(item: imageDeleteButton, attribute: .height,   relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 32),
      NSLayoutConstraint(item: imageDeleteButton, attribute: .top,      relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 12),
      NSLayoutConstraint(item: imageDeleteButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -12),
    ])
  }
  
  func configure(image: UIImage?) {
    imageView.image = image
    imageDeleteButton.isHidden = (image == nil)
  }
  
  @objc private func onDeleteImage() {
    onDeleteImageButtonTapped?()
  }
}
