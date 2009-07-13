// Display a cube and orient it based on vectors.
import processing.opengl.*;
import processing.serial.*;
import java.nio.*;
import java.util.LinkedList;

Serial port;
float x, y, z;

void setup() {
  size(1024, 768, OPENGL);
  perspective();

  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  port.bufferUntil(10);
}

void draw() {
  background(200);
  
  lights();
  translate(width / 2, height / 2, 0);

  float phi = atan2(y, x);
  float theta = acos(z / sqrt(sq(x) + sq(y) + sq(z)));
  println(phi + "\t" + theta);
  
//  rotateZ(phi);
  rotateX(theta);

//  rotateY(PI * ((float) mouseX / width));
//  rotateX(PI * -((float) mouseY / height));
  box(400);
}

void serialEvent(Serial p) {
  String input = p.readString().trim();
  // Check that it's well formed.
  if (!input.matches("\\d{1,3},\\d{1,3},\\d{1,3},\\d")) {
     println("Invalid: " + input); 
     return;
  }

  // Convert values to integers
  String[] parts = input.split(",");
  int ints[] = new int[4];
  for (int i = 0; i < 4; i++) {
    ints[i] = Integer.parseInt(parts[i]);
  }
  
  // Compare parity.
  if (ints[3] != (ints[0] + ints[1] + ints[2]) % 10) {
     println("Corrupt: " + input);
     return;
  }
  
  // Convert values to floats
  float floats[] = new float[4];
  for (int i = 0; i < 4; i++) {
    floats[i] = map(ints[i], 0, 640, -3, 3);
  }
  
//  println(input);
  // Remap the values from the sensor style axis to processing's
  x = map(ints[0], 0, 640, -3, 3);
  y = map(ints[1], 0, 640, -3, 3);
  z = map(ints[2], 0, 640, -3, 3);
  
//      println(x + " " + y + " " + z);
}

