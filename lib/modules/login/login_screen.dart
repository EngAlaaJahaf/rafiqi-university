import 'package:flutter/material.dart';
// صفحة تسجيل الدخول 
class Login extends StatelessWidget {
   Login({super.key});
var emailController = TextEditingController();
var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle:true ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 12,
                // ),
                 Text('تسجيل الدخول',
                style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
                ),
                // CircleAvatar(
                //   child: 
                //   Image.network('https://picsum.dev/300/200'),),
                 SizedBox(
                  height: 20,
                ),
               
              
                SizedBox(),
               TextFormField(
                controller: emailController,
                onFieldSubmitted: (String value)
                {
                  print(value);
                },
                keyboardType:TextInputType.emailAddress ,
                  decoration: InputDecoration(
                    labelText: "اسم المستخدم",
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(),
                  ),),
                  SizedBox(
                    height: 20,
                  ),
                TextFormField(
                  controller: passwordController,
                  onFieldSubmitted:(_)
                  {},
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "كلمة المرور",
                    
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20,),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     
                      TextButton(
                        onPressed: (){},
                         child: Text('إنشئ حساب')),
                          Text('ليس لديك حساب'),
                    ],
                   ),
                // SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  color: Colors.blue,
                  // color: Colors.blue,
                  child: MaterialButton(
                    onPressed: (){
                      print(emailController.text);
                      print(passwordController.text);
                    },
                     child: Text('تسجيل الدخول')),
                ),
                  
              ],
            
            ),
          ),
        ),
      ),

    );
  }
}