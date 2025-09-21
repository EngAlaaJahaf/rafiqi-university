import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. استيراد Provider
import 'package:rafiqi_university/layout/fab_view_model.dart'; // 2. استيراد الـ ViewModel
import 'package:rafiqi_university/model/class_room.dart';
import 'package:rafiqi_university/model/repository/class_rooms_repository.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';


class AddClassRoomPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const AddClassRoomPage({super.key, required this.toggleTheme});

  @override
  State<AddClassRoomPage> createState() => _AddClassRoomPageState();
}

class _AddClassRoomPageState extends State<AddClassRoomPage> {
  final ClassRoomsRepository _classRoomsRepo = ClassRoomsRepository.instance;
  
  // final FabsViewModel _fabsViewModel = FabsViewModel();
  
  late Future<List<ClassRoom>> _classRoomsFuture;
  @override
  void initState() {
    super.initState();
    _refreshClassRoom();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);
    });
  }
@override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
      }
    });
    super.dispose();
  }
  Future<void> _refreshClassRoom() async {
    setState(() {
      _classRoomsFuture = ClassRoomsRepository.instance.getAll();
    });
  }
  void _openAddDialog({ClassRoom? classRoom}) {
    final fields = [
      FormFieldConfig(
        name: 'name',
        label: 'اسم القاعة',
        initialValue: classRoom?.name, // دعم التعديل
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم القاعة' : null, keyboardType: TextInputType.text,
      ),
    ];
    
    Future<void> onSave(Map<String, dynamic> data) async {
      final newClassRoom = ClassRoom(
        id: classRoom?.id,
        name: data['name'], toggleTheme: () {  },
      );
      if (classRoom == null) {
        await _classRoomsRepo.create(newClassRoom);
      } else {
        await _classRoomsRepo.update(newClassRoom);
      }
     _refreshClassRoom();
      // Navigator.of(context).pop(true); // إغلاق النافذة مع إشارة إلى نجاح العملية
    }
    showDialog(
      context: context,
       builder:  (context) => ReusableFormDialog(
        title: classRoom == null ? 'إضافة قاعة' : 'تعديل القاعة',
        fields: fields,
        onSave: onSave,
       ),
    ); 


 
}

  @override
  Widget build(BuildContext context) {
  
     return FutureBuilder<List<ClassRoom>>(
      future: _classRoomsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد قاعات مسجلة.'));
        }

        final classRooms = snapshot.data!;
        return ListView.builder(
           padding: const EdgeInsets.all(8.0),
          itemCount: classRooms.length,
          itemBuilder: (context, index) {
            final classRoom = classRooms[index];
            return Card(
               margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Text(classRoom.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      // Await the Future and convert to a boolean condition
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: const Text('هل أنت متأكد من حذف هذه القاعة؟'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('حذف', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ) ?? false;
                      // final rooms = await _classRoomsRepo.getAll();
                      // if (rooms.isNotEmpty) {
                      //   ScaffoldMessenger.of(context)
                      //       .showSnackBar(const SnackBar(content: Text('لا يمكن حذف القاعة لوجود مواعيد مسجلة')));
                      //   return;
                      // }
                      if (confirm == true ) {
                      await ClassRoomsRepository.instance.delete(classRoom.id!);
                      _refreshClassRoom();
                      };
                    },
                  ),
                onTap: () => _openAddDialog(classRoom: classRoom),
                onLongPress: () => _openAddDialog(classRoom: classRoom
              ),
              ),
            );
          },
        );
      },
     );
  }
  }