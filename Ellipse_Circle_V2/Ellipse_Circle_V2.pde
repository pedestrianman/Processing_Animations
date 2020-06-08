
PVector P1 = new PVector();
PVector P2 = new PVector();
PVector P3 = new PVector();
ArrayList<PVector> points = new ArrayList<PVector>(); //Trayectoria seguida por el punto 3

int radio_C1 = 250;
int radio_C2 = 100;
float theta = 0;
float alpha = 255;
PFont mono;
int foto = 0;

void setup() {
  size(720, 720);
  mono = createFont("font.ttf", 40);
  textFont(mono);
  P1 = new PVector(radio_C1*cos(theta), radio_C1*sin(theta));
  P2 = new PVector(radio_C1*cos(theta), 0);
  P3 = new PVector((radio_C2+radio_C1)*cos(theta), (radio_C2+radio_C1)*sin(theta));
}

void draw() {
  translate(width/2, height/2);
  background(255);
  noFill();

  //Circle 1
  strokeWeight(4);
  stroke(100, 0, 0);
  vcircle(new PVector(0, 0), radio_C1*2);

  //Circle 2
  strokeWeight(4);
  stroke(0,100,0);
  vcircle(P2, radio_C2*2);

  //Lines
  stroke(0, alpha);
  vline(new PVector(0, 0), P1);
  vline(P1, P2);
  vline(P2, P3);
  
  //Points Center,1,2,3
  noStroke();
  fill(0);
  vcircle(new PVector(0,0),15);
  fill(100,0,0, alpha);
  vcircle(P1, 15);
  fill(0,100,0, alpha);
  vcircle(P2, 15);
  fill(0.01*255, 0.4*255, 0.5*255, alpha);
  vcircle(P3, 15);

  if (frameCount > 2) {
    points.add(P3.copy());

    beginShape();
    for (PVector v : points) {
      noFill();
      stroke(0.01*255, 0.4*255, 0.5*255);
      strokeWeight(4);
      noFill();
      vertex(v.x, v.y);
    }
    endShape();
  }

  //Update points
  P1 = new PVector(radio_C1*cos(theta), radio_C1*sin(theta));
  P2 = new PVector(radio_C1*cos(theta), 0);
  P3 = new PVector((radio_C2+radio_C1)*cos(theta), (radio_C2)*sin(theta));

  if (theta >= -deg2rad(50)) theta -= 0.015;
  else if (theta >= -deg2rad(320)) theta -= 0.020;
  else theta -= 0.015;

  if (theta <= -2*PI) { 
    theta = -2*PI;
    alpha -= 5;
  }

  fill(25, 25, 25);
  text("@Inaki_Huarte", 65, 320);

  // GUARDO FRAMES //

  String Filename;
  Filename = "Elipse/frame_" + foto + ".png";
  saveFrame(Filename);
  foto += 1;
}

// Functions //

float deg2rad(float degrees) {
  return degrees*(PI/180);
}

void vcircle(PVector a, float radio) {
  circle(a.x, a.y, radio);
}

void vline(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}
