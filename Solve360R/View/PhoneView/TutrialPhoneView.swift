import SwiftUI

struct TutrialPhoneView: View {
    @State private var currentPage = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Colors.background
            
            Group{
                VStack(spacing: 0) {
                    // ヘッダー

                    // メインコンテンツ
                    TabView(selection: $currentPage) {
                        PhoneTutorialPage(
                            title: "step1.title",
                            icon: "arkit",
                            description: "step1.description",
                            isSystemImage: true
                        ).tag(0)

                        PhoneTutorialPage(
                            title: "step2.title",
                            imageName: "ex4",
                            description: "step2.description"
                        ).tag(1)

                        PhoneTutorialPage(
                            title: "step3.title",
                            customContent: {
                                HStack(spacing: 15) {
                                    Text("2").font(.system(size: 50, weight: .bold)).foregroundColor(.white)
                                    Text("<").font(.system(size: 50, weight: .light)).foregroundColor(.white)
                                    Text("6").font(.system(size: 50, weight: .bold)).foregroundColor(.white)
                                }
                            },
                            description: "step3.description"
                        ).tag(2)

                        PhoneTutorialPage(
                            title: "step4.title",
                            customContent: {
                                VStack(spacing: 10) {
                                    VStack(spacing: 5) {
                                        Text("Front View").font(.caption2).foregroundColor(.white)
                                        Image("ex1").resizable().scaledToFit().frame(width: 120).cornerRadius(8)
                                    }
                                    VStack(spacing: 5) {
                                        Text("Back View").font(.caption2).foregroundColor(.white)
                                        Image("ex2").resizable().scaledToFit().frame(width: 120).cornerRadius(8)
                                    }
                                }
                            },
                            description: "step4.description"
                        ).tag(3)

                        PhoneTutorialPage(
                            title: "step5.title",
                            imageName: "ex3",
                            description: "step5.description"
                        ).tag(4)

                        PhoneTutorialPage(
                            title: "step6.title",
                            icon: "gamecontroller.fill",
                            description: "step6.description",
                            isSystemImage: true
                        ).tag(5)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    // カスタムページインジケーター（小さい）
                    HStack(spacing: 8) {
                        ForEach(0..<6) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                    .padding(.vertical, 8)

                    // Next/Closeボタン
                    Button(action: {
                        if currentPage < 5 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            dismiss()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(currentPage < 5 ? "Next" : "Close")
                            Image(systemName: currentPage < 5 ? "arrow.right" : "checkmark")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.bottom, 15)
                }
                BackButton()
            }
            .padding(20)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Phone Tutorial Page Component
struct PhoneTutorialPage<CustomContent: View>: View {
    let title: LocalizedStringKey
    let icon: String?
    let imageName: String?
    let customContent: CustomContent?
    let description: LocalizedStringKey
    let isSystemImage: Bool
    
    init(
        title: LocalizedStringKey,
        icon: String? = nil,
        imageName: String? = nil,
        customContent: (() -> CustomContent)? = nil,
        description: LocalizedStringKey,
        isSystemImage: Bool = false
    ) {
        self.title = title
        self.icon = icon
        self.imageName = imageName
        self.customContent = customContent?()
        self.description = description
        self.isSystemImage = isSystemImage
    }
    
    var body: some View {
        HStack(spacing: 50) {
            Spacer()
            
            // 左側: 画像エリア
            VStack {
                if let icon = icon {
                    if isSystemImage {
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .white, .white, .blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                } else if let imageName = imageName {
                    Image(imageName)
                        .resizable()
//                        .scaledToFit()
                        .frame(width: 200, height: 180)
                        .cornerRadius(10)
                } else if let content = customContent {
                    content
                }
            }
            .frame(width: 180)
//            .border(.red)

            // 右側: テキストエリア
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
//            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

// EmptyView用の拡張
extension PhoneTutorialPage where CustomContent == EmptyView {
    init(
        title: LocalizedStringKey,
        icon: String? = nil,
        imageName: String? = nil,
        description: LocalizedStringKey,
        isSystemImage: Bool = false
    ) {
        self.title = title
        self.icon = icon
        self.imageName = imageName
        self.customContent = nil
        self.description = description
        self.isSystemImage = isSystemImage
    }
}

#Preview {
    TutrialPhoneView()
}
