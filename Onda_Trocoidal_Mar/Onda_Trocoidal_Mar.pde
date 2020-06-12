
// Listas para Puntos, Radios y Superficies
ArrayList<PVector> points = new ArrayList<PVector>(); 
ArrayList<Float> radios = new ArrayList<Float>();

ArrayList<PVector> Up = new ArrayList<PVector>(); 
ArrayList<PVector> Left = new ArrayList<PVector>(); 
ArrayList<PVector> Right = new ArrayList<PVector>(); 

ArrayList<PVector> Trayectoria_P1 = new ArrayList<PVector>(); 
ArrayList<PVector> Trayectoria_P2 = new ArrayList<PVector>(); 

//Variables globales
float k = 2*(PI)/3;
float c = sqrt(9.82/k);
float t = 0;
float a = -4.0;
float b = -0.3;
float drift = 0.0;
int ppd = 11; //Filas de partículas
int index;
PFont mono;
int foto = 0;

void setup() {
  size(720, 360);
  mono = createFont("font.ttf", 25);
  textFont(mono);

  // Posiciones iniciales de las particulas
  for (int i = 1; i <= 20; i++) {
    for (int j = 1; j <= 11; j++) {
      points.add(new PVector(X_Coordinate(a, b, t), Y_Coordinate(a, b, t)));
      b += -2.3/ppd;
    }
    a += 0.4;
    b = -0.3;
  }
  // Radios de las trayectorias
  b = -0.3;
  for (int j = 1; j <= 11; j++) {
    radios.add(radius(b));
    b += -2.3/ppd;
  }
  // Regiones Para construir el shader del mar //

  //Up
  a = -4.0;
  b = -0.3;
  for (int i = 1; i <= 80; i++) {
    Up.add(new PVector(X_Coordinate(a, b, t), Y_Coordinate(a, b, t)));
    a += 0.1;
  }

  //Left
  a = -4.0;
  b = -2.0;
  for (int j = 1; j <= 11; j++) {
    Left.add(new PVector(X_Coordinate(a, b, t), Y_Coordinate(a, b, t)));
    b += -2.3/ppd;
  }

  // Rigth
  a =  4.0;
  b = -2.0;
  for (int j = 1; j <= 11; j++) {
    Right.add(new PVector(X_Coordinate(a, b, t), Y_Coordinate(a, b, t)));
    b += -2.3/ppd;
  }
}

void draw() {
  translate(width/2., height/2. - 150);
  background(255);
  noStroke();
  
  // Dibujamos el shader azul para el mar. Es la envolvente de las partículas.
  fill(0, 119, 190, 80);
  beginShape();

  for (PVector v : Up) {
    curveVertex(v.x*140, v.y*-140);
  }
  for (PVector v : Right) {
    curveVertex(v.x*140, v.y*-140);
  }

  for (PVector v : Left) {
    curveVertex(v.x*140, v.y*-140);
  }
  endShape(CLOSE);

  // Dibujamos particulas principales que se mueven.
  
  for (PVector v : points) {
    fill(0.368417*255, 0.506779*255, 0.709798*255);
    circle(v.x*140, v.y*-140, 10);
  }

  // Señalizamos los dos Puntos Higlights.
  stroke(100, 0, 0);
  strokeWeight(2);
  noFill();
  circle(0, 42, 2*radios.get(0)*140);
  circle(0, 130, 2*radios.get(3)*140);
  fill(255, 69, 0);
  noStroke();
  circle(points.get(110).x*140, points.get(110).y*-140, 10);
  circle(points.get(113).x*140, points.get(113).y*-140, 10);

  Trayectoria_P1.add(points.get(110));
  Trayectoria_P2.add(points.get(113));

  // Dibujamos trayectorias de los Puntos Highlights. Es necesario activar Drift.
  /*stroke(255, 0, 0,120);
   strokeWeight(2);
   noFill();
   if (frameCount > 2) {
   // HL1
   beginShape();
   
   for (PVector v : Trayectoria_P1) {
   vertex(v.x*140, v.y*-140);
   }
   endShape();
   // HL2
   beginShape();
   
   for (PVector v : Trayectoria_P2) {
   vertex(v.x*140, v.y*-140);
   }
   endShape();
   }
   */
  t += 0.005;
  //drift += 0.001; //Activación Drift
  if (t > 2*PI/(k*c)) {
    //*noLoop(); // Si solo queremos una vuelta para las partículas.
  }
  
  // Actualizaciones de listas con las nuevas posiciones //
  index = 0;
  a = -4.0;
  b = -0.3;

  // Main Particles
  for (int i = 1; i <= 20; i++) {
    for (int j = 1; j <= 11; j++) {
      points.set(index, new PVector(X_Coordinate(a, b, t)+drift, Y_Coordinate(a, b, t)));
      b += -2.3/ppd;
      index += 1;
    }
    a += 0.4;
    b = -0.3;
  }

  // Up
  index = 0;
  a = -4.0;
  b = -0.3;
  for (int i = 1; i <= 80; i++) {
    Up.set(index, new PVector(X_Coordinate(a, b, t)+drift, Y_Coordinate(a, b, t)));
    a += 0.1;
    index += 1;
  }

  //Left
  index = 0;
  a = -4.0;
  b = -2.0;
  for (int j = 1; j <= 11; j++) {
    Left.set(index, new PVector(X_Coordinate(a, b, t), Y_Coordinate(a, b, t)));
    b += -2.3/ppd;
    index += 1;
  }

  // Rigth
  index = 0;
  a =  4.0;
  b = -2.0;
  for (int j = 1; j <= 11; j++) {
    Right.set(index, new PVector(X_Coordinate(a, b, t), Y_Coordinate(a, b, t)));
    b += -2.3/ppd;
    index += 1;
  }

  fill(25, 25, 25);
  text("@Inaki_Huarte", 175, 320);

  // GUARDO FRAMES //

  String Filename;
  Filename = "NO_Drift/frame_" + foto + ".png";
  //saveFrame(Filename);
  foto += 1;
}

// Functions //

float X_Coordinate(float a, float b, float t) {
  return a+exp(k*b)/k *sin(k*(a-c*t));
}

float Y_Coordinate(float a, float b, float t) {
  return b-exp(k*b)/k *cos(k*(a-c*t));
}

float radius(float b) {
  return exp(k*b)/k;
}
void vcircle(PVector a, float radio) {
  circle(a.x, a.y, radio);
}

void vline(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}
