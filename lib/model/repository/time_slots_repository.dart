// lib/repositories/assignments_repository.dart
import 'package:rafiqi_university/model/time_slot.dart';
import 'package:rafiqi_university/services/Database_service.dart';

class TimeSlotRepository {
  static final TimeSlotRepository instance = TimeSlotRepository._init();

  TimeSlotRepository._init();
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(TimeSlot timeSlot) async {
    final db = await _dbService.database;
    return await db.insert('sem_time_slots', timeSlot.toMap());
  }

  Future<int> update(TimeSlot timeSlot) async{
    final db = await _dbService.database;
    return await db.update('sem_time_slots', timeSlot.toMap(),where: 'ts_id = ?' , whereArgs: [timeSlot.id]);
    //where: 'cl_id = ?', whereArgs: [classRoom.id]
  }
  Future<int> delete(int id) async{
    final db = await _dbService.database;
    return await db.delete('sem_time_slots', where: 'ts_id = ?' , whereArgs: [id]);
    //where: 'cl_id = ?', whereArgs: [classRoom.id]
  }

  Future<List<TimeSlot>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_time_slots', orderBy: 'ts_id ASC');
    return result.map((json) => TimeSlot.fromMap(json)).toList();
  }
  // ... يمكنك إضافة باقي دوال CRUD (update, delete, getForSubject) بنفس الطريقة
}
