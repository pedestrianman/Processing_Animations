
int cuerpos = 6; //Vertices del hexágono.
int cx = 0; //Origen movimiento
int cy = 0; //Origen movimiento

int a = 450; // Eje mayor de la elipse
int b = 250; // Eje menor de la elipse
int radio = 380;

float mod_vel = 0.005; //Modulo de la velocidad angular

float [] mover_x = new float[cuerpos]; //Coordenada x vertices hexágono
float [] mover_y = new float[cuerpos]; //Coordenada y vertices hexágono
float [] contact_x = new float[cuerpos/2]; // Coordenada x punto de corte rectas
float [] contact_y = new float[cuerpos/2]; // Cooordenada y punto de corte rectas
float[] pos_ang = new float[cuerpos];
float[] pos_ang_ini = new float[cuerpos];
float[] sentido_mov = new float[cuerpos];
float f = PI/180;
float[] max_angle = {random(10, 20)*f, random(10, 20)*f, random(10, 20)*f, random(10, 20)*f, random(10, 20)*f, random(10, 20)*f};


float delta_ang = 2*PI/cuerpos;

float u;
float alpha = 0;
float beta = 0;
float gamma = 0;
PFont mono;
int foto = 1;

void setup()
{

  size(1000, 900);
  float ang_ini = 30*f;
  mono = createFont("font.ttf", 50);
  textFont(mono);

  for (int i = 0; i < cuerpos/2; i++) {

    switch(i) {
    case 0: 
      pos_ang[i] = ang_ini + 10*f;
      pos_ang_ini[i] = pos_ang[i];
      ang_ini += delta_ang;
      sentido_mov[i] = 1;
      break;
    case 1: 
      pos_ang[i] = ang_ini -3*f;
      pos_ang_ini[i] = ang_ini;
      ang_ini += delta_ang;
      sentido_mov[i] = 1;
      break;
    case 2:
      pos_ang[i] = ang_ini + 3*f;
      pos_ang_ini[i] = ang_ini;
      ang_ini += delta_ang;
      sentido_mov[i] = 1;
      break;
    }
  }

  ang_ini = PI + 30*f;
  for (int i = cuerpos/2; i < cuerpos; i++) {

    switch(i) {
    case 3: 
      pos_ang[i] = ang_ini + random(-5*f, 5*f);
      print( random(-5*f, 5*f));
      pos_ang_ini[i] = pos_ang[i];
      ang_ini += delta_ang;
      sentido_mov[i] = 1;
      break;
    case 4: 
      pos_ang[i] = ang_ini + random(-15*f, 15*f);
      pos_ang_ini[i] = ang_ini;
      ang_ini += delta_ang;
      sentido_mov[i] = 1;
      break;
    case 5:
      pos_ang[i] = ang_ini + random(-5*f, 5*f);
      pos_ang_ini[i] = ang_ini;
      ang_ini += delta_ang;
      sentido_mov[i] = 1;
      break;
    }
  }

  pos_ang[4] = -pos_ang[1] ;
  pos_ang_ini[4] = -pos_ang_ini[1] ;
  sentido_mov[4] = -sentido_mov[1];
}

