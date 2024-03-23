//
//  WaterfallFlowLayout2.swift
//  MySwiftTest
//
//  Created by qinxinghua on 2024/3/23.
//

import UIKit

import UIKit

class WaterfallLayout2: UICollectionViewFlowLayout {
    weak var delegate: WaterfallLayoutDelegate2?
    // 列数
    let numberOfColumns = 2
    // 存储每列的高度
    var columnHeights: [CGFloat] = []
    // 存储每个单元格的布局属性
    var attributesList: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        
        // 初始化列高数组，全部置为 0
        columnHeights = Array(repeating: sectionInset.top, count: numberOfColumns)
        attributesList.removeAll()
        
        // 计算每个单元格的布局属性
        guard let collectionView = collectionView else { return }
        
        let itemWidth = (collectionView.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns)
        
        // 遍历每个单元格的索引
        for itemIndex in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath) ?? 10
            
            // 找到最短列
            var shortestColumn = 0
            var shortestHeight = columnHeights[0]
            for columnIndex in 1..<numberOfColumns {
                if columnHeights[columnIndex] < shortestHeight {
                    shortestHeight = columnHeights[columnIndex]
                    shortestColumn = columnIndex
                }
            }
            
            // 计算单元格的布局属性
            let xOffset = sectionInset.left + CGFloat(shortestColumn) * (itemWidth + minimumInteritemSpacing)
            let yOffset = columnHeights[shortestColumn]
            let frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            attributesList.append(attributes)
            
            // 更新列高
            columnHeights[shortestColumn] += itemHeight + minimumLineSpacing
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList.filter { rect.intersects($0.frame) }
    }
    
    override var collectionViewContentSize: CGSize {
        let tallestColumnHeight = columnHeights.max() ?? 0
        return CGSize(width: collectionView?.bounds.width ?? 0, height: tallestColumnHeight)
    }
    
}

protocol WaterfallLayoutDelegate2: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}
