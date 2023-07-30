//
//  ViewController.swift
//  CaraseoulView
//
//  Created by Mac on 22/07/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    /*
     1. collectionViewHeight = x // done
     2. //189    --     layout.minimumLineSpacing = -189 // done
     3. //x - 40 --     collectionView.frame.size.height += 40  // done
     4. applyEffectToCurrentCell(offset: -200) (cleanup) // done
     5. myItems.append(myItems[0]) myItems.remove(at: 0) - add check prevent crash // done
     6. CGFloat(3 - indexPath.row) // done
     7. return CGSize(width: collectionView.frame.width - 20 - wid , height: collectionView.frame.height - 45 ) // done
     8. self.collectionView.reloadData() only if last index  // done
     9.
     
     */
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellHeight = CGFloat(163)
    var collectionViewHeight = CGFloat(193)
    
    
    
    var myItems = [
        ["type": "Primary", "title": "WHAT TO DO NEXT", "subTitle": "Login to any website & save to your node.You can then swipe to sign in.", "Picture": "Search", "btnText": "Open Safari To Try This"],
        ["type": "Primary", "title": "WHAT TO DO NEXT", "subTitle": "Import your passwords from password manager", "btnText": "Import Passwords"],
        ["type": "Secondary", "title": "WHAT TO DO NEXT", "subTitle": "Make a purchase using your tokenized email, track from here p11williams@iomd.info", "Picture": "ReadLater", "btnText": "button Text 3"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            // 5 value for ovelaying view
            layout.minimumLineSpacing = -(cellHeight - 5)
            layout.minimumInteritemSpacing = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame.size.height = collectionViewHeight
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
    }
    
    func scrollToNextCell() {
        if myItems.count >= 0 {
            myItems.append(myItems[0])
            myItems.remove(at: 0)
        }
        applyEffectToCurrentCell()
    }
    
    func applyEffectToCurrentCell() {
        let cells = collectionView.visibleCells
        let indexPath = IndexPath(item: 0, section: 0)
        for cell in cells {
            var off = -(cell.frame.height/2)
            if indexPath == collectionView.indexPath(for: cell) {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: off - 30).scaledBy(x: 0.95, y: 0.8)
                }, completion: {_ in
                    cell.layer.zPosition = -1
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                        off = -(off/4)
                        cell.transform = CGAffineTransform(translationX: 0, y: off).scaledBy(x: 0.95, y: 0.6)
                    
                    })
                })
            } else {
                var myCount = 0
                var off2 = cell.frame.height / 4
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: off2).scaledBy(x: 1, y: 1)
                
                }, completion: {_ in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                        off2 = -50
                        cell.transform = CGAffineTransform(translationX: 0, y: -5).scaledBy(x: 1.06 , y: 1)
                        
                    }, completion: { [self]_ in
                        if self.collectionView.indexPath(for: cell)?.row == cells.count - 1 {
                            self.collectionView.reloadData()
//                            self.collectionView.reloadItems(at: [IndexPath(row: cells.count, section: 0)])
                        }
                    })
                })
                myCount += 1
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        cell.layer.zPosition = CGFloat(myItems.count - indexPath.row)
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
        cell.backgroundColor = UIColor(hex: 0xE1ECE9)
//        if indexPath.row == 0 {
//            cell.backgroundColor = UIColor(hex: 0xE1ECE9)
//            cell.layer.borderWidth = 0
//        } else {
//            cell.backgroundColor = UIColor(hex: 0xCFE8E1)
//            cell.layer.borderWidth = 1
//        }
        
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
        let wid = CGFloat(indexPath.row * 20) + 20
        return CGSize(width: collectionView.frame.width - wid , height: cellHeight )
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
