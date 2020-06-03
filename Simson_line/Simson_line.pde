int vertex = 3; //Vertices del triangulo
int movers = 2; // Cuerpos que se mueven a lo largo del circulo
int radio = 280; //Radio del circulo principal

PVector[] Vertex_Triangle = new PVector[vertex]; // Coordenadas 3 vertices que conforman el triángulo
PVector[] out_off_range_PointsVertex = new PVector[2*vertex]; // Coordenadas de los 2 puntos que utilizo para extender los lados del triángulo.
float[] pos_ang_vertex = new float[vertex]; // Posicion angular de los vertices del triangulo.

PVector[] mover = new PVector[movers]; // Coordena
float [] mover_ang = new float[movers]; // Posicion angular mover
float mod_vel = 0.005; //Modulo de la velocidad angular para los mover
PVector[] Contact_Point_Mover1 = new PVector[vertex]; // Coordenadas puntos de corte del Mover 1 con los lados del triángulo
PVector[] Contact_Point_Mover2 = new PVector[vertex]; // Coordenadas puntos de corte del Mover 2 con los lados del triángulo
PVector[] out_off_range_points_M1 = new PVector[2]; // Coordenadas de los 2 puntos que utilizo para conformar la recta de Simson que forma el Mover 1
PVector[] out_off_range_points_M2 = new PVector[2]; // Coordenadas de los 2 puntos que utilizo para conformar la recta de Simson que forma el Mover 2

PVector contact_point = new PVector(); // Coordenadas del punto de intresección entre las dos rectas
ArrayList<PVector> points = new ArrayList<PVector>(); //Trayectoria seguida por el punto de interseccion para originar el circulo


float delta_ang = radians(70);
PFont mono;
int foto = 1;

float alpha_mover1 = 0; // Alpha para la aparición del mover sobre la circunferencia
float alpha_contact_points_M1 = 0; // Alpha para la aparición de los puntos de interesección entre el Mover 1 y los lados del Triangulo
float alpha_rectas_perp = 0; // Alpha para la aparición de las rectas perpendiculares desde el Mover hasta los lados del Triangulo
float alpha_recta_mov1 = 0; // Alpha para la aparición de la recta de Simson.
float fadeOut = 0;


void setup()
{
  size(800, 800);
  translate(width/2, height/2);
  mono = createFont("font.ttf", 38);
  textFont(mono);

  for (int i = 0; i < vertex; i++) {

    switch(i) {
    case 0: 
      pos_ang_vertex[i] = delta_ang;
      Vertex_Triangle[i] = new PVector(radio*cos(pos_ang_vertex[i]), radio*sin(pos_ang_vertex[i]));
      delta_ang += radians(77);
      break;
    case 1: 
      pos_ang_vertex[i] = delta_ang;
      Vertex_Triangle[i] = new PVector(radio*cos(pos_ang_vertex[i]), radio*sin(pos_ang_vertex[i]));
      delta_ang += radians(130);
      break;
    case 2:
      pos_ang_vertex[i] = delta_ang;
      Vertex_Triangle[i] = new PVector(radio*cos(pos_ang_vertex[i]), radio*sin(pos_ang_vertex[i]));
      break;
    }
  }

  mover_ang[0] = radians(340);
  mover[0] = new PVector(radio*cos(mover_ang[0]), radio*sin(mover_ang[0]));

  mover_ang[1] = mover_ang[0]+radians(180);
  mover[1] = new PVector(radio*cos(mover_ang[1]), radio*sin(mover_ang[1]));
}

