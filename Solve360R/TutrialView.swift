import SwiftUI

struct TutrialView: View {
    @Binding var isTutrialSheet: Bool
    @State private var currentPage = 0

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            closeButton

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
        .padding(30)
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Views
private extension TutrialView {

    var closeButton: some View {
        HStack {
            Spacer()
            Button {
                isTutrialSheet = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.gray, .gray.opacity(0.2))
            }
        }
    }

    var nextButton: some View {
        Button(action: {
            if currentPage < 5 {
                withAnimation {
                    currentPage += 1
                }
            } else {
                isTutrialSheet = false
            }
        }) {
            HStack {
                Text(currentPage < 5 ? "Next" : "Start Game")
                Image(systemName: currentPage < 5 ? "arrow.right" : "play.fill")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 15)
            .background(Color.blue)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }

    // MARK: - Tutorial Pages

    var step1: some View {
        TutorialPage(
            title: "Welcome to SpinSolve360!",
            image: Image(systemName: "arkit"),
            description: "This is an AR game where you solve inequalities. Find the hidden number by looking at it from different angles!",
            isResizeImage: true
        )
    }

    var step2: some View {
        TutorialPage(
            title: "Find a Flat Surface",
            image: Image("ex4"),
            description: "Find a flat surface like a desk in a well-lit area. Point your device's camera at the surface to begin detection."
        )
    }

    var step3: some View {
        TutorialPage(
            title: "What's an Inequality?",
            image: nil,
            customContent: {
                VStack {
                    HStack(spacing: 30) {
                        Text("2").font(.system(size: 80, weight: .bold))
                        Text("<").font(.system(size: 80, weight: .light))
                        Text("?").font(.system(size: 80, weight: .bold))
                        Text("<").font(.system(size: 80, weight: .light))
                        Text("6").font(.system(size: 80, weight: .bold))
                    }
                    .padding(.vertical, 40)
                }
            }(),
            description: "An inequality shows the relationship between numbers. In this game, you'll use them to pinpoint the correct value."
        )
    }

    var step4: some View {
        TutorialPage(
            title: "Change Your Perspective",
            image: nil,
            customContent: {
                HStack(spacing: 30) {
                    VStack {
                        Text("Front View")
                            .font(.headline)
                        Image("ex1").resizable().scaledToFit().cornerRadius(10).shadow(radius: 5)
                    }
                    VStack {
                        Text("Back View")
                            .font(.headline)
                        Image("ex2").resizable().scaledToFit().cornerRadius(10).shadow(radius: 5)
                    }
                }
            }(),
            description: "The numbers on the blocks look different from the front and back. You need to walk around to see all sides."
        )
    }

    var step5: some View {
        TutorialPage(
            title: "Find the Answer",
            image: Image("ex3"),
            description: "Combine the inequalities from all four sides (front, back, left, right) to figure out the single number that fits."
        )
    }

    var step6: some View {
        TutorialPage(
            title: "Ready to Play?",
            image: Image(systemName: "gamecontroller.fill"),
            description: "You have 60 seconds to solve as many puzzles as you can. Three mistakes and the game is over. Let's get the highest score!"
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

            Spacer()

            if let image = image {
                    image
                        .resizable()
                        .frame(width:isResizeImage ? 300 : 450, height:isResizeImage ? 300 : 350)
                        .scaledToFit()
                        .foregroundColor(.accentColor)
    //                    .frame(maxHeight: 250)
                        .cornerRadius(10)
            }

            if let content = customContent {
                content
            }

            Spacer()

            Text(description)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
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
    TutrialView(isTutrialSheet: .constant(true))
}
