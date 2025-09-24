class TimeSlot {
  final int ? id;
  final String   name ;
  final String  startTime;
  final String  endTime;

  TimeSlot ({this.id, required this.name,required this.startTime,required this.endTime});

  Map<String, dynamic> toMap() => {
    'ts_id' : id,
    'ts_name': name,
    'ts_start_time' : startTime,
    'ts_end_time' : endTime,

  };

  factory TimeSlot.fromMap(Map<String, dynamic>Map) =>TimeSlot (
    id: Map['ts_id'],
    name: Map['ts_name'],
    startTime: Map['ts_start_time'],
    endTime: Map['ts_end_time'],

  );
}



// sem_time_slots (
//         ts_id INTEGER PRIMARY KEY AUTOINCREMENT,
//         ts_name TEXT NOT NULL,
//         ts_start_time TEXT NOT NULL,
//         ts_end_time TEXT NOT NULL