void draw()
{

  translate(width/2, height/2);
  background(25, 25, 25);

  // Circulo central
  noFill();
  stroke(255, 255, 255, 120);
  strokeWeight(12);
  circle(0, 0, 2*radio); 

  // Creamos Triangulo //

  noFill();
  stroke(255, 255, 255, 120);
  strokeWeight(5);
  beginShape();
  for (int i = 0; i < vertex; i++) {
    vertex(radio*cos(pos_ang_vertex[i]), radio*sin(pos_ang_vertex[i]));
  }
  endShape(CLOSE);

  stroke(255, 255, 255, 125);
  strokeWeight(2);
  out_off_range_PointsVertex = calculo_puntos_externos_Vertices(Vertex_Triangle);
  for (int i = 0; i < vertex; i++) {
    vline(out_off_range_PointsVertex[i], out_off_range_PointsVertex[i+3]);
  }

  // Añadimos los Vertices del Triangulo //
  
  noStroke();
  fill(255, 0, 0);
  for (int i = 0; i < vertex; i++) {
    vcircle(Vertex_Triangle[i], 13);
  }

  // Añadimos Mover 1 & 2 //
  
  if (frameCount > 600) {
    mover_ang[0] += 0.015;
    mover[0] = new PVector(radio*cos(mover_ang[0]), radio*sin(mover_ang[0]));

    mover_ang[1] += 0.015;
    mover[1] = new PVector(radio*cos(mover_ang[1]), radio*sin(mover_ang[1]));
  }  

  // Añadimos Rectas perpendiculares //

  strokeWeight(2);
  stroke(255, 255, 255, alpha_rectas_perp + fadeOut);

  for (int i = 0; i < 3; i++) {

    //Mover 1
    Contact_Point_Mover1[i] = pto_interseccion(Vertex_Triangle[i], Vertex_Triangle[(i+1)%3], mover[0]);
    vline(Contact_Point_Mover1[i], mover[0]);

    //Mover 2
    Contact_Point_Mover2[i] = pto_interseccion(Vertex_Triangle[i], Vertex_Triangle[(i+1)%3], mover[1]);
    vline(Contact_Point_Mover2[i], mover[1]);
  }

  noStroke();
  fill(0, 0, 255, alpha_mover1+fadeOut);
  vcircle(mover[0], 15);
  vcircle(mover[1], 15);

  // Rectas Simson para mover 1 & 2 //

  stroke(255, 0, 0, alpha_recta_mov1 + fadeOut);
  strokeWeight(4.5);

  out_off_range_points_M1 = calculo_puntos_externos(Contact_Point_Mover1);
  vline(out_off_range_points_M1[0], out_off_range_points_M1[1]);

  out_off_range_points_M2 = calculo_puntos_externos(Contact_Point_Mover2);
  vline(out_off_range_points_M2[0], out_off_range_points_M2[1]);

  // Puntos de contacto Recta Perpendicular con lados del Triangulo //
  
  if (frameCount > 200) {
    fill(0, 255, 0, alpha_contact_points_M1);
    noStroke();
    for (int i = 0; i < vertex; i++) {
      //vcircle(Contact_Point_Mover1[i], 15);
    }
  }
  alpha_mover1 += 2;

  // Modificación de Variables alpha para FadeIn de los elementos
  
  if (frameCount > 200) { 
    alpha_rectas_perp += 0.5;
    alpha_contact_points_M1 += 1.5;
  }
  if (frameCount > 350) alpha_recta_mov1 += 1;

  if (alpha_rectas_perp > 120) alpha_rectas_perp = 120;
  if (alpha_mover1 > 255) alpha_mover1 = 255;
  if (alpha_recta_mov1 > 255) alpha_recta_mov1 = 255;


  // Pto intreseccion rectas //

  float u = calcula_u(out_off_range_points_M1[0].x, out_off_range_points_M1[0].y, out_off_range_points_M1[1].x, out_off_range_points_M1[1].y, 
    out_off_range_points_M2[0].x, out_off_range_points_M2[0].y, out_off_range_points_M2[1].x, out_off_range_points_M2[1].y);

  contact_point.x = out_off_range_points_M1[0].x + u*(out_off_range_points_M1[1].x-out_off_range_points_M1[0].x); 
  contact_point.y = out_off_range_points_M1[0].y + u*(out_off_range_points_M1[1].y-out_off_range_points_M1[0].y); 

  if (frameCount > 350) {
    points.add(contact_point.copy());

    beginShape();
    for (PVector v : points) {
      noFill();
      stroke(250, 157, 0);
      strokeWeight(4);
      noFill();
      vertex(v.x, v.y);
    }
    endShape();
  }

  // Dibujo puntos de intersección de las rectas
  if (frameCount > 350) {
    fill(0, 200, 0, 255+fadeOut);
    noStroke();
    vcircle(contact_point, 15);
  }

  if (frameCount > 750) {
    fadeOut -= 2;
  }

  fill(255, 255, 255, 150);
  text("@Inaki_Huarte", 125, 370);

  // GUARDO FRAMES //

  String Filename;
  Filename = "Intro_SimsonLine/frame_" + foto + ".png";
  //saveFrame(Filename);
  foto += 1;
}


//// FUNCIONES ////

void vcircle(PVector a, float radio) {
  circle(a.x, a.y, radio);
}

void vline(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}

//Calculo de los puntos de corte entre rectas
float calcula_u (float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  float u, numerador, denominador;

  numerador = (x4-x3)*(y1-y3)-(y4-y3)*(x1-x3);
  denominador = (y4-y3)*(x2-x1)-(x4-x3)*(y2-y1);

  u = numerador/denominador;
  return u;
}

PVector pto_interseccion (PVector A, PVector B, PVector C) {

  float numerador = (C.x-A.x)*(B.x-A.x)+(C.y-A.y)*(B.y-A.y); 
  float denominador = (B.x-A.x)*(B.x-A.x) + (B.y-A.y)*(B.y-A.y);
  float u = numerador/denominador;

  PVector pto = new PVector(A.x+u*(B.x-A.x), A.y+u*(B.y-A.y));
  return pto;
}

PVector[] calculo_puntos_externos(PVector[] Contact_Point_Mover1) {

  PVector dir = new PVector(Contact_Point_Mover1[0].x-Contact_Point_Mover1[1].x, Contact_Point_Mover1[0].y-Contact_Point_Mover1[1].y);

  PVector[] Ptos_externos = new PVector[2];

  Ptos_externos[0] = Contact_Point_Mover1[0].copy();
  Ptos_externos[0].add(dir.copy().mult(1000));

  Ptos_externos[1] = Contact_Point_Mover1[0].copy();
  Ptos_externos[1].add(dir.copy().mult(-1000));
  return Ptos_externos;
}

PVector[] calculo_puntos_externos_Vertices(PVector[] Vertex) {

  PVector[] Ptos_externos = new PVector[6];
  PVector dir = new PVector();
  for (int i = 0; i < vertex; i++) {

    dir = new PVector(Vertex[i].x-Vertex[(i+1)%3].x, Vertex[i].y-Vertex[(i+1)%3].y);
    Ptos_externos[i] = Vertex[i].copy();
    Ptos_externos[i].add(dir.copy().mult(-1.35));

    Ptos_externos[i+3] = Vertex[(i+1)%3].copy();
    Ptos_externos[i+3].add(dir.copy().mult(1.35));
  }
  return Ptos_externos;
}
