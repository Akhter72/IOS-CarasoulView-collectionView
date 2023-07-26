//
//  ViewController.swift
//  CaraseoulView
//
//  Created by Mac on 22/07/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var myItems = [
        ["type": "Primary", "title": "WHAT TO DO NEXT", "subTitle": "Login to any website & save to your node.You can then swipe to sign in.", "Picture": "Search", "btnText": "Open Safari To Try This"],
        ["type": "Primary", "title": "WHAT TO DO NEXT", "subTitle": "Import your passwords from password manager", "btnText": "Import Passwords"],
        ["type": "Secondary", "title": "WHAT TO DO NEXT", "subTitle": "Make a purchase using your tokenized email, track from here p11williams@iomd.info", "Picture": "ReadLater", "btnText": "button Text 3"],
    ]
    var firstCellDisplayed = false
    var currentCellIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = -189
            layout.minimumInteritemSpacing = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame.size.height += 40
    }
    
    func reloadDataWithFadeIn() {
        collectionView.reloadData()
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        let transition = CATransition()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear))
        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromTop
        collectionView.layer.add(transition, forKey: nil)
        CATransaction.commit()
    }
    func scrollToNextCell() {
        myItems.append(myItems[0])
        myItems.remove(at: 0)
        applyEffectToCurrentCell(offset: -200)
    }
    
    func applyEffectToCurrentCell(offset: CGFloat) {
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? MyCell {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: offset)
                
            }, completion: {_ in
                self.reloadDataWithFadeIn()

            })
        }
    }
    
    func applyMovingEffectToCurrentCell(with offsetY: CGFloat) {
        let indexPath = IndexPath(item: currentCellIndex, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? MyCell {
            cell.transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }
    
    func resetEffectOnCurrentCell() {
        let indexPath = IndexPath(item: currentCellIndex, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? MyCell {
            UIView.animate(withDuration: 0.3) {
                cell.transform = CGAffineTransform(translationX: 10, y: 20)
            }
        }
    }
    
    func scrollToPreviousCell() {
        myItems.insert(myItems[myItems.count - 1], at: 0)
        myItems.remove(at: myItems.count - 1)
        applyEffectToCurrentCell(offset: 200)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        cell.layer.zPosition = CGFloat(3 - indexPath.row)
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 1.0
        cell.layer.masksToBounds = false
        cell.title.textColor = UIColor(hex: 0x6148F9)
        cell.subTitle.textColor = UIColor(hex: 0x3C3861)
        cell.subTitle.backgroundColor = .clear
        cell.cellBtn.layer.cornerRadius = 17
        cell.title.text = myItems[indexPath.row]["title"]
        cell.subTitle.text = myItems[indexPath.row]["subTitle"]
        cell.cellBtn.setTitle(myItems[indexPath.row]["btnText"], for: .normal)
        cell.subTitle.isUserInteractionEnabled = false
        if let imageName = myItems[indexPath.row]["Picture"] {
            cell.cellImage.image = UIImage(named: imageName)
            cell.cellImage.isHidden = false
        } else {
            cell.cellImage.isHidden = true
        }
        if myItems[indexPath.row]["type"]! == "Primary" {
            cell.secondaryView.isHidden = true
            cell.cellBtn.isHidden = false
        } else {
            cell.cellBtn.isHidden = true
            cell.secondaryView.isHidden = false
        }
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(hex: 0xE1ECE9)
            cell.layer.borderWidth = 0
        } else {
            cell.backgroundColor = UIColor(hex: 0xCFE8E1)
            cell.layer.borderWidth = 1
        }
        
        cell.layer.borderColor = UIColor(hex: 0xC1DDD5).cgColor
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        upSwipe.direction = .up
        cell.addGestureRecognizer(upSwipe)
        return cell
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            scrollToNextCell()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid = CGFloat(indexPath.row * 20)
        return CGSize(width: collectionView.frame.width - 20 - wid , height: collectionView.frame.height - 45 )
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

