//
//  SecondViewController.swift
//  音色
//
//  Created by raoka0000 on 2015/08/15.
//  Copyright (c) 2015年 raoka0000. All rights reserved.
//
import UIKit
import OpenAL
//import OpenAL.ALC
import AudioToolbox
import Foundation
import AVFoundation

func ALCデバイスを開く(_ デバイス:UnsafePointer<ALCchar>) -> OpaquePointer {
    return alcOpenDevice(デバイス)
}

func ALCコンテキストを作成する(_ device: OpaquePointer, attrlist: UnsafePointer<ALCint>) -> OpaquePointer {
    return alcCreateContext(device,attrlist)
}

func 使用するALCコンテキストを指定する(_ context: OpaquePointer) -> ALCboolean {
    return alcMakeContextCurrent(context)
}

func ALバッファを作成する(_ n: ALsizei, buffers: UnsafeMutablePointer<ALuint>) {
    alGenBuffers(n,buffers)
}

func 波形データをALバッファに格納する(_ bid: ALuint, format: ALenum, data: UnsafeRawPointer, size: ALsizei, freq: ALsizei) {
    alBufferData(bid,format,data,size,freq)
}

func ALソースを作成する(_ n: ALsizei, sources: UnsafeMutablePointer<ALuint>) {
    alGenSources(n,sources)
}

func ALバッファをALソースに格納する(_ sid: ALuint, param: ALenum, value: ALint) {
    alSourcei(sid, param, value)
}

func ALソースを再生する(_ sid: ALuint) {
    alSourcePlay(sid)
}

func ALソースを停止する(_ sid: ALuint) {
    alSourceStop(sid)
}

func ALソースを削除する(_ n: ALsizei, sources: UnsafePointer<ALuint>) {
    alDeleteSources(n, sources)
}

func ALバッファを削除する(_ n: ALsizei, buffers: UnsafePointer<ALuint>) {
    alDeleteBuffers(n, buffers)
}

func ALCコンテキストを削除する(_ context: OpaquePointer) {
    alcDestroyContext(context)
}

func ALCデバイスを閉じる(_ device: OpaquePointer) -> ALCboolean {
    return alcCloseDevice(device)
}

func Double型をALshortに変換する(_ 入力値:Double) -> ALshort {
    return ALshort(Int16(入力値))
}



func 平岡波のデータを生成する(_ data:inout [ALshort]) {
    for i in 0 ..< 22050 {
        var a:Double = 0
        var division:Double = 1
        for i2 in 1 ..< 6 {
            a += sin(Double(i) * 3.14159 * 1.5 * 440  / 22050 * Double(i2))
            a += cos(Double(i) * 3.14159 * 2 * 440  / 22050 * Double(i2))
            division += 2
        }
        a = a / division * 32767
        let b:Int16 = Int16(a)
        let c:ALshort = ALshort(b)
        data[i] = c
    }
}



var 円周率:Double = 3.14159 //pi
var 信号の周波数:Double = 440 //f 音階になる
var サンプリング周波数:Double = 22050 //fs １秒間のサンプル数を表す。
var 信号の最大振幅:Double = 10000 //amp これが音量になる？
var 総サンプル数:Int = 22050 //N　音の長さは N/fs秒
var 離散時間:Int = 0 //n

func サイン波のデータを生成する(_ data:inout [ALshort]) {
    for i in 0 ..< 総サンプル数 {
        data[i] = Double型をALshortに変換する(
            sin(2.0 * 円周率 * 信号の周波数 * Double(i) / サンプリング周波数) * 信号の最大振幅
        )
    }
}
func 矩形波のデータを生成する(_ data:inout [ALshort]) {
    for i in 0 ..< 総サンプル数 {
        let tmp:Double = サンプリング周波数 / 信号の周波数
        if fmod(Double(i), tmp) < サンプリング周波数 / (2 * 信号の周波数) {
            data[i] = Double型をALshortに変換する(
                信号の最大振幅 - 8000
            )
        }
        if fmod(Double(i), tmp) >= サンプリング周波数 / (2 * 信号の周波数) {
            data[i] = Double型をALshortに変換する(
                (信号の最大振幅 - 8000) * -1
            )
        }
    }
}

