//
//  ConditionLayoutswift
//  A1
//
//  Created by Francis Z on 31/8/2024.
//

import SwiftUI

struct TriangleLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else {return .zero}
        let subviewSizes = subviews.map{$0.sizeThatFits(.unspecified)}
        
        let maxSize: CGSize = subviewSizes.reduce(.zero) { currentMax, subviewSize in
                CGSize(
                    width: max(currentMax.width, subviewSize.width),
                    height: max(currentMax.height, subviewSize.height))
            }
        return maxSize
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
            let spacing: CGFloat = 10
            let size = subviews[0].sizeThatFits(proposal)
            
            let horizontalSpacing = (bounds.width - 3 * size.width - 2 * spacing) / 2
            let verticalSpacing = (bounds.height - 2 * size.height - spacing) / 2
            
            let topSubview = subviews[0]
            topSubview.place(
                at: CGPoint(
                    x: bounds.midX - size.width / 2,
                    y: bounds.minY + verticalSpacing
                ),
                proposal: ProposedViewSize(size)
            )
            
            let bottomLeftSubview = subviews[1]
            bottomLeftSubview.place(
                at: CGPoint(
                    x: bounds.minX + horizontalSpacing,
                    y: bounds.maxY - size.height - verticalSpacing
                ),
                proposal: ProposedViewSize(size)
            )

            let bottomCenterSubview = subviews[2]
            bottomCenterSubview.place(
                at: CGPoint(
                    x: bounds.midX - size.width / 2,
                    y: bounds.maxY - size.height - verticalSpacing
                ),
                proposal: ProposedViewSize(size)
            )
            
            let bottomRightSubview = subviews[3]
            bottomRightSubview.place(
                at: CGPoint(
                    x: bounds.maxX - size.width - horizontalSpacing + 20,
                    y: bounds.maxY - size.height - verticalSpacing
                ),
                proposal: ProposedViewSize(size)
            )
        }

    
}
