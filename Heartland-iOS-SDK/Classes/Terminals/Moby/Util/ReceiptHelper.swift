import UIKit

class ReceiptHelper {
    
    static let fontSize: CGFloat = 20.0
    static let fontSizeLarge: CGFloat = 26.0
    static var margin: CGFloat = 30.0
    
    static func createReceiptImage(transaction: HpsTerminalResponse) -> UIImage {
        let width: CGFloat = 550
        let height: CGFloat = 550
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let image = renderer.image { ctx in
            let canvas = ctx.cgContext
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let textFontAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            
            // Draw the background
            canvas.setFillColor(UIColor.white.cgColor)
            canvas.fill(CGRect(x: 0, y: 0, width: width, height: height))
            
            // Draw the header
            let headerFontAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSizeLarge),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            "HPS Test".draw(in: CGRect(x: 0, y: margin, width: width, height: fontSizeLarge), withAttributes: headerFontAttributes)
            "1 Heartland Way".draw(in: CGRect(x: 0, y: margin + 10 + fontSizeLarge, width: width, height: fontSize), withAttributes: textFontAttributes)
            "Jeffersonville, IN 47136".draw(in: CGRect(x: 0, y: margin + 20 + fontSize * 2, width: width, height: fontSize), withAttributes: textFontAttributes)
            "888-798-3133".draw(in: CGRect(x: 0, y: margin + 25 + fontSize * 3, width: width, height: fontSize), withAttributes: textFontAttributes)
            
            
            // Draw date and time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let date = transaction.rspDT != nil ? dateFormatter.string(from: Date()) : dateFormatter.string(from: Date())
            date.draw(in: CGRect(x: margin - 20, y: margin + 10 + fontSize * 5, width: width / 2, height: fontSize), withAttributes: textFontAttributes)
            
            dateFormatter.dateFormat = "hh:mm a"
            let time = dateFormatter.string(from: Date())
            let rightAlignedParagraphStyle = NSMutableParagraphStyle()
            rightAlignedParagraphStyle.alignment = .right
            let rightAlignedTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: UIColor.black,
                .paragraphStyle: rightAlignedParagraphStyle
            ]
            margin = margin + 10
            time.draw(in: CGRect(x: -margin, y: margin + fontSize * 5, width: width - margin, height: fontSize), withAttributes: rightAlignedTextAttributes)
            
            margin = margin + 20
            
            // Draw transaction type
            let centeredParagraphStyle = NSMutableParagraphStyle()
            centeredParagraphStyle.alignment = .center
            let centeredTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSizeLarge),
                .foregroundColor: UIColor.black,
                .paragraphStyle: centeredParagraphStyle
            ]
            "CREDIT CARD".draw(in: CGRect(x: 0, y: margin + fontSize * 6, width: width, height: fontSizeLarge), withAttributes: centeredTextAttributes)
            transaction.transactionType.draw(in: CGRect(x: 0, y: margin + 10 + fontSize * 7, width: width, height: fontSizeLarge), withAttributes: centeredTextAttributes)
            
            // Draw detail list
            var yOffset = margin + fontSize * 9
            let leftAlignedParagraphStyle = NSMutableParagraphStyle()
            leftAlignedParagraphStyle.alignment = .left
            let leftAlignedTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: UIColor.black,
                .paragraphStyle: leftAlignedParagraphStyle
            ]
            
            if transaction.entryMode != HpsPaxEntryModes.swipe.rawValue && transaction.entryMode != HpsPaxEntryModes.chipFallBackSwipe.rawValue && transaction.entryMode != HpsPaxEntryModes.unknown.rawValue {
                transaction.cardType.uppercased().draw(in: CGRect(x: margin, y: yOffset, width: width, height: fontSize), withAttributes: leftAlignedTextAttributes)
                yOffset += fontSize
                
                "ACCT:".draw(in: CGRect(x: margin, y: yOffset, width: width, height: fontSize), withAttributes: leftAlignedTextAttributes)
                transaction.maskedCardNumber.draw(in: CGRect(x: 200, y: yOffset, width: width - 200, height: fontSize), withAttributes: leftAlignedTextAttributes)
                yOffset += fontSize
                
                "APP NAME:".draw(in: CGRect(x: margin, y: yOffset, width: width, height: fontSize), withAttributes: leftAlignedTextAttributes)
                transaction.applicationName.draw(in: CGRect(x: 200, y: yOffset, width: width - 200, height: fontSize), withAttributes: leftAlignedTextAttributes)
                yOffset += fontSize
                
                // Continue drawing other details like AID, ARQC, Entry mode, Approval code, and Transaction ID similarly
            }
            // Handle other conditions for entry mode if required

            // Draw total and description
            "DESCRIPTION: Merchandise".draw(in: CGRect(x: margin, y: yOffset + fontSize * 2, width: width, height: fontSize), withAttributes: leftAlignedTextAttributes)
            "TOTAL".draw(in: CGRect(x: margin, y: yOffset + fontSize * 4, width: width, height: fontSizeLarge), withAttributes: leftAlignedTextAttributes)
            
            guard let approvedAmount = transaction.approvedAmount else { return }
            let amountValue = String(format: "%.2f", approvedAmount.doubleValue)
            let totalText = "USD $ \(amountValue)"
            
            totalText.draw(in: CGRect(x: 0, y: yOffset + fontSize * 4, width: width - margin, height: fontSizeLarge), withAttributes: rightAlignedTextAttributes)
           
        }
        
        return image
    }
}
