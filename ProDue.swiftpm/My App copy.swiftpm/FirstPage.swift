import SwiftUI

struct FirstPageView: View {
    @State private var showHomePage = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image("PNG image") // Replace "yourImageName" with the actual name of your image asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Text("Welcome to ProDue")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundColor(Color.blue)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text("Turn your to-dos into ta-das with our sleek and intuitive task management app – where productivity meets simplicity")
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                NavigationLink(destination: HomePage(), isActive: $showHomePage) {
                    EmptyView()
                }
                
                Button(action: {
                    showHomePage = true
                }) {
                    Text("Let's Start")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                .padding(.bottom)
            }
            .background(Color(#colorLiteral(red: 0.8, green: 0.9, blue: 1, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle
    }
}

struct FirstPageView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView()
    }
}
