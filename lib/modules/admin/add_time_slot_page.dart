import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/repository/time_slots_repository.dart';
import 'package:rafiqi_university/model/time_slot.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';
import 'package:rafiqi_university/shared/components/reusable_list_item.dart';

class AddTimeSlotPage extends StatefulWidget {
  const AddTimeSlotPage({super.key, required VoidCallback toggleTheme});

  @override
  State<AddTimeSlotPage> createState() => _AddTimeSlotPageState();
}

class _AddTimeSlotPageState extends State<AddTimeSlotPage> {
  final TimeSlotRepository _timeSlotRepo = TimeSlotRepository.instance;
  late Future<List<TimeSlot>> _timeslotefuture ;

@override
  void initState(){
    super.initState();
    _refreshTimeSlote();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);

    });
  }
@override
void dispose(){
  WidgetsBinding.instance.addPostFrameCallback((_){
    if (mounted){
      Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
    }
  });
  super.dispose();
}
Future<void> _refreshTimeSlote() async{
  setState(() {
    _timeslotefuture = TimeSlotRepository.instance.getAll();
  });
}

void _openAddDialog({TimeSlot? time_slot}){
  final fileds = [
    FormFieldConfig(
      name: 'ts_name',
      label:'اسم الفترة',
      initialValue: time_slot?.name,
      validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم الفترة' : null,
      keyboardType: TextInputType.text,
       ),

    FormFieldConfig(
      name: 'ts_start_time',
      label:'وقت بداية الفترة',
      type:FormFieldType.time ,
     
      initialValue: time_slot?.startTime,
      validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال وقت بداية الفترة' : null,
      keyboardType: TextInputType.datetime, 
      ),

    FormFieldConfig(
      name: 'ts_end_time',
      label:'وقت نهاية الفترة',
      type: FormFieldType.time,
      initialValue: time_slot?.endTime,
      validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال وقت نهاية الفترة' : null,
      keyboardType: TextInputType.datetime,
       ),

  ];

  Future<void> onsave(Map<String, dynamic> data) async {
    final newTimeSlot = TimeSlot(
      name: data['ts_name'],
       startTime: data['ts_start_time'],
        endTime:  data['ts_end_time']
        );
        if (time_slot == null){
          await _timeSlotRepo.create(newTimeSlot);
        }else{
          await _timeSlotRepo.update(newTimeSlot);
        }
        _refreshTimeSlote();
        }
        showDialog(
          context: context, 
          builder: (context) => ReusableFormDialog(
            title: time_slot == null ? 'إضافة فترة جديدة' : 'تعديل بيانات الفترة ',
             fields: fileds,
              onSave: onsave,
          ),
          );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TimeSlot>>(
      future: _timeslotefuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا يوجد فترات زمنية'));
        } else {
          final time_slots = snapshot.data!;
          return ListView.builder(
            itemCount: time_slots.length,
            itemBuilder: (context , index){
              final time_slot = time_slots[index];
              return ReusableListItem(
                leadingIcon: Icons.watch_later_outlined,
                title: '${time_slot.name}',
                 onEdit: () => _openAddDialog(time_slot: time_slot), 
                 onDelete: ()async {
                  await _timeSlotRepo.delete(time_slot.id!);
                  _refreshTimeSlote();
                 });
            } 
            );
        }
      },
    );
  }
}