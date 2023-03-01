//
//  MyLayout.swift
//  CircularArrangemant
//
//  Created by Ken Oonishi on 2022/11/12.
//

import SwiftUI


/// 円形状にオブジェクト配置するレイアウト設定
struct MyRadialLayout: Layout {

    /// レイアウトコンテナがサブビューを円形に配置するために必要なサイズを計算して返します。
    ///
    /// 今回の実装では、コンテナビューが提案するスペースをすべて使用します。

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        
        // 提供されたスペースはすべて利用する
        proposal.replacingUnspecifiedDimensions()
    }

    
    /// スタックのサブビューを円形に配置するための座標設定をします。
    /// - Parameters:
    ///   - bounds: 親ビューで割当られた領域のサイズ
    ///   - proposal: 親ビューの割当サイズ、もしくは計算して指定した領域のサイズ
    ///   - subviews: 配置するビューの一覧情報。（各ビューのインスタンスを配列状態で持っているらしい）
    ///   - cache: レイアウト計算のキャッシュ（まだ良くわからないので使ってない）
    ///
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        //　円形状配置するときの円の半径
        //　縦横画面領域の小さい値 / 2 - アイコンサイズ
        let radius = min(bounds.size.width, bounds.size.height) / 2 - 40

        
        // TODO
        //　人数が増えたときに、四角形に近い形とかに自然と変形できないか？
        
        
        // アイコン間の角度
        //　円形なので単純にユーザー数で割った値をラジアン値に変換
        let angle = Angle.degrees(360.0 / Double(subviews.count)).radians
        
        
        //配置するアイコンをすべて回して円形になるように座標を設定する
        for (index, subview) in subviews.enumerated() {
            
            //何番目のプレーヤーを手前に表示するかの値を取得
            //（番号はレイアウトバリューキーを使って親ビューからもらう）
            let playernum = subviews[index][MyPlayerNumer.self]

            // 適切な大きさと回転をアファイン変換を使って計算する。
            var point = CGPoint(x: 0, y: radius)
                .applying(CGAffineTransform(
                    rotationAngle: angle * Double(index - playernum)))
            
            // ベクトルを領域の中央に移動させる。
            point.x += bounds.midX
            point.y += bounds.midY

            // サブビューの座標位置を設定.
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}


/// 配列内での自分の並び順
//LayoutValueKeyを使うことで、レイアウト条件内に使用する値を外部から取り込むことができる
private struct MyPlayerNumer: LayoutValueKey {
    static let defaultValue: Int = 0
}

/// 親ビューから値をセットしやすいようにViewを拡張してfuncを追加
extension View {
    func myPlayerNum(_ number: Int) -> some View {
        //LayoutValueKeyを参照した値にデータを格納する
        layoutValue(key: MyPlayerNumer.self, value: number)
    }
}
