//
//  ViewController.swift
//  音色
//
//  Created by raoka0000 on 2015/08/15.
//  Copyright (c) 2015年 raoka0000. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var myImagePicker: UIImagePickerController!
    var myImageView: UIImageView!
    var selsectimg:UIImageView!
    var musicimg:UIImage?
    var wavetyp:Int = 0
    var waveButton_1: UIButton = UIButton()
    var waveButton_2: UIButton = UIButton()
    var waveButton_3: UIButton = UIButton()
    var waveButton_4: UIButton = UIButton()
    var waveButton_5: UIButton = UIButton()
    var playbutton: UIButton = UIButton()

    
    var playflg:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage(named: "background.png")!
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        
        // 画像を利用した場合の生成
        let selectbutton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120));
        var buttonImage:UIImage = UIImage(named: "imgSelected.png")!;
        selectbutton.setBackgroundImage(buttonImage, for: UIControlState());
        selectbutton.layer.position = CGPoint(x: self.view.frame.width/2, y:140)
        selectbutton.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
        selectbutton.tag = 1
        self.view.addSubview(selectbutton);
        
        selsectimg = UIImageView(frame: CGRect(x: 0,y: 0,width: 95,height: 95))
        var tmpImage = UIImage(named: "no-image.png")
        selsectimg.image = tmpImage
        selsectimg.layer.position = CGPoint(x: self.view.bounds.width/6, y: 140.0)
        self.view.addSubview(selsectimg)
        
        
        // 波のボタン
        waveButton_1 = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 100));
        buttonImage = UIImage(named: "waveSelected.png")!;
        waveButton_1.setBackgroundImage(buttonImage, for: UIControlState());
        waveButton_1.layer.position = CGPoint(x: self.view.frame.width/6, y:280)
        waveButton_1.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
        waveButton_1.tag = 2
        self.view.addSubview(waveButton_1);
        let wave_1img = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        tmpImage = UIImage(named: "wave_1.png")
        wave_1img.image = tmpImage
        wave_1img.layer.position = CGPoint(x: self.view.bounds.width/6, y: 280)
        self.view.addSubview(wave_1img)
        
        waveButton_2 = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 100));
        buttonImage = UIImage(named: "waveBackground.png")!;
        waveButton_2.setBackgroundImage(buttonImage, for: UIControlState());
        waveButton_2.layer.position = CGPoint(x: self.view.frame.width * 3 / 6, y:280)
        waveButton_2.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
        waveButton_2.tag = 3
        self.view.addSubview(waveButton_2);
        let wave_2img = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        tmpImage = UIImage(named: "wave_2.png")
        wave_2img.image = tmpImage
        wave_2img.layer.position = CGPoint(x: self.view.bounds.width * 3 / 6, y: 280)
        self.view.addSubview(wave_2img)

        
        waveButton_3 = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 100));
        buttonImage = UIImage(named: "waveBackground.png")!;
        waveButton_3.setBackgroundImage(buttonImage, for: UIControlState());
        waveButton_3.layer.position = CGPoint(x: self.view.frame.width * 5 / 6, y:280)
        waveButton_3.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
        waveButton_3.tag = 4
        self.view.addSubview(waveButton_3);
        let wave_3img = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        tmpImage = UIImage(named: "wave_3.png")
        wave_3img.image = tmpImage
        wave_3img.layer.position = CGPoint(x: self.view.bounds.width * 5 / 6, y: 280)
        self.view.addSubview(wave_3img)

        
        waveButton_4 = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 100));
        buttonImage = UIImage(named: "waveBackground.png")!;
        waveButton_4.setBackgroundImage(buttonImage, for: UIControlState());
        waveButton_4.layer.position = CGPoint(x: self.view.frame.width * 2 / 6, y:400)
        waveButton_4.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
        waveButton_4.tag = 5
        self.view.addSubview(waveButton_4);
        let wave_4img = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        tmpImage = UIImage(named: "wave_4.png")
        wave_4img.image = tmpImage
        wave_4img.layer.position = CGPoint(x: self.view.bounds.width * 2 / 6, y: 400)
        self.view.addSubview(wave_4img)

        
        waveButton_5 = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 100));
        buttonImage = UIImage(named: "waveBackground.png")!;
        waveButton_5.setBackgroundImage(buttonImage, for: UIControlState());
        waveButton_5.layer.position = CGPoint(x: self.view.frame.width * 4 / 6, y:400)
        waveButton_5.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
        waveButton_5.tag = 6
        self.view.addSubview(waveButton_5);
        let wave_5img = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        tmpImage = UIImage(named: "wave_5.png")
        wave_5img.image = tmpImage
        wave_5img.layer.position = CGPoint(x: self.view.bounds.width * 4 / 6, y: 400)
        self.view.addSubview(wave_5img)

        
        playbutton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
        buttonImage = UIImage(named: "no-play.png")!;
        playbutton.setBackgroundImage(buttonImage, for: UIControlState());
        playbutton.layer.position = CGPoint(x: self.view.frame.width / 2, y:560)
        playbutton.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
        playbutton.tag = 7
        self.view.addSubview(playbutton);
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.presentViewController(myImagePicker, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    ボタンのアクション時に設定したメソッド.
    */
    internal func onClickMyButton(_ sender: UIButton){
        switch sender.tag{
        case 1:
            myImagePicker = UIImagePickerController()//インスタンス生成
            myImagePicker.delegate = self//デリケート設定
            myImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary//画像の取得先はフォトライブラリ
            self.present(myImagePicker, animated: true, completion: nil)
        case 2...6:
            let buttons = [waveButton_1, waveButton_2, waveButton_3, waveButton_4, waveButton_5]
            for i in 0...4 {
                buttons[i].setBackgroundImage(UIImage(named: "waveBackground.png")!, for: UIControlState())
            }
            buttons[sender.tag - 2].setBackgroundImage(UIImage(named: "waveSelected.png")!, for: UIControlState())
            wavetyp = sender.tag - 2
        case 7:
            if playflg {
                musicsetup()
            }
        default:
            break;
        }
    }
    
    /**
    画像が選択された時に呼ばれる.
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //選択された画像を取得.
        let myImage: AnyObject?  = info[UIImagePickerControllerOriginalImage] as AnyObject
        self.dismiss(animated: true, completion: nil)
        if myImage != nil {
            musicimg = myImage as? UIImage
            selsectimg.image = musicimg
            playflg = true
            playbutton.setBackgroundImage(UIImage(named: "play.png")!, for: UIControlState());
        }
    }
    /**
    画像選択がキャンセルされた時に呼ばれる.
    */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // モーダルビューを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    func musicsetup(){
        //選択された画像を表示するViewControllerを生成.
        let secondViewController = SecondViewController()
        //選択された画像を表示するViewContorllerにセットする.
        secondViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        secondViewController.mySelectedImage = musicimg
        secondViewController.wavetyp = self.wavetyp
        // navigationControllerのrootViewControllerにsecondViewControllerをセット.
        let nav = UINavigationController(rootViewController: secondViewController)
        self.present(nav, animated: true, completion: nil)
    }
}

