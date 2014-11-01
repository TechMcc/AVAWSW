#include <Servo.h>
int i,val;
Servo myservo;
void setup(){
  pinMode(3,OUTPUT);
  pinMode(4,OUTPUT);
  myservo.attach(9);
  Serial.begin(9600);
}


void loop(){
  if(Serial.available()){
	if( Serial.read() == 'T'){      
	  Serial.println("Get!!");
	  for(int cou = 0;cou < 5;cou++){
		digitalWrite(3,HIGH);
                digitalWrite(4,HIGH);
               while(i < 45){
		  delay(10);
		  val = 45 - i;
		  myservo.write(val);
		  i++;
		}
		i = 0;
                digitalWrite(3,LOW);
               digitalWrite(4,LOW); 
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
