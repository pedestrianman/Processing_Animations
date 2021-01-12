
int cuerpos = 1;
Mover[] movers = new Mover[cuerpos];

boolean inside_out; // 1 if is outside
boolean corner_hit; // 1 if hit
int radius = 30;
float SSX = 25; // Rectangle Width
float SSY = 15; // Rectangle Height
float rel_xy = SSX/SSY;
int mod_vel = 2; // Velocidad 2 para 25 X 15. Velocidad 
int cont = 0;

float scale = 30; //100 para 8 X 5
ArrayList<PVector> points = new ArrayList<PVector>(); //Trayectoria del atractor
ArrayList<PVector> corners = new ArrayList<PVector>();
ArrayList<PVector> TextPosition = new ArrayList<PVector>();
PFont mono;

int [][] colores = new int [(int)SSY][(int)SSX];
PVector [][] coordenadas_centro = new PVector[(int)SSY][(int)SSX];
int colores_activados;
float alpha = 0;
//////////////////
/* INICIO SETUP */
//////////////////

void setup() {
  size(1000, 700);
  mono = createFont("font.ttf", 33);
  textFont(mono);
  movers[0] = new Mover(-SSX*scale/2, SSY*scale/2, mod_vel*cos(PI/4), -mod_vel*sin(PI/4), radius);
  corners.add(new PVector(-SSX*scale/2., SSY*scale/2., 0)); // Esquina Inferior Izda
  corners.add(new PVector(-SSX*scale/2., -SSY*scale/2., 0)); // Esquina Superior Izda
  corners.add(new PVector(SSX*scale/2., -SSY*scale/2., 0)); // Esquina Superior Dcha
  corners.add(new PVector(SSX*scale/2., SSY*scale/2., 0)); // Esquina Inferior Dcha
}

void draw() {
  background(25, 25, 25);
  noFill();
  strokeWeight(3);
  translate(width/2, height/2);
  int row = 0;
  int col = 0;

  for (int i = (int)-SSX/2; i <= (int)SSX/2; i++) { // CAMBIAR SI EL NUMERO DE COLUMNAS ES PAR

    for (int j = (int)-SSY/2; j <= (int)SSY/2; j++) {

      // Scaling up to draw a rectangle at (x,y)
      float x = i*scale; //+ scale/2; // Esto solo si son pares el número de columnas
      float y = j*scale;
      coordenadas_centro[row][col] = new PVector(x, y, 0);

      if (colores[row][col] == 1) {
        fill(0, 255, 0);
      } else {
        noFill();
      }

      strokeWeight(2);
      stroke(255, alpha);
      rect(x, y, scale, scale);
      row++;
    }
    row = 0;
    col ++;
  }
  alpha += 0.25;

  textSize(45);
  fill(255, 255, 255, 150);
  text(nf((int)SSX, 1), -10, -SSY*scale/2. - 40);
  text(nf((int)SSY, 1), -SSX*scale/2. -40*rel_xy, 10*rel_xy);

  rectMode(CENTER);
  fill(44, 85, 69, 150);
  stroke(128, 64, 0);
  strokeWeight(7);
  rect(0, 0, SSX*scale, SSY*scale);
   
  if (alpha > 80) {
    
    inside_out = FindPoint(movers[0].position.x, movers[0].position.y, SSX*scale/2., SSY*scale/2.); 
    corner_hit = check_corners(movers[0].position.copy(), corners);

    if (corner_hit  && alpha > 100) {
      movers[0].velocity.x = 0.0;
      movers[0].velocity.y = 0.0;
    } else if (inside_out && alpha > 100) {

      cont ++;
      TextPosition.add(new PVector(movers[0].position.x, movers[0].position.y, cont));

      float sign_x =  movers[0].velocity.x/ abs(movers[0].velocity.x);
      float sign_y =  movers[0].velocity.y/ abs(movers[0].velocity.y);

      if (abs(movers[0].position.x) >= SSX*scale/2.) // Toco pared vertical
        movers[0].velocity.rotate(sign_x*sign_y*HALF_PI);
      else {
        movers[0].velocity.rotate(-sign_x*sign_y*HALF_PI);
      }
    }

    points.add(movers[0].position.copy());
    movers[0].update();
    movers[0].display();


    // Actualizamos matrix
    float px = movers[0].position.x + SSX*scale/2.;
    float py = movers[0].position.y + SSY*scale/2.;
    if (px >= SSX*scale) px = SSX*scale - 20;
    if (px <= 0) px = 0;
    if (py >= SSY*scale) py = SSY*scale - 20;
    if (py <= 0) py = 0;
    int columna = floor(px/scale);
    int fila = floor(py/scale);

    PVector Diff = coordenadas_centro[fila][columna].copy().sub(movers[0].position.copy());
    if (Diff.mag() < 15) colores[fila][columna] = 1;
    colores_activados = suma_matriz(colores, (int)SSY, (int)SSX);
  }
  noStroke();
  fill(0, 255, 0, 150);
  rect(-80, SSY*scale/2. + 70, 60, 60);
  textSize(50);
  fill(255, 255, 255, 180);
  text("=  "+nf(colores_activados), -80 + 60, SSY*scale/2. + 80);

  textSize(35);
  fill(255, 255, 255, 180);
  text("@Inaki_Huarte", 250, 330);
  saveFrame("Output/frame_####.png");
}

// Routines

boolean FindPoint(float px, float py, float mid_w, float mid_h) {

  boolean inside_out;
  if (abs(px) <= mid_w & abs(py) <= mid_h) {
    inside_out = false;
  } else {
    inside_out = true;
  }
  return inside_out;
}

boolean check_corners(PVector position, ArrayList<PVector> corners) {

  boolean hit = false;
  PVector aux;
  float mod;

  for (PVector v : corners) {
    aux = position.copy();
    aux.sub(v);
    mod = aux.mag();  
    if (mod < 15) hit = true;
  }

  return hit;
}

int suma_matriz(int[][]colores, int filas, int columnas) {

  int active = 0;

  for (int i = 0; i < filas; i++) {
    for (int j = 0; j < columnas; j++) {
      active += colores[i][j];
    }
  }
  return active;
}
