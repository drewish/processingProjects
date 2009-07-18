// Display a cube and orient it based on vectors.
import processing.opengl.*;
import processing.serial.*;
import java.nio.*;
import java.util.LinkedList;

Serial port;
float x, y, z;

void setup() {
  size(1024, 768, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  perspective();

  textFont(createFont("Monaco", 18));

  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  port.bufferUntil(10);
}

void draw() {
  background(200);

  lights();

  beginCamera();
  float yfrac = map(mouseY, 0, height, -1, 1);
  float xfrac = map(mouseX, 0, width, 0, PI);
  camera(.5 * width * cos(xfrac), .75 * height * -yfrac, .5 * width * sin(xfrac), 0, 0, 0, 0, 1, 0);
  endCamera();

  text("x: " + nfs(x * 100, 3, 1), 10, 20);
  text("y: " + nfs(y * 100, 3, 1), 10, 40);
  text("z: " + nfs(z * 100, 3, 1), 10, 60);
  text("rot 1: " + nfs(atan2(x, z), 1, 2), 10, 80);
  text("rot 2: " + nfs(atan2(z, x), 1, 2), 10, 100);

  // Draw the axis
  line(-500, 0, 0, 500, 0, 0);
  line(0, -350, 0, 0, 350, 0);
  line(0, 0, -500, 0, 0, 500);
  text("x", 500, 0, 0);
  text("y", 0, 350, 0);
  text("z", 0, 0, 500);

   
  stroke(255, 0, 0);
  pushMatrix();
  translate(x * 100, y * 100, z * 100);
  box(5);
  popMatrix();
  
  pushMatrix();
  translate(-x * 100, -y * 100, -z * 100);
  box(5);
  popMatrix();
}

int[] prevSample = new int[3];

void serialEvent(Serial p) {
  String s = p.readString().trim();
  // Check that it's well formed.
  if (!s.matches("\\d{1,3},\\d{1,3},\\d{1,3},\\d")) {
    println(hour() + ":" + nf(minute(), 2) + ":" + nf(second(), 2) + " Invalid: " + s); 
    return;
  }

  // Convert values to integers
  String[] parts = s.split(",");
  int ints[] = new int[4];
  for (int i = 0; i < 4; i++) {
    ints[i] = Integer.parseInt(parts[i]);
  }

  // Compare parity.
  if (ints[3] != (ints[0] + ints[1] + ints[2]) % 10) {
    println(hour() + ":" + nf(minute(), 2) + ":" + nf(second(), 2) + " Corrupt: " + s);
    return;
  }
  
  int[] avg = prevSample.clone();
  for (int i = 0; i < 3; i++) {
    if (abs(ints[i] - prevSample[i]) > 1) {
      prevSample[i] = ints[i];
    }
  }
  
//  println(s);
  // Sensor values range from 0-3.3v but Arduino samples 0-5v so we loose part
  // of it's 0-1023 value range. The axis orientation is different as well so 
  // we need to remap the values from the sensor style axis to processing's:
  // x => -z  y => -x  z => y
  z = map(avg[0], 0, 640, 3, -3);
  x = map(avg[1], 0, 640, 3, -3);
  y = map(avg[2], 0, 640, -3, 3);

//  print(ints[0] + " " + ints[1] + " " + ints[2] + "\t");
//  println(avg[0] + " " + avg[1] + " " + avg[2]);
}


