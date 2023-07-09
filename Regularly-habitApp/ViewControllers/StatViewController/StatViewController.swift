//
//  StatViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 5/6/2023.
//

import UIKit
import Charts
import SwiftUI
import SnapKit

class StatViewController: UIViewController {
    
    var activityLog: ActivityLog?
    var firebaseController: FirebaseController?
    var authenticateController: AuthenticateController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        firebaseController = appDelegate?.firebaseController
        authenticateController  = appDelegate?.authenticateController
        
        Task {
            await setupChartView()
        }
        

        // Do any additional setup after loading the view.
    }
    
    //MARK: Repeated codes below - Fix them sometime
    
    func setupChartView() async{
        
        //Repeated code from firebase controller, implement another function
        guard let uid = authenticateController?.authController.currentUser?.uid else{
            return
        }
        let df = DateFormatter()
        //get date component
        let currentDate = Date()
        df.dateFormat = "yyyy"
        let year = df.string(from: currentDate)
        df.dateFormat = "MMM"
        let month = df.string(from: currentDate)
        
        let activityLogID = uid+"-"+year+"-"+month
        
        var logActivity: ActivityLog?
        do{
            logActivity = try await firebaseController?.getActivityLogFromID(id: activityLogID)
        }catch{
            print(error)
        }
        
        
        //Set up ChartView
        let controller = UIHostingController(rootView: ChartUIView(activityLog: logActivity!))
        guard let chartView = controller.view else{
            return
        }
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(500)
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