func パルス波のデータを生成する(_ data:inout [ALshort]) {
    for i in 0 ..< 22050 {
        let tmp:Double = サンプリング周波数 / 信号の周波数
        if fmod(Double(i), tmp) < 1 {
            data[i] = Double型をALshortに変換する(
                信号の最大振幅
            )
        }
        if fmod(Double(i), tmp) >= 1 {
            data[i] = Double型をALshortに変換する(
                0
            )
        }
    }
}
func 三角波のデータを生成する(_ data:inout [ALshort]) {
    for i in 0 ..< 総サンプル数 {
        let tmp:Double = サンプリング周波数 / 信号の周波数
        if fmod(Double(i), tmp) < サンプリング周波数 / (2 * 信号の周波数) {
            data[i] = Double型をALshortに変換する(
                4 * 信号の最大振幅 * (信号の周波数 / サンプリング周波数) * fmod(Double(i), tmp) - 信号の最大振幅
            )
        }
        if fmod(Double(i), tmp) >= サンプリング周波数 / (2 * 信号の周波数) {
            data[i] = Double型をALshortに変換する(
                -4 * 信号の最大振幅 * (信号の周波数 / サンプリング周波数) * fmod(Double(i), tmp) + 3 * 信号の最大振幅
            )
        }
    }
}

func ノコギリ波のデータを生成する(_ data:inout [ALshort]) {
    for i in 0 ..< 総サンプル数 {
        let tmp:Double = サンプリング周波数 / 信号の周波数
        data[i] = Double型をALshortに変換する(
            2 * (信号の最大振幅 - 8000) * (信号の周波数 / サンプリング周波数) * fmod(Double(i), tmp) - (信号の最大振幅 - 8000)
        )
    }
}

class SecondViewController: UIViewController{
    
    var RGB_r:[CGFloat] = [CGFloat](repeating: 0, count: 900)
    var RGB_g:[CGFloat] = [CGFloat](repeating: 0, count: 900)
    var RGB_b:[CGFloat] = [CGFloat](repeating: 0, count: 900)
    var bright:[CGFloat] = [CGFloat](repeating: 0, count: 900)
    
    
    var mySelectedImage: UIImage!
    var mySelectedImageView: UIImageView!
    
    var wavetyp: Int!
    
    var timer = Timer()
    
    var ALバッファ:ALuint = 0
    var ALソース:[ALuint] = Array(repeating: 0, count: 3)
    
    fileprivate var ALCデバイス:OpaquePointer?
    fileprivate var ALCコンテキスト:OpaquePointer?
    
