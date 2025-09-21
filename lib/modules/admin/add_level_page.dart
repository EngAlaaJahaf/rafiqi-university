import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/level.dart';
import 'package:rafiqi_university/model/repository/levels_repository.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';
import 'package:rafiqi_university/shared/components/reusable_list_item.dart';

class AddLevelPage extends StatefulWidget {
  const AddLevelPage({super.key, required VoidCallback toggleTheme});

  @override
  State<AddLevelPage> createState() => _AddLevelPageState();
}

class _AddLevelPageState extends State<AddLevelPage> {
  final LevelsRepository _levelsRepo = LevelsRepository.instance;
  late Future<List<Level>> _levelsFuture;


@override  void initState() {
    super.initState();
    _refreshLevels();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 4. اقرأ الـ ViewModel وقم بتعيين وظيفة الزر العائم الخاصة بهذه الشاشة
      Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);
    });
}
    @override
  void dispose() {
    // 5. (مهم جدًا) قم بإزالة وظيفة الزر عند مغادرة الشاشة
    // هذا يضمن عدم ظهور الزر في الشاشة التالية عن طريق الخطأ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
      }
    });
    super.dispose();
  }
  Future<void> _refreshLevels() async {
    setState(() {
      _levelsFuture = LevelsRepository.instance.getAll();
    });
  }
  void _openAddDialog({Level? level}) async {
    // جلب جميع المستويات مسبقًا للتحقق من التكرار
    final List<Level> existingLevels = await _levelsRepo.getAll();
    
    final fields = [
      FormFieldConfig(
        name: 'level_number',
        label: 'رقم المستوى',
        initialValue: level?.number != null ? level!.number.toString() : null, // دعم التعديل
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء إدخال رقم المستوى';
          }
          
          final number = int.tryParse(value);
          if (number == null || number <= 0) {
            return 'الرجاء إدخال رقم صحيح أكبر من صفر';
          }
          
          // التحقق مما إذا كان رقم المستوى موجودًا بالفعل
          for (var existingLevel in existingLevels) {
            if (existingLevel.number == number && existingLevel.id != level?.id) {
              return 'هذا المستوى موجود مسبقاً';
            }
          }
          
          return null;
        },
      ),
      FormFieldConfig(
        name: 'level_name',
        label: 'المستوى',
        initialValue: level?.name, // دعم التعديل
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال المستوى' : null, keyboardType: TextInputType.text,
      ),
      
    ];
    
    Future<void> onSave(Map<String, dynamic> data) async {
      final newLevel = Level(
        id: level?.id,
        number: int.parse(data['level_number']),
        // number: ['level_number'],
        name: data['level_name'],
      );
      if (level == null) {
        await _levelsRepo.create(newLevel);
      } else {
        await _levelsRepo.update(newLevel);
      }
      _refreshLevels();
    }
    
    showDialog(
      context: context,
      builder: (context) => ReusableFormDialog(
        title: level == null ? 'إضافة مستوى' : 'تعديل المستوى',
        fields: fields,
        onSave: onSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder <List<Level>>(
      future: _levelsFuture, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد مستويات مضافة.'));
        } else {
          final levels = snapshot.data!;
          return ListView.builder(
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final level = levels[index];
              return ReusableListItem(
                title: '${level.name} ',
                subtitle: 'مستوى- ${level.number}',
                onTap: () => _openAddDialog(level: level),
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تأكيد الحذف'),
                      content: const Text('هل أنت متأكد من حذف هذا المستوى؟'),
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
                  );
                  if (confirm == true) {
                    await _levelsRepo.delete(level.id!);
                    _refreshLevels();
                  }
                },
                onEdit: () => _openAddDialog(level: level),
              );
            },
          );
        }
      });
  }
}
