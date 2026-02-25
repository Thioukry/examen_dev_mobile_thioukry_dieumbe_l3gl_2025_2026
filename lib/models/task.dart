enum TaskStatus { todo , inProgress,done}
enum TaskPriority {low , meduim,high}

class Task {
  final String id ;
  final String title ;
  final TaskStatus status ;
  final TaskPriority priority;

   Task({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
});

}