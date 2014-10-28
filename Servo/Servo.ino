#include <Servo.h>
int i,val;
Servo myservo;
void setup(){
  myservo.attach(9);
}

 
void loop(){
  while(i < 45){
    delay(20);
	val = 45 - i;
    myservo.write(val);
	i++;
  }
  
  i = 0;
 
  while(i < 45){
	delay(20);
	val = i;
	myservo.write(val);
	i++;
  }  
  i = 0;
  
}
