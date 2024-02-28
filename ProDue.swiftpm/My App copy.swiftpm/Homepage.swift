import SwiftUI

struct HomePage: View {
    @State private var tasks: [Task] = [
        Task(name: "Task 1", time: "9:00 AM - 11:00 AM", category: "Development"),
        Task(name: "Task 2", time: "1:00 PM - 2:30 PM", category: "Design"),
        Task(name: "Task 3", time: "3:00 PM - 4:30 PM", category: "Research")
    ]
    @State private var isSecondPagePresented = false
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var totalTasksCount: Int {
        tasks.count
    }
    
    var completionPercentage: Double {
        totalTasksCount == 0 ? 0 : Double(completedTasksCount) / Double(totalTasksCount) * 100
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Section
            HStack {
                Spacer()
                Text("HomePage")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                Spacer()
            }
            .background(Color.white)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
            
            // Today's Progress Summary
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue)
                .frame(height: 150)
                .overlay(
                    HStack(spacing: 16) {
                        // Progress Circle Chart
                        if completionPercentage < 100 {
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 10)
                                    .opacity(0.3)
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(completionPercentage / 100, 1.0)))
                                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(.white)
                                    .rotationEffect(Angle(degrees: -90))
                                Text("\(Int(completionPercentage))%")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 80, height: 80)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Today's Progress ")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.top, 16)
                            Text("\(completedTasksCount) out of \(totalTasksCount) Tasks Completed")
                                .foregroundColor(.white)
                            Text("\(Int(completionPercentage))% Completed")
                                .foregroundColor(.white)
                            // Concise task names here
                        }
                        .padding()
                    }
                )
                .padding()
                .background(Color.white)
            
            // Today's Task Section
            HStack {
                Text("Today's Task")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            .background(Color.white)
            
            // Task Boxes
            ForEach(tasks, id: \.id) { task in
                TaskBox(task: task) {
                    toggleTaskCompletion(task: task)
                } deleteTask: {
                    tasks.removeAll(where: { $0.id == task.id })
                }
                .background(Color.white)
            }
            
            // Spacer to move the plus button to the bottom center
            Spacer()
            
            // Add Task Button at the bottom center
            Button(action: {
                isSecondPagePresented.toggle()
            }) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                    )
            }
            .padding(.bottom, 20)
            .background(Color.white)
            .fullScreenCover(isPresented: $isSecondPagePresented) {
                SecondPage { newTask in
                    // Handle task creation and update tasks
                    tasks.append(newTask)
                    // Dismiss the SecondPage
                    isSecondPagePresented.toggle()
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all) // Take up the whole screen
    }
    
    func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}


struct TaskBox: View {
    var task: Task
    @State private var completed = false
    var toggleTaskCompletion: () -> Void
    var deleteTask: () -> Void
    
    var body: some View {
        HStack {
            // Display image based on category
            switch task.category {
            case "Design":
                Image("JPEG image 1") // Replace "design_image" with the name of your JPEG image asset for design
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding()
            case "Development":
                Image("JPEG image") // Replace "development_image" with the name of your JPEG image asset for development
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding()
            case "Research":
                Image("PNG image 1") // Replace "research_image" with the name of your PNG image asset for research
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding()
            case "Academics":
                Image("PNG image 2") // Replace "academics_image" with the name of your PNG image asset for academics
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding()
            case "Coding":
                Image("PNG image 3") // Replace "coding_image" with the name of your PNG image asset for coding
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding()
            default:
                Image(systemName: "bell")
                    .foregroundColor(.blue)
                    .padding()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(task.time)
                    .font(.caption)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            HStack {
                Image(systemName: completed ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundColor(completed ? .green : .black)
                    .onTapGesture {
                        toggleTaskCompletion()
                        completed.toggle()
                    }
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .onTapGesture {
                        deleteTask()
                    }
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct Task: Identifiable {
    var id = UUID()
    var name: String
    var time: String
    var isCompleted: Bool = false
    var category: String
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
