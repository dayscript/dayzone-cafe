import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ESTBeaconManagerDelegate {

    // ----------------------------------------------------------
    // GETTING STARTED CODE starts here
    // ----------------------------------------------------------

    var tableNumber = 0
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "11EFEBC8-CD29-11E3-B415-1A514932AC01"),
        identifier: "EstiCafe")
    
    override func viewDidLoad() {
        //Opt in to be notified upon entering and exiting region
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        beaconManager.delegate = self
        beaconManager.startMonitoringForRegion(beaconRegion)
        beaconManager.requestAlwaysAuthorization()
    }
    
    func placeOrder() {
//        beaconManager.requestWhenInUseAuthorization()
        beaconManager.startRangingBeaconsInRegion(beaconRegion)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! SummaryViewController
        vc.tableNumber = tableNumber
    }

    func beaconManager(manager: AnyObject!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            //if tableNumber > 0 { return }
            if let nearestBeacon = beacons.first as? CLBeacon {
                beaconManager.stopRangingBeaconsInRegion(region)
                tableNumber = nearestBeacon.minor.integerValue
                proceedToSummary()
            }
    }

    // ----------------------------------------------------------
    // GETTING STARTED CODE ends here
    // ----------------------------------------------------------

    //check for region failure
    func beaconManager(manager: AnyObject!, monitoringDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        println("Region did fail: \(manager) \(region) \(error)")
    }
    //checks permission status
    func beaconManager(manager: AnyObject!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Status: \(status)")
    }
    //beacon entered region
    func beaconManager(manager: AnyObject!, didEnterRegion region: CLBeaconRegion!) {
        var notification : UILocalNotification = UILocalNotification()
        notification.alertBody = "Bienvenido al Café Dayzone!"
//        notification.soundName = "Default.mp3"
        println("Enter")
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    //beacon exited region
    func beaconManager(manager: AnyObject!, didExitRegion region: CLBeaconRegion!) {
        var notification : UILocalNotification = UILocalNotification()
        notification.alertBody = "Gracias por visitarnos, regresa pronto!"
//        notification.soundName = "Default.mp3"
        println("Exit")
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }


    // ----------------------------------------------------------
    // MARK: - User interface and actions
    // ----------------------------------------------------------

    @IBOutlet weak var orderNowButton: OrderNowButton!

    @IBAction func orderNowTapped(sender: AnyObject) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("Please Wait") as! UIViewController
        vc.modalPresentationStyle = .OverFullScreen
        vc.modalTransitionStyle = .CrossDissolve
        presentViewController(vc, animated: true) {
            self.placeOrder()
        }
    }

    func proceedToSummary() {
        dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("Order Summary", sender: self)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    var selectedMenuItems = [Int]()

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Menu Item", forIndexPath: indexPath) as! MenuItemCell

        cell.backgroundImageView.image = UIImage(named: "Cell\(indexPath.row + 1)")

        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "Locura verde"
            cell.priceLabel.text = "COP$4.200"
        case 1:
            cell.nameLabel.text = "Explosión de ciruela"
            cell.priceLabel.text = "COP$3.900"
        case 2:
            cell.nameLabel.text = "Arándanos contigo"
            cell.priceLabel.text = "COP$5.300"
        case 3:
            cell.nameLabel.text = "Amor frambuesa"
            cell.priceLabel.text = "COP$4.500"
        default:
            println("Oops.")
        }

        if contains(selectedMenuItems, { $0 == indexPath.row}) {
            cell.overlayView.hidden = false
            cell.accessoryImageView.image = UIImage(named: "Checkmark")
        } else {
            cell.overlayView.hidden = true
            cell.accessoryImageView.image = UIImage(named: "Plus")
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let index = find(selectedMenuItems, indexPath.row) {
            selectedMenuItems.removeAtIndex(index)
        } else {
            selectedMenuItems.append(indexPath.row)
        }
        orderNowButton.hidden = selectedMenuItems.isEmpty
        tableView.reloadData()
    }
}
