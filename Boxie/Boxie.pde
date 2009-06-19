// Display a cube and orient it based on vectors.
import processing.opengl.*;

int x = 300;
int y = 10;
int z = 100;

void setup() {
  size(1024, 768, OPENGL);
  perspective();
}

void draw() {
  background(255);
  
  lights();
  translate(width / 2, height / 2, 0);

//  rotateX(-PI/6);
//rotateY(PI/3);

  rotateY(PI * ((float) mouseX / width));
  rotateX(PI * -((float) mouseY / height));
  box(400);
  
}
