



import UIKit
import YYKit
import SnapKit

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "CustomCell"
    
    @IBOutlet weak var label: ExpandableLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = WaterfallLayout2()
        layout.delegate = self
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WaterFallCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        view.addSubview(collectionView)
        
//        view.addSubview(descView)
//        descView.snp.makeConstraints { make in
//            make.left.right.equalTo(view)
//            make.top.equalTo(300)
//            make.height.equalTo(60)
//        }
//        descView.text = "确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。确保你的项目已正确配置所需的库。"
//        
//        let mAttr = NSMutableAttributedString(string: descView.text!)
//        mAttr.setTextHighlight(NSRange(location: 0, length: 1), color: UIColor.green, backgroundColor: UIColor.clear) { view, mAttr, range, rect in
//            print("2")
//        }
//        descView.attributedText = mAttr
        
    }
    
    private lazy var descView: YYLabel = {
        let label = YYLabel()
        label.numberOfLines = 3
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.truncationToken = truncationToken
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width
        label.isUserInteractionEnabled = true
        label.textTapAction = { [weak self] (_: UIView, text: NSAttributedString, range: NSRange, _: CGRect) in
            guard let sself = self else { return }
            let webView = WebViewController()
            sself.navigationController?.pushViewController(webView, animated: true)
        }
        label.backgroundColor = .red
        
        

        return label
    }()
    
    
    private lazy var truncationToken: NSAttributedString = {
        let string = "...展开"
        let mAttrStr = NSMutableAttributedString(string: string)
        let attrDict = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.white]
        mAttrStr.addAttributes(attrDict, range: NSRange(location: 0, length: string.count))
//        let highlight = YYTextHighlight()
//        highlight.setFont(PingFang.regular.font(size: 12))
//        highlight.setColor(Resources.ffffff.color)
//        highlight.tapAction = {[weak self] (containerView: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) in
//            guard let weakSelf = self else {
//                return
//            }
//            weakSelf.next?.router(event: TTMomentEvent.expand, params: nil)
//        }
//        mAttrStr.yy_setTextHighlight(highlight, range: NSRange(location: 0, length: string.count))
        return mAttrStr
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        label.font = UIFont.systemFont(ofSize: 17)
        var content = "这个 ExpandableLabel 继承自 UILabel，会显示原始文本的前三行，并在末尾显示点击 label 可以展开完整文本内容。需要注意，当 UILabel 的宽度改变时，最大字符数可能需要根据需求调整。你。注意，当 UILabel 的宽度改变时，最大字符数可能需要根据需求调整。你。调整。12345"
        label.text = content
        while (label.isTextTruncated()) {
            print(label.isTextTruncated())
            content.removeLast()
            let tempStr = content + "....展开"
            label.text = tempStr
        }
        label.text = content
        
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! WaterFallCell
        cell.backgroundColor = randomColor()
        cell.titleLabel.text = "\(indexPath.item)"
        return cell
    }
    
    
}

extension ViewController: WaterfallLayoutDelegate2 {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(100) + 22)
    }
}



//extension ViewController: WaterfallLayoutDelegate2 {
//    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(arc4random_uniform(200) + 22)
//    }
//}
