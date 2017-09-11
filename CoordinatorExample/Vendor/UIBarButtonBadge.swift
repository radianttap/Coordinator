//	Picked up from:
//	https://gist.github.com/freedom27/c709923b163e26405f62b799437243f4


import UIKit

extension CAShapeLayer {
	func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
		fillColor = filled ? color.cgColor : UIColor.white.cgColor
		strokeColor = color.cgColor
		path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
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

	func setBadge(text: String?, withOffsetFromTopRight offset: CGPoint = CGPoint.zero, andColor color:UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 11)
	{
		badgeLayer?.removeFromSuperlayer()

		if (text == nil || text == "") {
			return
		}

		addBadge(text: text!, withOffset: offset, andColor: color, andFilled: filled)
	}

	private func addBadge(text: String, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 11)
	{
		guard let view = self.value(forKey: "view") as? UIView else { return }

		var font = UIFont.systemFont(ofSize: fontSize)

		if #available(iOS 9.0, *) {
			font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFontWeightRegular)
		}

		let badgeSize = text.size(attributes: [NSFontAttributeName: font])

		// Initialize Badge
		let badge = CAShapeLayer()

		let height = badgeSize.height;
		var width = badgeSize.width + 2 /* padding */

		//make sure we have at least a circle
		if (width < height) {
			width = height
		}

		//x position is offset from right-hand side
		let x = view.frame.width - width + offset.x

		let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))

		badge.drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
		view.layer.addSublayer(badge)

		// Initialiaze Badge's label
		let label = CATextLayer()
		label.string = text
		label.alignmentMode = kCAAlignmentCenter
		label.font = font
		label.fontSize = font.pointSize

		label.frame = badgeFrame
		label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
		label.backgroundColor = UIColor.clear.cgColor
		label.contentsScale = UIScreen.main.scale
		badge.addSublayer(label)

		// Save Badge as UIBarButtonItem property
		objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}

	private func removeBadge() {
		badgeLayer?.removeFromSuperlayer()
	}
}