    override func viewDidLoad() {
        //self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.white
        setImage()
                self.ALCデバイス = ALCデバイスを開く( UnsafePointer(bitPattern: 0)! )
        self.ALCコンテキスト = ALCコンテキストを作成する(self.ALCデバイス!, attrlist: UnsafePointer(bitPattern: 0)!)
        使用するALCコンテキストを指定する( self.ALCコンテキスト! )
        setsound()
        self.timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(SecondViewController.update), userInfo: nil, repeats: true)
    }
    /*
    Buttonを押した時に呼ばれるメソッド.
    */
    func onClickMyButton(_ sender : UIButton){
        // viewを閉じる.
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    /*
    選択された画像をUIImageViewにセットする.
    */
    func setImage(){
        mySelectedImageView = UIImageView(frame: self.view.bounds)
        mySelectedImageView.contentMode = UIViewContentMode.scaleAspectFit
        mySelectedImageView.image = mySelectedImage
        self.view.addSubview(mySelectedImageView)
        
        // もどるButtonを生成.
        let playbutton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75));
        let buttonImage = UIImage(named: "stop.png")!;
        playbutton.setBackgroundImage(buttonImage, for: UIControlState());
        playbutton.layer.position = CGPoint(x: self.view.frame.width / 2, y:630)
        playbutton.addTarget(self, action: #selector(SecondViewController.onClickMyButton(_:)), for: .touchUpInside)
        playbutton.tag = 1
        playbutton.alpha = 0.5
        self.view.addSubview(playbutton);
    }
    func setsound(){
        //画像を３０＊３０にする
        ImageSquares()
        var 波形データ:[ALshort] = [ALshort](repeating: 0, count: 22050)
        let s = 波形データ.count // * sizeof(ALsizei)
        let size:ALsizei = ALsizei(s)
        let freq:ALsizei = ALsizei(Int32(22050))
        //print(Allbright())
        let temp = 251
        switch temp {
        case 0...150:
            alSourcef(ALソース[0], AL_MIN_GAIN , 0.7)
            alSourcef(ALソース[1], AL_MIN_GAIN , 0.7)
            alSourcef(ALソース[2], AL_MIN_GAIN , 0.7)
            信号の周波数 = 360
            rizumu = 40
        case 151...200:
            rizumu = 30
            信号の周波数 = 360
        case 201...250:
            信号の周波数 = 400
        case 251...350:
            信号の周波数 = 440
        case 351...400:
            rizumu = 10
            信号の周波数 = 480
        default:
            rizumu = 10
            信号の周波数 = 520
        }
        switch wavetyp{
        case 0:
            サイン波のデータを生成する( &波形データ )
        case 1:
            矩形波のデータを生成する( &波形データ )
        case 2:
            三角波のデータを生成する( &波形データ )
        case 3:
            ノコギリ波のデータを生成する( &波形データ )
        case 4:
            パルス波のデータを生成する( &波形データ )
        default:
            サイン波のデータを生成する( &波形データ )
        }
        ALバッファを作成する(1, buffers: &ALバッファ)
        波形データをALバッファに格納する(ALバッファ, format: AL_FORMAT_MONO16, data: 波形データ, size: size, freq: freq)
        for i in 0...2{
            ALソースを作成する(1, sources: &ALソース[i]);
            ALバッファをALソースに格納する(ALソース[i], param: ALenum(AL_BUFFER), value: ALint(ALバッファ))
            alSourcei(ALソース[i], AL_LOOPING , AL_TRUE);   // 繰り返し
            alSourcef(ALソース[i], AL_PITCH, 0)
            ALソースを再生する(ALソース[i])
        }
    }
    var UpdateCount:Int = 0
    var cun:[Int] = [0,0,0,0]
    var SoundPower:[ALfloat] = [1,1,1,1,1]
    var rizumu = 20
    func update(){
        UpdateCount += 1
        alSourcef(ALソース[0], AL_GAIN , SoundPower[0])
        alSourcef(ALソース[1], AL_GAIN , SoundPower[1])
        alSourcef(ALソース[2], AL_GAIN , SoundPower[2])
        SoundPower[0] -= 0.02
        SoundPower[1] -= 0.02
        SoundPower[2] -= 0.02
        if SoundPower[0] <= 0{
            SoundPower[0] = 0
        }
        if SoundPower[1] <= 0{
            SoundPower[1] = 0
        }
        if SoundPower[2] <= 0{
            SoundPower[2] = 0
        }
        if SoundPower[3] <= 0{
            SoundPower[3] = 0
        }
        if SoundPower[4] <= 0{
            SoundPower[4] = 0
        }
        if UpdateCount % Int(rizumu) == 0 {
            if RGB_r[cun[0]] >= 0.2{
                SoundPower[0] = 1
            }
            alSourcef(ALソース[0], AL_PITCH, ALfloat(RGB_r[cun[0]]) + 0.2);
            cun[0] += 1
        }
        if UpdateCount % Int(rizumu + rizumu / 2) == 0 {
            alSourcef(ALソース[1], AL_PITCH, ALfloat(RGB_g[cun[1]]) + 0.2);
            if RGB_g[cun[1]] >= 0.2{
                SoundPower[1] = 1
            }
            cun[1] += 1
        }
        if UpdateCount % Int(rizumu) == 0 {
            alSourcef(ALソース[2], AL_PITCH, ALfloat(RGB_b[cun[2]]) + 0.2);
            if RGB_b[cun[2]] >= 0.2{
                SoundPower[2] = 1
            }
            cun[2] += 1
        }
        if (UpdateCount == 100 * 60 || cun[0] == RGB_r.count||cun[1] == RGB_g.count||cun[2] == RGB_b.count) {
            for i in 0..<ALソース.count{
                ALソースを停止する(ALソース[Int(i)])
                ALソースを削除する(1, sources: &ALソース[Int(i)])
                ALバッファを削除する(1, buffers: &ALバッファ)
            }
        }
    }
    func colorfloor(_ num:CGFloat) -> CGFloat{
        var end:CGFloat = 0
        switch num {
        case 0..<0.1:
            end = 0
        case 0.1..<0.3:
            end = 0.2
        case 0.3..<0.5:
            end = 0.4
        case 0.5..<0.7:
            end = 0.6
        case 0.7..<0.9:
            end = 0.8
        case 0.9..<1:
            end = 1
        default:
            end = 1
        }
        return end
    }
    func ImageSquares(){
        //ピクセルデータ取得してバイナリ化
        let myImage = mySelectedImage
        let pixelData = myImage!.cgImage!.dataProvider!.data
        let Imagedata: UnsafePointer = CFDataGetBytePtr(pixelData)
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        var division:CGFloat = 0
        var arraycunt : Int = 0
        for_i : for x in 0...29{
            let tmpx = myImage!.size.width / 30 * CGFloat(x)
            for y in 0...29{
                let tmpy = myImage!.size.height / 30 * CGFloat(y)
                for tmpx2 in 0...29{
                    for tmpy2 in 0...29{
                        let tmpx3 = tmpx + myImage!.size.width / 900 * CGFloat(tmpx2)
                        let tmpy3 = tmpy + myImage!.size.height / 900 * CGFloat(tmpy2)
                        let pixelInfo:Int = (Int(myImage!.size.width) * Int(tmpy3) + Int(tmpx3))*4
                        let tmp_a = CGFloat(Imagedata[pixelInfo+3]) / CGFloat(255.0)
                        if tmp_a > 0{
                            r += CGFloat(Imagedata[pixelInfo]) / CGFloat(255.0)
                            g += CGFloat(Imagedata[pixelInfo+1]) / CGFloat(255.0)
                            b += CGFloat(Imagedata[pixelInfo+2]) / CGFloat(255.0)
                            a += tmp_a
                            division += 1
                        }
                    }
                }
                if division == 0{
                    division = 1
                }
                RGB_r[arraycunt] = colorfloor(r / division)
                RGB_g[arraycunt] = colorfloor(g / division)
                RGB_b[arraycunt] = colorfloor(b / division)
                if RGB_r[arraycunt] + RGB_g[arraycunt] + RGB_b[arraycunt] < 1.5{
                    bright[arraycunt] = 0
                }else{
                    bright[arraycunt] = 1
                }
                r = 0;g = 0;b = 0;
                arraycunt += 1
                division = 0
                if arraycunt == 899{
                    break for_i;
                }
            }
        }
    }
    /*
    func Allbright() -> CGFloat{
        var result:CGFloat = 0
        var bright:CGFloat = 0
        var maxtmp:CGFloat = 0
        var mintmp:CGFloat = 2
        var tmp:CGFloat = 0
        var cun:Int
        for i in 0...899{
            for (cun = 0,maxtmp = self.RGB_r[i];cun <= 2; cun += 1){
                switch cun{
                case 0:
                    tmp = self.RGB_r[i]
                case 1:
                    tmp = self.RGB_g[i]
                case 2:
                    tmp = self.RGB_b[i]
                default:
                    break;
                }
                if maxtmp < tmp {
                    maxtmp = tmp
                }else if mintmp > tmp {
                    mintmp = tmp
                }
            }
            result += (maxtmp + mintmp) / 2
        }
        return result
    }*/
    override func viewDidDisappear(_ animated: Bool){
        if self.timer.isValid == true {//timerが動いていたら破棄する.
            self.timer.invalidate()
        }
        for i in 0..<ALソース.count{
            alSourcef(ALソース[Int(i)], AL_MAX_GAIN , 0)
            ALソースを削除する(1, sources: &ALソース[Int(i)])
        }
        ALバッファを削除する(1, buffers: &ALバッファ)
        使用するALCコンテキストを指定する(self.ALCコンテキスト! )
        ALCコンテキストを削除する( self.ALCコンテキスト! )
        ALCデバイスを閉じる( self.ALCデバイス! )
    }
}
