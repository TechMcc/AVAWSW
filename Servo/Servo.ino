#include <Servo.h>
int i,val;
Servo myservo;
void setup(){
  myservo.attach(9);
  Serial.begin(9600);
}


void loop(){
  if(Serial.available()){
	if( Serial.read() == 'T'){      
	  Serial.println("Get!!");
	  for(int cou = 0;cou < 5;cou++){
		while(i < 45){
		  delay(10);
		  val = 45 - i;
		  myservo.write(val);
		  i++;
		}
		i = 0;
		while(i < 45){
		  delay(10);
		  val = i;
		  myservo.write(val);
		  i++;
		}  
		i = 0;
	  }
	}
  }
}
