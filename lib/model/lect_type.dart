class LectType {
  final int? id;
  final String name;


  LectType({required this.id, required this.name});

  Map<String, dynamic> toMap() =>{
   
      'lect_type_id': id,
      'lect_type_name': name,
    
  };

  factory LectType.fromMap(Map<String, dynamic> map) =>LectType(
    
      id: map['lect_type_id'] ,
      name: map['lect_type_name'] ,
    );
  
}