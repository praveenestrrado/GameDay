//
//  PaymentFirst3TableViewCell.swift
//  GameDay
//
//  Created by MAC on 05/01/21.
//

import UIKit

class PaymentFirst3TableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
//    let datePickerView:UIDatePicker = UIDatePicker()
//    let datePickerViewForDemo:UIDatePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtCardNumber.inputAccessoryView = numberToolbar
        txtCVV.inputAccessoryView = numberToolbar

        
        txtCardNumber.delegate = self
        txtCVV.delegate = self

        txtExpDate.attributedPlaceholder = NSAttributedString(string: "Expiry Date (mm/yy)",
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
              txtCardHolderName.attributedPlaceholder = NSAttributedString(string: "Card Holder Name",
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
              txtCardNumber.attributedPlaceholder = NSAttributedString(string: "Card Number",
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
              txtCVV.attributedPlaceholder = NSAttributedString(string: "CVV",
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

//        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//              numberToolbar.barStyle = .default
//              numberToolbar.items = [
//                  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
//                  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//                  UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
//              numberToolbar.sizeToFit()
//
//              txtExpDate.inputAccessoryView = numberToolbar
//              datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
//              txtExpDate.inputView = datePickerViewForDemo
//              datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
//
//              datePickerViewForDemo.minimumDate = NSDate() as Date
      
              
      
    }
    @objc func cancelNumberPad() {
           //Cancel with number pad
           txtCVV.resignFirstResponder()
        txtCardNumber.resignFirstResponder()

       }
       @objc func doneWithNumberPad() {
           //Done with number pad
        txtCVV.resignFirstResponder()
     txtCardNumber.resignFirstResponder()

       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == txtCardNumber {
                return formatCardNumber(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
            }
        
            else if textField ==  txtCVV{
                         let char = string.cString(using: String.Encoding.utf8)
                         let isBackSpace = strcmp(char, "\\b")
                         if isBackSpace == -92 {
                             return true
                         }
                         return textField.text!.count <= 2
                     }
            return true
        }


        func formatCardNumber(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            if textField == txtCardNumber {
                let replacementStringIsLegal = string.rangeOfCharacter(from: NSCharacterSet(charactersIn: "0123456789").inverted) == nil

                if !replacementStringIsLegal {
                    return false
                }

                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let components = newString.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted)
                let decimalString = components.joined(separator: "") as NSString
                let length = decimalString.length
                let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)

                if length == 0 || (length > 16 && !hasLeadingOne) || length > 19 {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

                    return (newLength > 16) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()

                if hasLeadingOne {
                    formattedString.append("1 ")
                    index += 1
                }
                if length - index > 4 {
                    let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
                    formattedString.appendFormat("%@ ", prefix)
                    index += 4
                }

                if length - index > 4 {
                    let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
                    formattedString.appendFormat("%@ ", prefix)
                    index += 4
                }
                if length - index > 4 {
                    let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
                    formattedString.appendFormat("%@ ", prefix)
                    index += 4
                }

                let remainder = decimalString.substring(from: index)
                formattedString.append(remainder)
                textField.text = formattedString as String
                return false
            }
           
            
            else {
                return true
            }
        }
    
}
