//	Picked up from:
//	https://gist.github.com/freedom27/c709923b163e26405f62b799437243f4


import UIKit

extension CAShapeLayer {
	func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
		fillColor = filled ? color.cgColor : UIColor.white.cgColor
		strokeColor = color.cgColor
		path = UIBezierPath(roundedRect: rect, cornerRadius: 3).cgPath
	}
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
	private var badgeLayer: CAShapeLayer? {
		if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
			return b as? CAShapeLayer
		} else {
			return nil
		}
	}

	func setBadge(text: String?, withOffsetFromTopRight offset: CGPoint = CGPoint.zero, color:UIColor = UIColor.red, backgroundColor: UIColor = .red, fontSize: CGFloat = 11)
	{
		badgeLayer?.removeFromSuperlayer()

		if (text == nil || text == "") {
			return
		}

		addBadge(text: text!, withOffset: offset, color: color, backgroundColor: backgroundColor, fontSize: fontSize, counter: 0)
	}

	private func addBadge(text: String, withOffset offset: CGPoint = CGPoint.zero, color: UIColor = .white, backgroundColor: UIColor = .red, fontSize: CGFloat = 11, counter: Int)
	{
		guard let view = self.customView ?? self.value(forKey: "view") as? UIView else {
			//	nothing to use now, but "view" will appear at some point
			//	so we need to observe for that
			if counter == 5 { return }
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				[weak self] in
				self?.addBadge(text: text, withOffset: offset, color: color, backgroundColor: backgroundColor, fontSize: fontSize, counter: counter+1)
			}
			return
		}

		let font = UIFont.preferredFont(forTextStyle: .caption1)
		let badgeSize = text.size(withAttributes: [NSAttributedString.Key.font: font])

		// Initialize Badge
		let badge = CAShapeLayer()
		let height = badgeSize.height;
		var width = badgeSize.width + 6 /* padding */

		//make sure we have at least a circle
		if (width < height) {
			width = height
		}

		//x position is offset from right-hand side
		let x = view.frame.width - width + offset.x

		let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))

		badge.drawRoundedRect(rect: badgeFrame, andColor: backgroundColor, filled: true)
		view.layer.addSublayer(badge)

		// Initialiaze Badge's label
		let label = CATextLayer()
		label.string = text
		label.alignmentMode = CATextLayerAlignmentMode.center
		label.font = font
		label.fontSize = font.pointSize

		label.frame = badgeFrame
		label.foregroundColor = color.cgColor
		label.backgroundColor = nil
		label.contentsScale = UIScreen.main.scale
		badge.addSublayer(label)

		// Save Badge as UIBarButtonItem property
		objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}

	private func removeBadge() {
		badgeLayer?.removeFromSuperlayer()
	}
}


private var handle2: UInt8 = 0;

extension UIButton {
	private var badgeLayer: CAShapeLayer? {
		if let b: AnyObject = objc_getAssociatedObject(self, &handle2) as AnyObject? {
			return b as? CAShapeLayer
		} else {
			return nil
		}
	}

	func setBadge(text: String?, withOffsetFromTopRight offset: CGPoint = CGPoint.zero, color:UIColor = UIColor.red, backgroundColor: UIColor = .red, fontSize: CGFloat = 11)
	{
		badgeLayer?.removeFromSuperlayer()

		if (text == nil || text == "") {
			return
		}

		addBadge(text: text!, withOffset: offset, color: color, backgroundColor: backgroundColor, fontSize: fontSize, counter: 0)
	}

	private func addBadge(text: String, withOffset offset: CGPoint = CGPoint.zero, color: UIColor = .white, backgroundColor: UIColor = .red, fontSize: CGFloat = 11, counter: Int)
	{
		let view = self

		let font = UIFont.preferredFont(forTextStyle: .caption1)
		let badgeSize = text.size(withAttributes: [NSAttributedString.Key.font: font])

		// Initialize Badge
		let badge = CAShapeLayer()
		let height = badgeSize.height;
		var width = badgeSize.width + 6 /* padding */

		//make sure we have at least a circle
		if (width < height) {
			width = height
		}

		//x position is offset from right-hand side
		let x = view.frame.width - width + offset.x

		let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))

		badge.drawRoundedRect(rect: badgeFrame, andColor: backgroundColor, filled: true)
		view.layer.addSublayer(badge)

		// Initialiaze Badge's label
		let label = CATextLayer()
		label.string = text
		label.alignmentMode = CATextLayerAlignmentMode.center
		label.font = font
		label.fontSize = font.pointSize

		label.frame = badgeFrame
		label.foregroundColor = color.cgColor
		label.backgroundColor = nil
		label.contentsScale = UIScreen.main.scale
		badge.addSublayer(label)

		// Save Badge as UIButton property
		objc_setAssociatedObject(self, &handle2, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}

	private func removeBadge() {
		badgeLayer?.removeFromSuperlayer()
	}
}
