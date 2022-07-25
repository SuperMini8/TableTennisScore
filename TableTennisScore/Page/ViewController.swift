//
//  ViewController.swift
//  Page
//
//  Created by 小八 on 2022/7/18.
//

import UIKit

class Contestant {
    var nowScore: Int = 0
    var roundScore: Int = 0
    var name: String = ""
}
struct Action {
    var leftNowNumber: Int
    var rightNowNumber: Int
    var leftRoundNumber: Int
    var rightRoundNumber: Int
    var side: Side
}

enum Side {
    case right
    case left
}


class ViewController: UIViewController {
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var leftNowNumber: UIButton!
    @IBOutlet weak var leftRoundNumber: UILabel!
    @IBOutlet weak var leftServe: UILabel!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var rightRoundNumber: UILabel!
    @IBOutlet weak var rightNowNumber: UIButton!
    @IBOutlet weak var rightServe: UILabel!
    
    var leftContestant: Contestant = Contestant()
    var rightContestant: Contestant = Contestant()
    var allAction: [Action] = []
    var changeStart: Int = 0
    //左是true
    var leftOrRight: Side = .left
    //選顏色
    let colorwell = UIColorWell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightTextField.delegate = self
        leftTextField.delegate = self
        self.view.addSubview(colorwell)
        colorwell.frame = CGRect(x: (view.bounds.width/2) - 5, y: 20, width: 10, height: 10)
        colorwell.addTarget(self, action: #selector(changeColor), for: .valueChanged)
    }
    
    @objc func changeColor() {
        view.backgroundColor = colorwell.selectedColor
    }
    
    //返回上一步(目前只能返回NowNumber)
    @IBAction func rewind(_ sender: Any) {
        //現在分數
        if let last = allAction.last {
            leftContestant.nowScore = last.leftNowNumber
            rightContestant.nowScore = last.rightNowNumber
            leftContestant.roundScore = last.leftRoundNumber
            rightContestant.roundScore = last.rightRoundNumber
            allAction.removeLast()
            leftOrRight = last.side
        }
        setLeftUI(contestant: leftContestant)
        setRightUI(contestant: rightContestant)
    }
    //兩邊交換
    @IBAction func changeSide(_ sender: Any) {
        //將所有動作的比數反回來
        let action = allAction
        allAction.removeAll()
        for a in action {
            var side = Side.left
            if a.side == .left {
                side = .right
            } else {
                side = .left
            }
            let new = Action(leftNowNumber: a.rightNowNumber, rightNowNumber: a.leftNowNumber, leftRoundNumber: a.rightRoundNumber, rightRoundNumber: a.leftRoundNumber, side: side)
            allAction.append(new)
        }
        //發球左右交換
        if leftOrRight == .left {
            leftOrRight = .right
        } else {
            leftOrRight = .left
        }
        //先換資料
        let leftC = leftContestant
        leftContestant = rightContestant
        rightContestant = leftC
        //重新設置UI
        setLeftUI(contestant: leftContestant)
        setRightUI(contestant: rightContestant)
    }
    //全數清空
    @IBAction func reset(_ sender: Any) {
        //先全部初始化
        leftContestant.nowScore = 0
        leftContestant.roundScore = 0
        rightContestant.nowScore = 0
        rightContestant.roundScore = 0
        allAction = []
        changeStart = 0
        //再重新設置UI
        setLeftUI(contestant: leftContestant)
        setRightUI(contestant: rightContestant)
    }
    
