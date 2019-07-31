//
//  ViewController.swift
//  SlideshowApp
//
//  Created by 須田幸秀 on 2019/07/28.
//  Copyright © 2019 yukihide.suda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    //スライドショーに表示する画像
    let imgArr = ["IMG_1578.jpg", "IMG_1593.jpg", "IMG_1603.jpg", "IMG_1609.jpg", "IMG_1655.jpg"]
    var imgNum: Int = 0
    
    //タイマー宣言
    var timer: Timer!
    var timer_sec: Float = 0
    
    //imageViwe内に画像を表示させる関数を作成
    func slideShow() {
        //5枚目まで行ったら1枚目に戻る、またはその逆の動き
        if imgNum < 0 {
            imgNum = 4
        } else if imgNum > 4 {
            imgNum = 0
        }
        //配列から画像名を代入
        let imgName = imgArr[imgNum]
        let slideImg = UIImage(named: imgName)
        imageView.image = slideImg
    }
    
    //タイマーを作動させる関数
    func countTime() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        slideShow()
    }
    
    //画像をタップした時に大きい画像を表示させる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendDetailImg:DetailViewController = segue.destination as! DetailViewController
        sendDetailImg.detailImg = self.imageView.image
        //自動スライド有効時のみ、自動スライドを止める
        if self.timer != nil {
            self.timer.invalidate()
        }
    }
    
    //２秒ごとにスライドを自動で動かす
    @objc func updateTimer(_ timer: Timer) {
        self.timer_sec += 0.1
        if self.timer_sec >= 2.0 {
            imgNum += 1
            slideShow()
            self.timer_sec = 0
        }
    }
    
    //戻るボタンのアクション
    @IBAction func backAction(_ sender: Any) {
        imgNum -= 1
        slideShow()
    }
    
    //進むボタンのアクション
    @IBAction func nextAction(_ sender: Any) {
        imgNum += 1
        slideShow()
    }
    
    //再生・停止ボタンのアクション
    @IBAction func switchAction(_ sender: Any) {
        if self.timer == nil {
            countTime()
            backButton.isEnabled = false
            nextButton.isEnabled = false
            switchButton.setTitle("停止", for: .normal)
        } else if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
            backButton.isEnabled = true
            nextButton.isEnabled = true
            switchButton.setTitle("再生", for: .normal)
        }
    }
    
    //戻ってきた時の動作
    @IBAction func backTop(_ segue: UIStoryboardSegue) {
        //自動スライド有効時のみ、止めた自動スライドを再開させる
        if self.timer != nil {
            self.timer = nil //念の為、timerを一旦空にする
            countTime()
        }
    }
}
