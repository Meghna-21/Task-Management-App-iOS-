import SwiftUI

struct SecondPage: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var taskName = ""
    @State private var selectedCategory: String? = nil
    @State private var selectedDate = Date()
    @State private var startTime = ""
    @State private var endTime = ""
    @State private var description = ""
    
    var categories = ["Design", "Development", "Research","Academics","Coding"]
    var onTaskCreated: (Task) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Top Section
                HStack {
                    Button(action: {
                        // Navigate back to the first page
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Create New Task")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                
                // Task Name Section
                SectionWithTitle(title: "Task Name") {
                    RoundedTextField(placeholder: "Enter task name", text: $taskName)
                    
                }
                .foregroundColor(.black)
                // Category Section
                SectionWithTitle(title: "Category") {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            CategoryButton(category: category, selectedCategory: $selectedCategory)
                        }
                    }
                }
                
                // Date & Time Section
                SectionWithTitle(title: "Date & Time") {
                    DateSelectionBox(selectedDate: $selectedDate)
                }
                
                // Start Time & End Time Section
                HStack {
                    VStack {
                        SectionWithTitle(title: "Start Time") {
                            TimeSelectionBox(selectedTime: $startTime)
                        }
                        .foregroundColor(.black)
                        
                    }
                    Spacer()
                    VStack {
                        SectionWithTitle(title: "End Time") {
                            TimeSelectionBox(selectedTime: $endTime)
                        }
                        .foregroundColor(.black)
                    }
                    
                }
                .padding(.horizontal)
                
                // Description Section
                SectionWithTitle(title: "Description") {
                    RoundedTextField(placeholder: "Write task description", text: $description)
                        .frame(height: 100)
                }
                .foregroundColor(.black)
                // Create Task Button
                Button(action: {
                    // Create task logic and navigate to the first page
                    let newTask = Task(name: taskName, time: "\(startTime) - \(endTime)", category: selectedCategory ?? "")
                    onTaskCreated(newTask)
                }) {
                    Text("Create Task")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                Spacer(minLength: 0)
            }
            .navigationBarHidden(true)
            .background(Color.white)
        }
    }
}

struct SectionWithTitle<Content: View>: View {
    var title: String
    var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            content()
        }
        .padding(.horizontal)
    }
}

struct RoundedTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.blue, lineWidth: 1))
    }
}

struct CategoryButton: View {
    var category: String
    @Binding var selectedCategory: String?
    
    var body: some View {
        Button(action: {
            selectedCategory = category
        }) {
            Text(category)
                .padding()
                .foregroundColor(selectedCategory == category ? .white : .blue)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(BorderlessButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(selectedCategory == category ? Color.blue : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(selectedCategory == category ? Color.blue : Color.gray, lineWidth: 1)
                )
        )
    }
}


struct DateSelectionBox: View {
    @Binding var selectedDate: Date
    @State private var isCalendarOpen = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                    .padding()
                
                Spacer()
                
                Text(" \(selectedDate, formatter: dateFormatter)")
                    .foregroundColor(.black)
                    .padding()
            }
            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.blue, lineWidth: 1))
            .onTapGesture {
                isCalendarOpen.toggle()
            }
            
            if isCalendarOpen {
                VStack {
                    DatePicker("Select a date", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .padding()
                        .colorScheme(.dark) // Apply dark color scheme
                        .background(Color.gray) // Background color
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            isCalendarOpen = false
                        }) {
                            Text("Done")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                }
                .padding()
                .onDisappear {
                    isCalendarOpen = false
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}


struct TimeSelectionBox: View {
    @Binding var selectedTime: String
    @State private var isDropdownOpen = false
    
    var body: some View {
        HStack {
            RoundedTextField(placeholder: "Select time", text: $selectedTime)
                .onTapGesture {
                    isDropdownOpen.toggle()
                }
            
            Image(systemName: "chevron.down")
                .foregroundColor(.blue)
                .padding()
                .onTapGesture {
                    isDropdownOpen.toggle()
                }
                .popover(isPresented: $isDropdownOpen) {
                    // Dropdown menu with time options
                    VStack {
                        ForEach(0..<24) { hour in
                            Text("\(hour % 12 == 0 ? 12 : hour % 12):00 \(hour < 12 ? "AM" : "PM")")
                                .padding()
                                .onTapGesture {
                                    selectedTime = "\(hour % 12 == 0 ? 12 : hour % 12):00 \(hour < 12 ? "AM" : "PM")"
                                    isDropdownOpen.toggle()
                                }
                        }
                    }
                    .padding()
                }
        }
        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.blue, lineWidth: 1))
    }
}

struct SecondPage_Previews: PreviewProvider {
    static var previews: some View {
        SecondPage { newTask in
            // Handle task creation and update tasks
            // This closure is for preview, you may not need it in the actual app
        }
    }
}