    @IBAction func leftNow(_ sender: Any) {
        //先存上一部的比數
        let action = Action(leftNowNumber: leftContestant.nowScore, rightNowNumber: rightContestant.nowScore, leftRoundNumber: leftContestant.roundScore, rightRoundNumber: rightContestant.roundScore, side: leftOrRight)
        allAction.append(action)
        //先得分
        leftContestant.nowScore += 1
        //如果雙10平手
        if leftContestant.nowScore >= 10 && rightContestant.nowScore >= 10 {
            //相差1以內
            if (leftContestant.nowScore - rightContestant.nowScore) <= 1 {
                if leftOrRight == .left {
                    leftOrRight = .right
                } else {
                    leftOrRight = .left
                }
                setRightUI(contestant: rightContestant)
                setLeftUI(contestant: leftContestant)
            } else {
                //獲得局分
                leftContestant.roundScore += 1
                //重新記發球
                changeStart = 0
                setRightUI(contestant: rightContestant)
                setLeftUI(contestant: leftContestant)
                //重設完UI再歸零分數
                rightContestant.nowScore = 0
                leftContestant.nowScore = 0
            }
        }
        //如果是11分了
        else if leftContestant.nowScore == 11 {
            //獲得局分
            leftContestant.roundScore += 1
            //重新記發球
            changeStart = 0
            setRightUI(contestant: rightContestant)
            setLeftUI(contestant: leftContestant)
            //重設完UI再歸零分數
            rightContestant.nowScore = 0
            leftContestant.nowScore = 0
        } else {
            changeStart += 1
            if changeStart == 2 {
                //發球左右交換
                if leftOrRight == .left {
                    leftOrRight = .right
                } else {
                    leftOrRight = .left
                }
                changeStart = 0
            }
            setRightUI(contestant: rightContestant)
            setLeftUI(contestant: leftContestant)
        }
    }
    @IBAction func rightNow(_ sender: Any) {
        //先存上一部的比數
        let action = Action(leftNowNumber: leftContestant.nowScore, rightNowNumber: rightContestant.nowScore, leftRoundNumber: leftContestant.roundScore, rightRoundNumber: rightContestant.roundScore, side: leftOrRight)
        allAction.append(action)
        //先得分
        rightContestant.nowScore += 1
        if leftContestant.nowScore >= 10 && rightContestant.nowScore >= 10 {
            //相差1以內
            if (rightContestant.nowScore - leftContestant.nowScore) <= 1 {
                if leftOrRight == .left {
                    leftOrRight = .right
                } else {
                    leftOrRight = .left
                }
                setRightUI(contestant: rightContestant)
                setLeftUI(contestant: leftContestant)
            } else {
                //獲得局分
                rightContestant.roundScore += 1
                //重新記發球
                changeStart = 0
                setRightUI(contestant: rightContestant)
                setLeftUI(contestant: leftContestant)
                //重設完UI再歸零分數
                rightContestant.nowScore = 0
                leftContestant.nowScore = 0
            }
        }
        //如果是11分了
        else if rightContestant.nowScore == 11 {
            //獲得局分
            rightContestant.roundScore += 1
            //重新記發球
            changeStart = 0
            setRightUI(contestant: rightContestant)
            setLeftUI(contestant: leftContestant)
            leftContestant.nowScore = 0
            rightContestant.nowScore = 0
        } else {
            changeStart += 1
            if changeStart == 2 {
                //發球左右交換
                if leftOrRight == .left {
                    leftOrRight = .right
                } else {
                    leftOrRight = .left
                }
                changeStart = 0
            }
            setRightUI(contestant: rightContestant)
            setLeftUI(contestant: leftContestant)
        }
    }
    
    //設置左邊UI
    func setLeftUI(contestant: Contestant) {
        leftNowNumber.titleLabel?.text = "\(contestant.nowScore)"
        leftNowNumber.setTitle("\(contestant.nowScore)", for: .normal)
        leftTextField.text = contestant.name
        leftRoundNumber.text = "\(contestant.roundScore)"
        if leftOrRight == .left {
            leftServe.isHidden = false
            rightServe.isHidden = true
        }
    }
    //設置右邊UI
    func setRightUI(contestant: Contestant) {
        rightNowNumber.titleLabel?.text = "\(contestant.nowScore)"
        rightNowNumber.setTitle("\(contestant.nowScore)", for: .normal)
        rightTextField.text = contestant.name
        rightRoundNumber.text = "\(contestant.roundScore)"
        if leftOrRight == .right {
            rightServe.isHidden = false
            leftServe.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == leftTextField {
            leftContestant.name = textField.text!
        } else if textField == rightTextField {
            rightContestant.name = textField.text!
        }
    }
}