void draw()
{
  translate(width/2, height/2);
  background(25, 25, 25);

  noFill();
  stroke(255, 255, 255, 255);
  strokeWeight(15);
  circle(0, 0, 2*radio); // Descomentar para el caso del círculo.
  //ellipse(0, 0, 2*a, 2*b); //Descomentar para el caso de la elipse.
  
  //Actualización coordenadas de los vertices del hexágono.
  for (int i = 0; i < cuerpos; i++) {
    //float x = (cx + a * cos(pos_ang[i])); //Actualización movimiento x movers en elipse. Descomentar si ploteamos la elipse.
    //float y = (cy + b * sin(pos_ang[i])); //Actualización movimiento y movers en elipse. Descomentar si ploteamos la elipse
    float x = radio* cos(pos_ang[i]); //Actualización movimiento x movers en círculo. Descomentar si ploteamos el círculo.
    float y = radio* sin(pos_ang[i]); //Actualización movimiento y movers en círculo. Descomentar si ploteamos el círculo.
    mover_x[i] = x;
    mover_y[i] = y;
    if (abs(pos_ang[i]-pos_ang_ini[i]) > max_angle[i]) sentido_mov[i] *= -1; 
    pos_ang[i] += mod_vel*sentido_mov[i];
    fill(255, 0, 0);
    noStroke();
    circle(x, y, 25);
  }
  
  // Comenzamos a dibujar las rectas que unen los vértices del hexágono
  if (frameCount > 150) {
    stroke(255, 0, 0, alpha);
    strokeWeight(1);
    line(mover_x[0], mover_y[0], mover_x[3], mover_y[3]);  
    line(mover_x[0], mover_y[0], mover_x[4], mover_y[4]);
    line(mover_x[1], mover_y[1], mover_x[3], mover_y[3]);  
    line(mover_x[1], mover_y[1], mover_x[5], mover_y[5]);
    line(mover_x[2], mover_y[2], mover_x[4], mover_y[4]);  
    line(mover_x[2], mover_y[2], mover_x[5], mover_y[5]);
    alpha += 1;
  }

  //Pto intreseccion rectas definidas por (P0,P4)-(P1,P5)
  u = calcula_u(mover_x[0], mover_y[0], mover_x[4], mover_y[4], mover_x[1], mover_y[1], mover_x[5], mover_y[5]);
  contact_x[0] = mover_x[0] + u*( mover_x[4]-mover_x[0]); 
  contact_y[0] = mover_y[0] + u*( mover_y[4]-mover_y[0]);


  //Pto intreseccion rectas definidas por (P2,P5)-(P0,P3)
  u = calcula_u(mover_x[2], mover_y[2], mover_x[5], mover_y[5], mover_x[0], mover_y[0], mover_x[3], mover_y[3]);
  contact_x[1] = mover_x[2] + u*( mover_x[5]-mover_x[2]); 
  contact_y[1] = mover_y[2] + u*( mover_y[5]-mover_y[2]);

  //Pto intreseccion rectas definidas por (P2,P4)-(P1,P3)
  u = calcula_u(mover_x[2], mover_y[2], mover_x[4], mover_y[4], mover_x[1], mover_y[1], mover_x[3], mover_y[3]);
  contact_x[2] = mover_x[2] + u*( mover_x[4]-mover_x[2]); 
  contact_y[2] = mover_y[2] + u*( mover_y[4]-mover_y[2]);
  
  //Dibujamos la recta que une los puntos de interesección.
  if (frameCount > 400) {
    stroke(255, 255, 255, gamma);
    strokeWeight(4);
    line(contact_x[0], contact_y[0], contact_x[1], contact_y[1]);
    line(contact_x[1], contact_y[1], contact_x[2], contact_y[2]);
    gamma += 1.5;
  }
  
  //Dibujamos los puntos de intersección.
  if (frameCount > 300) {
    for (int i=0; i<cuerpos/2; i++) {
      fill(0, 0, 255, beta);
      noStroke();
      circle(contact_x[i], contact_y[i], 20);
      beta += 2;
    }
  }

  fill(255, 255, 255, 150);
  text("@Inaki_Huarte", 100, 410);

  // GUARDO FRAMES //

  /*String Filename;
   Filename = "Circle/frame_" + foto + ".png";
   saveFrame(Filename);
   foto += 1;*/
}

//Calculo de los puntos de corte entre rectas
float calcula_u (float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  float u, numerador, denominador;

  numerador = (x4-x3)*(y1-y3)-(y4-y3)*(x1-x3);
  denominador = (y4-y3)*(x2-x1)-(x4-x3)*(y2-y1);

  u = numerador/denominador;
  return u;
}
