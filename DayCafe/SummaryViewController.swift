import UIKit

class SummaryViewController: UIViewController {

    var tableNumber: Int!

    @IBOutlet weak var tableNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(tableNumber == 35537){
            tableNumberLabel.text = "Azul";
        } else if(tableNumber == 35538){
            tableNumberLabel.text = "Morada";
        } else {
            tableNumberLabel.text = String(tableNumber)
        }
        
    }
}
