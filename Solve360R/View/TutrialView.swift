import SwiftUI

struct TutrialView: View {
    var body: some View {
        if IsUtils.isPhone {
            TutrialPhoneView()
        } else {
            TutrialViewPad()
        }
    }
}

// 元のiPad用View
struct TutrialViewPad: View {
    @State private var currentPage = 0
    @Environment(\.dismiss) var dismiss

    // MARK: - Body
    var body: some View {
        GeometryReader{ geo in
            ZStack{

                Colors.background
                Group{

                    VStack(spacing: 10) {

                        TabView(selection: $currentPage) {
                            step1.tag(0)
                            step2.tag(1)
                            step3.tag(2)
                            step4.tag(3)
                            step5.tag(4)
                            step6.tag(5)
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

                        nextButton
                    }
                    .padding(.vertical,10)
                    BackButton()
                }
                .padding(30)
            }
        }
//        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Views
private extension TutrialViewPad {

    var closeButton: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                ZStack {
                    // 背景円
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 44, height: 44)

                    // アイコン
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)            }
            .buttonStyle(.plain)
            Spacer()
        }
    }

    var nextButton: some View {
        Button(action: {
            if currentPage < 5 {
                withAnimation {
                    currentPage += 1
                }
            } else {
                dismiss()
            }
        }) {
            HStack {
                Text(currentPage < 5 ? "Next" : "Close")
                Image(systemName: currentPage < 5 ? "arrow.right" : "arrow.down")
            }
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.3, blue: 0.7),
                        Color(red: 0.0, green: 0.2, blue: 0.5)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .padding(.horizontal, 40)
            .padding(.vertical, 15)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.white.opacity(0.95), location: 0.0),
                                .init(color: Color.white.opacity(0.85), location: 1.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Capsule()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.6),
                                        Color.clear
                                    ]),
                                    center: .topLeading,
                                    startRadius: 10,
                                    endRadius: 60
                                )
                            )
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tutorial Pages

    var step1: some View {
        TutorialPage(
            title: "step1.title",
            image: Image(systemName: "arkit"),
            description: "step1.description",
            isResizeImage: true
        )
    }

    var step2: some View {
        TutorialPage(
            title: "step2.title",
            image: Image("ex4"),
            description: "step2.description",
        )
    }

    var step3: some View {
        TutorialPage(
            title: "step3.title",
            image: nil,
            customContent: {
                VStack {
                    HStack(spacing: 30) {
                        Text("2")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.white)
                            .outlineModifier(outlineWidth: 1, outlineRadius: 3, outlineColor: .black)
                        Text("<")
                            .font(.system(size: 80, weight: .light))
                            .foregroundColor(.white.opacity(0.9))
                            .outlineModifier(outlineWidth: 1, outlineRadius: 3, outlineColor: .black)
                        Text("6")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.white)
                            .outlineModifier(outlineWidth: 1, outlineRadius: 3, outlineColor: .black)
                    }
                    .padding(.vertical, 40)
                }
            }(),
            description: "step3.description"
        )
    }

    var step4: some View {
        TutorialPage(
            title: "step4.title",
            image: nil,
            customContent: {
                HStack(spacing: 30) {
                    VStack {
                        Text("Front View")
                            .font(.headline)
                            .foregroundColor(.white)
                            .outlineModifier(outlineWidth: 1, outlineRadius: 2, outlineColor: .black)
                        Image("ex1")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    VStack {
                        Text("Back View")
                            .font(.headline)
                            .foregroundColor(.white)
                            .outlineModifier(outlineWidth: 1, outlineRadius: 2, outlineColor: .black)
                        Image("ex2")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }(),
            description: "step4.description"
        )
    }

    var step5: some View {
        TutorialPage(
            title: "step5.title",
            image: Image("ex3"),
            description: "step5.description"
        )
    }

    var step6: some View {
        TutorialPage(
            title: "step6.title",
            image: Image(systemName: "gamecontroller.fill"),
            description: "step6.description"
        )
    }
}

// MARK: - Tutorial Page Template
struct TutorialPage<CustomContent: View>: View {
    let title: LocalizedStringKey
    let image: Image?
    let customContent: CustomContent?
    let description: LocalizedStringKey
    let isResizeImage: Bool

    init(title: LocalizedStringKey, image: Image?, customContent: CustomContent? = nil, description: LocalizedStringKey,isResizeImage: Bool = false) {
        self.title = title
        self.image = image
        self.customContent = customContent
        self.description = description
        self.isResizeImage = isResizeImage
    }

    var body: some View {
        VStack(spacing: 30) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .outlineModifier(outlineWidth: 1, outlineRadius: 3, outlineColor: .black)

            Spacer()

            if let image = image {
                    image
                        .resizable()
                        .frame(width:isResizeImage ? 300 : 450, height:isResizeImage ? 300 : 300)
                        .scaledToFit()
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.blue,.white,.white,.blue]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }

            if let content = customContent {
                content
            }

            Spacer()

            Text(description)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.white)
                .outlineModifier(outlineWidth: 1, outlineRadius: 2, outlineColor: .black)
        }
        .padding(.bottom, 40)
    }
}

extension TutorialPage where CustomContent == EmptyView {
    init(title: LocalizedStringKey, image: Image?, description: LocalizedStringKey,isResizeImage: Bool = false) {
        self.init(title: title, image: image, customContent: nil, description: description,isResizeImage: isResizeImage)
    }
}


#Preview{
    TutrialViewPad()
}

