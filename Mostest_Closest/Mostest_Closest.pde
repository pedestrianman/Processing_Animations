float alpha = 0;
float d_alpha = 0.025;
int iters = round(2*PI/d_alpha);
int n_planets = 4; //Mercurio, Venus, Tierra, Marte
PImage[] planets_img = new PImage[n_planets];
String[] planets_names = { "Mercurio.png", "Venus.png", "Tierra.png", "Marte.png"};
Mover[] planets = new Mover[n_planets];
float[] radios_orbita = {90, 160, 225, 340};
float[] radios_planeta = {13, 33, 35, 19};
float[] velocidades_angulares = {1.6, 1.18, 1, 0.8};
float[] pos_ang_ini = {1.3*PI/2.,PI/2.,0,5*PI/4.};
float[] long_arco = {40, 30, 20, 30};
ArrayList<PVector> borrar = new ArrayList<PVector>(); 
color[] mycolours = {color(222, 184, 135), color(246, 194, 82), color(115, 150, 220), color(231, 109, 95)};
float alpha_color = 0;
float d_alpha_color = 0;

float[] frecuency = {0, 0, 0, 0};
int max_altura_hist = 400;
int anchura = 80;
PFont f;
float time = 0;

int planeta_target = 3; //0 Mercurio, 1 Venus, 2 Tierra, etc

// MAIN ROUTINES //

void setup() {
  size(1280, 720);

  // Ajustes de la fuente
  f = createFont("font.ttf", 30, true);
  textFont(f);

  for (int i=0; i< planets_names.length; i++) {
    planets_img[i] = loadImage(planets_names[i]);
    float random_pos = random(0, 2*PI); // Posiciones en la orbita aleatorias
    //float random_pos = pos_ang_ini[i]; // Posciones fijas. Mirar vector de pos_ang_ini definido arriba.
    planets[i] = new Mover(random_pos, velocidades_angulares[i], radios_orbita[i], radios_planeta[i], planets_img[i]);
  }
}

void draw() {

  background(0);
  translate(width/2-250, height/2);

  // Dibujamos el sol.
  noStroke();
  fill(255);
  circle(0, 0, 40);

  stroke(255, 60);
  strokeWeight(1);

  alpha = PI/2.;
  for (int i=0; i < iters; i++) {
    //line(0, 0, 800*cos(alpha), 800*sin(alpha));
    gradiant_line(color(255, 60), color(255, 0), 0, 0, 400*cos(alpha), 400*sin(alpha));
    alpha += d_alpha;
  }

  // Calculamos planeta mas cercano a la tierra
  int mostest_closest = 0; // Indice del planeta más cercano a la tierra
  mostest_closest = calcula_planeta_mas_cercano(planets,planeta_target);
  stroke(255);
  strokeWeight(4);
  line(planets[planeta_target].position.x, planets[planeta_target].position.y, planets[mostest_closest].position.x, planets[mostest_closest].position.y);
  frecuency[mostest_closest] += 1;

  // Resto de líneas con alpha color
  for (int i=0; i< planets_names.length; i++) {
    if (i!=planeta_target) {
      stroke(255, 60);
      strokeWeight(2);
      line(planets[i].position.x, planets[i].position.y, planets[planeta_target].position.x, planets[planeta_target].position.y);
    }
  }

  // Añadimos trayectorias a la lista del planeta
  for (int i=0; i< 4; i++) {
    planets[i].add_points_trajectory(planets[i].position.copy());

    if (planets[i].points.size() > long_arco[i]) {
      planets[i].points.remove(0);
    }

    alpha_color = 0;
    d_alpha_color = round(255/long_arco[i]);

    for (int j=0; j<planets[i].points.size()-1; j++) {
      stroke(mycolours[i], alpha_color);
      strokeWeight(5);
      line(planets[i].points.get(j).x, planets[i].points.get(j).y, planets[i].points.get(j+1).x, planets[i].points.get(j+1).y);
      alpha_color += d_alpha_color;
    }
  }

  // Time evolution

  textSize(40);
  text(nf(time, 1, 2)+ " Mars Years", 470, -300);
  time += (velocidades_angulares[planeta_target]*0.055)/(2*PI);
  if (time >= 4.5)exit();

  // Histograma

  pushMatrix();
  translate(400, 180);
  rotate(-HALF_PI);
  textSize(32);
  text("% Time Closest Planet to ", 0, 0);
  imageMode(CENTER);
  image(planets_img[planeta_target], 390, -5, radios_planeta[planeta_target]*1.2, radios_planeta[planeta_target]*1.2);
  popMatrix();

  int cont = 0;
  for (int i=0; i< planets_names.length; i++) {

    if (i != planeta_target) {
      fill(mycolours[i], 200);
      noStroke();
      rect(450 + cont*(anchura + 30), 150, anchura, -max_altura_hist*frecuency[i]/frameCount);
      imageMode(CENTER);
      image(planets_img[i], 450 + cont*(anchura + 30) + anchura/2., -200 + max_altura_hist, radios_planeta[i]*2, radios_planeta[i]*2);
      cont ++;
    }
  }

  // Actualizacion de la trayectoria
  for (int i=0; i< planets_names.length; i++) {
    planets[i].display();
    planets[i].update();
  }

  textSize(30);
  fill(255, 255, 255, 150);
  text("@Inaki_Huarte", 650, 335);

  // Guardo Frames //ex  
  saveFrame("Animation_MCMars/frame_####.png");
}

// END OF THE PROGRAM //

// DEFINITIONS OF ROUTINES //
int calcula_planeta_mas_cercano(Mover[] planets, int planeta_target) {

  int indx = 0;
  float min_distance = 10000;
  float distance = 0;

  for (int i=0; i< planets_names.length; i++) {
    if (i!=planeta_target) {
      distance = dist(planets[i].position.x, planets[i].position.y, planets[planeta_target].position.x, planets[planeta_target].position.y);

      if (distance < min_distance) {
        min_distance = distance;
        indx = i;
      }
    }
  }

  return indx;
}


void gradiant_line( color s, color e, float x, float y, float xx, float yy ) {
  for ( int i = 0; i < 100; i ++ ) {
    stroke( lerpColor( s, e, i/100.0) );
    line( ((100-i)*x + i*xx)/100.0, ((100-i)*y + i*yy)/100.0, 
      ((100-i-1)*x + (i+1)*xx)/100.0, ((100-i-1)*y + (i+1)*yy)/100.0 );
  }
}
