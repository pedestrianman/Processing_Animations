
float x = 10; //Condicion inicial x
float y = 10; //Condicion inicial y
float z = 10; //Condicion inicial z

float a = 10; //Sigma
float b = 28; //Rho
float c = 8.0/3.0; //Beta

ArrayList<PVector> points = new ArrayList<PVector>(); //Trayectoria del atractor

import peasy.*;
PeasyCam cam;
float rotation = 0.005; //Velocidad de rotacion de la camara.
int foto;
PFont mono;
String Filename;

void setup() {
  size(600, 600, P3D);
  colorMode(HSB, 100);
  cam = new PeasyCam(this, 500);
  mono = createFont("font.ttf", 28);
  textFont(mono);
}

void draw() {
  background(0);
  cam.rotateY(rotation);

  //Actualización de parámetros
  float dt = 0.01;
  float dx = (a * (y - x))*dt;
  float dy = (x * (b - z) - y)*dt;
  float dz = (x * y - c * z)*dt;

  x = x + dx;
  y = y + dy;
  z = z + dz;

  points.add(new PVector(x, y, z));

  translate(0, -15, -200);
  scale(7.3);

  float col = 50; //Variable que establece el cambio de color paulatino de la figura.
  noFill();
  strokeWeight(0.3);

  //Creación de la figura recorriendo todos los puntos que la forman y asignando un color disinto cada vez.
  beginShape();
  for (PVector v : points) {
    stroke(col, col, col);
    vertex(v.x, v.y, v.z);

    col += 0.05;
    if (col > 80) {
      col = 50;
    }
  }
  endShape();


  // GUARDAMOS FRAMES //
  /*
  if (frameCount <= 800){
   Filename = "50FPS/frame_" + foto + ".png";
   }else{
   if(frameCount==801)foto = 1;
   Filename = "200FPS/frame_" + foto + ".png";
   }
   //saveFrame(Filename);
   foto += 1;
   
   if(frameCount > 5000){
   exit(); 
   }
   */
}
