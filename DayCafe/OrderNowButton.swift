import UIKit

@IBDesignable class OrderNowButton: UIButton {

    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(ctx);
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextSetShadow(ctx, CGSizeMake(0.0, 0.0), 4.0);
        CGContextFillEllipseInRect(ctx, CGRectMake(rect.origin.x + 2.0, rect.origin.y + 2.0, rect.size.width - 4.0, rect.size.height - 4.0));
        UIGraphicsPopContext();

        super.drawRect(rect)
    }
}
