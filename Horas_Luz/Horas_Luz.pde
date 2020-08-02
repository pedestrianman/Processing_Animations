ArrayList<PVector> Pos_Lines_fin = new ArrayList<PVector>(); //Coordenadas de los puntos extremos de cada barra del histograma radial.

float pos_ang = 0;
float latitud = 0;
float delta_pos_ang = 2*PI/(180.0);
float radio_tierra = 210;
float radio_circulo_12h = 575;
float radio_circulo_24h = 722;
float scale_barra = 6.2;
int day = 1;  // Dia del año;
float subo_bajo = 0; // 0 aumento 1 disminuyo
PImage Tierra;

float per = 365; // Porcentaje total para la barra de evolución anual.
float x;
String message_24h = "24 hours";
String message_12h = "12 hours";
String[] Months = { "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D" };
PFont f;


void setup() {
  size(800, 800);

  // Ajustes de la fuente
  f = createFont("font.ttf", 30, true);
  textFont(f);
  textAlign(CENTER);

  // Ajustes de la animacion
  Tierra = loadImage("Earth.png");

  // Inicializamos para el dia 1

  for (int i= 0; i < 180; i++) {
    PVector Pos = new PVector();

    float altura_barra = calculo_altura_barra(1, latitud);

    Pos.x = (scale_barra*altura_barra + radio_tierra)*cos(pos_ang);
    Pos.y = (scale_barra*altura_barra + radio_tierra) *sin(pos_ang);

    Pos_Lines_fin.add(Pos);
    pos_ang -= delta_pos_ang;


    if (latitud >= 90 && subo_bajo == 0) {
      subo_bajo = 1;
    }
    if (latitud <= -90 && subo_bajo == 1) {
      subo_bajo = 0;
    }

    if (subo_bajo == 0) {
      latitud += 2;
    } else {
      latitud -= 2;
    }
  }
}

void draw() {

  background(25, 25, 25);
  fill(255);
  stroke(255);
  translate(width/2, height/2+38);
  strokeWeight(1);
  
  // Barra de Progreso
  fill(255, 150);
  rect(-350, -height / 2 -30, width - 100, 20);
  fill(0, 255, 0, 200);
  stroke(255);
  x = (day-1) % per;
  rect(-350, -height / 2 -30, (width - 100) * (x/(per-1)), 20);
  fill(255, 255, 255, 120);

  // Texto Sobre barra de progreso
  textSize(25);
  fill(255, 150);
  float anchura_barra = (width - 100) ;
  float delta_mes = anchura_barra/(12.0-1.0);
  float dx_mes = -350;

  for (int i=0; i<Months.length; i++) {
    text(Months[i], dx_mes, -height / 2 + 15);
    dx_mes += delta_mes;
  }

  // Circulos 12 y 24 horas
  textSize(30);
  noFill();
  stroke(120, 120, 120, 100);
  strokeWeight(3);
  circle(0, 0, radio_circulo_12h);
  circle(0, 0, radio_circulo_24h);

  // Plot texto 12 h
  ploteo_texto(message_12h, radio_circulo_12h);
  ploteo_texto(message_24h, radio_circulo_24h);

  // Animacion Barras Histograma Radial
  stroke(255, 255, 0);
  strokeWeight(4);
  for (PVector v : Pos_Lines_fin) {

    line(0, 0, v.x, v.y);
  }

  imageMode(CENTER);
  image(Tierra, 0, 0, 450, 450); 

  day++; // Aumentamos el día
  Pos_Lines_fin.clear(); // Borramos la lista
  pos_ang = 0; // Inicializamos posicion angular

  for (int i= 0; i < 180; i++) {
    PVector Pos = new PVector();

    float altura_barra = calculo_altura_barra(day, latitud);

    Pos.x = (scale_barra*altura_barra + radio_tierra)*cos(pos_ang);
    Pos.y = (scale_barra*altura_barra + radio_tierra) *sin(pos_ang);

    Pos_Lines_fin.add(Pos);
    pos_ang -= delta_pos_ang;

    if (latitud >= 90 && subo_bajo == 0) {
      subo_bajo = 1;
    }
    if (latitud <= -90 && subo_bajo == 1) {
      subo_bajo = 0;
    }

    if (subo_bajo == 0) {
      latitud += 2;
    } else {
      latitud -= 2;
    }
  }
  delay(15);

  fill(255, 255, 255, 150);
  text("@Inaki_Huarte", 280, 350);

  // Guardo Frames //ex  
  //saveFrame("Animation/frame_####.png");

  //Fin animacion pasado un año
  if (day > 365) {
    exit();
  }
}

//// END MAIN ROUTINES //// 

// Functions //
float calculo_altura_barra (int dia, float latitud) {

  if (abs(latitud) == 90) {
    latitud *= -1;
  }

  float h;
  float theta = 0.2163108 + 2*atan(0.9671396*tan(.00860*(dia-186)));
  float phi = asin(0.39795*cos(theta));
  float arc_cos_param = (sin(0.8333*PI/180.0) + sin(latitud*PI/180.0)*sin(phi))/(cos(latitud*PI/180.0)*cos(phi));

  if (arc_cos_param > 1.0) {
    arc_cos_param = 1.0;
  }

  if (arc_cos_param < -1.0) {
    arc_cos_param = -1.0;
  }
  float arcocoseno = acos(arc_cos_param);

  h = 24 - ((24/PI)* arcocoseno);
  return h;
}


void ploteo_texto(String message, float radio_circulo) {

  float arclength = 0;
  for (int i = 0; i < message.length(); i++)
  {
    char currentChar = message.charAt(i);
    float w = textWidth(currentChar);
    arclength += w/2;
    float theta = 2.5*PI/2. + arclength / (radio_circulo/2.0);    

    pushMatrix();
    translate((radio_circulo/2.0 + 7)*cos(theta), (radio_circulo/2.0 + 7)*sin(theta));
    rotate(theta+PI/2); // rotation is offset by 90 degrees
    fill(255);
    text(currentChar, 0, 0);
    popMatrix();

    arclength += w/2;
  }
}
