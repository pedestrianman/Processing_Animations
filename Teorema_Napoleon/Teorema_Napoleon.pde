
PVector[] Main_triangle = new PVector[3]; //Puntos Triángulo Inicial
PVector[] Sub_Triangles = new PVector[3]; //Tercer Vértice Triángulos Suplementearios
PVector[] Vels = new PVector[3]; //Velocidad de Movimiento Puntos triangulo principal
PVector[] Center = new PVector[3]; //Centros Triángulos Suplementarios

float[] Espacio_Max_Recorrido = new float[3]; //Límite Maximo permitido para los puntos del Triángulo Principal 
float[] Espacio_Recorrido = new float[3]; //Vector acumulativo del espacio recorrido por los puntos del Triángulo Principal

PVector mover = new PVector(); // Particula que origina el Triángulo Equilatero Final
PVector mover_direction = new PVector(); //Dirección de Movimiento de la Partícula
ArrayList<PVector> points = new ArrayList<PVector>(); //Trayectoria seguida por el mover para originar el triángulo
int target; //Dirección objetivo del mover
float distance = 0; //Distancia entre el mover y el target
int cont = 0; //Número de veces que el mover pasa un vertice. Cuando cont = 3, la animación del mover se para (ya he recorrido todo el triángulo).
int inicio_movimiento = 0; // 0 si se tiene que originar el triángulo final con el mover, 1 si ya se ha originado.

float fadein_mainTriangle = 0; //Valor Alpha para el triángulo inicial
float fadein_SecondTriangles = 0; //Valor Alpha para los triángulos secundarios
float fadein_CenterTriangles = 0; //Valor Alpha para los centros de los triángulos secundarios
float fadein_FinalTriangle = 0;

int foto;
String Filename;
PFont mono;

void setup() {
  size(900, 900);
  mono = createFont("font.ttf", 50);
  textFont(mono);
  for (int i = 0; i< 3; i++) {
    switch(i) {
    case 0: //Inicialización del primer vertice
      Main_triangle[i] = new PVector(100, -200);
      Espacio_Max_Recorrido[i] = 140;
      Espacio_Recorrido[i] = 0;
      Vels[i] = new PVector(random(-1.5, 1.5), random(-1.5, 1.5));
      Center[i] = new PVector(0, 0);
      break;
    case 1: //Inicialización del segundo vertice
      Main_triangle[i] = new PVector(-250, 10);
      Espacio_Max_Recorrido[i] = 100;
      Espacio_Recorrido[i] = 0;
      Vels[i] = new PVector(random(-1.5, 1.5), random(-1.5, 1.5));
      Center[i] = new PVector(0, 0);
      break;
    case 2: //Inicialización del tercer vertice
      Main_triangle[i] = new PVector(140, 50);
      Espacio_Max_Recorrido[i] = 150;
      Espacio_Recorrido[i] = 0;
      Vels[i] = new PVector(random(-1.5, 1.5), random(-1.5, 1.5));
      Center[i] = new PVector(0, 0);
      break;
    }
  }
}

void draw() {

  background(25, 25, 25);
  translate(width/2, height/2);
  noFill();

  strokeWeight(3);
  stroke(255, 255, 255, fadein_mainTriangle);
  fill(233, 233, 233, fadein_mainTriangle);
  vtriangle(Main_triangle[0], Main_triangle[1], Main_triangle[2]); //Dibujamos el triángulo principal
  fadein_mainTriangle += 1.5;

  if (fadein_mainTriangle > 200) { //Cuando se haya alcanzado el valor alpha deseado, comenamos el cálculo de los triángulos secundarios.

    fadein_mainTriangle = 200;

    //Cálculo de triángulos secundarios y centros de los mismos.

    float dir = sign((Main_triangle[1].y -  Main_triangle[0].y) * ( Main_triangle[2].x -  Main_triangle[1].x) - ( Main_triangle[1].x -  Main_triangle[0].x) * ( Main_triangle[2].y -  Main_triangle[1].y)); //Triangulo ClockWise o AntiClockWise

    for (int i = 0; i< 3; i++) {

      //Calculo 3 vertice triangulo secundario.
      PVector Aux = new PVector(Main_triangle[(i+1)%3].x - Main_triangle[i].x, Main_triangle[(i+1)%3].y - Main_triangle[i].y); 
      PVector n = new PVector(Aux.y, -Aux.x);
      n.normalize();
      Sub_Triangles[i] = Main_triangle[i].copy();
      Sub_Triangles[i].add(Aux.copy().div(2));
      Sub_Triangles[i].add(n.copy().mult(-dir*sqrt(3)/2*Aux.mag()));

      //Calculo centro triangulo.
      Center[i] = Main_triangle[i].copy();
      Center[i].add(Main_triangle[(i+1)%3].copy());
      Center[i].add(Sub_Triangles[i].copy());
      Center[i].div(3);

      fill(255, 0, 0);
      noStroke();
    }

    //Dibujamos los triángulos secundarios
    for (int i = 0; i< 3; i++) {
      fill(229, 215, 144, fadein_SecondTriangles);
      vtriangle(Sub_Triangles[i], Main_triangle[i], Main_triangle[(i+1)%3]);
    }
    fadein_SecondTriangles += 1;

    if (fadein_SecondTriangles >= 150) { //Se alcanza el límtie en Alpha para los triángulos secundarios
      fadein_SecondTriangles = 150; 

      fill(0, 0, 0, fadein_CenterTriangles); //Comenzamos a dibujar los centros.
      for (int i = 0; i< 3; i++) {
        vcircle(Center[i]);
      }
      fadein_CenterTriangles += 5;

      if (fadein_CenterTriangles > 255 & inicio_movimiento == 0) { //Se alcanza el límite en Alpha para los centros de los triángulos secundarios
        fadein_CenterTriangles = 255;

        //Comenzamos el movimiento del mover y almacenamos todas sus posiciones en un ArrayList.

        if (points.isEmpty()) {
          points.add(Center[0].copy()); 
          mover.set(Center[0].copy());
          mover_direction.set(Center[1].copy());
          mover_direction.sub(Center[0].copy());
          mover_direction.normalize();
          target = 1;
        }

        distance = calculaDistancia(mover, Center[target%3]);
        if (distance < 2) {
          target += 1;
          mover_direction.set(Center[target%3].copy());
          mover_direction.sub(Center[(target-1)%3].copy());
          mover_direction.normalize();
          cont += 1;
          if (cont ==3) inicio_movimiento = 1; //En el momento en el que el mover pasa de nuevo por el vertice del que partió, la animacion del mover se acaba y comienzan a moverse los vértices del triángulo principal
        }

        fill(255, 0, 0);
        mover.add(mover_direction.copy().mult(2.5));
        points.add(mover.copy());
        circle(mover.x, mover.y, 15);

        beginShape();
        for (PVector v : points) {
          stroke(0, 0, 0);
          strokeWeight(3);
          noFill();
          vertex(v.x, v.y);
        }
        endShape();
      }
    }

    // Comienzo movimiento puntos que configuran el triangulo principal

    if (inicio_movimiento == 1) {
      for (int i = 0; i< 3; i++) {
        if (Espacio_Recorrido[i] <= Espacio_Max_Recorrido[i]) {
          Main_triangle[i].add(Vels[i]);
          Espacio_Recorrido[i] += Vels[i].mag();
        } else {
          Vels[i].mult(-1);
          Espacio_Recorrido[i] = 0;
          Espacio_Max_Recorrido[i] += random(-50, 50);
        }
      }
      fill(123, 78, 187, fadein_FinalTriangle);
      stroke(0, 0, 0);
      strokeWeight(3);
      vtriangle(Center[0], Center[1], Center[2]);
      fadein_FinalTriangle += 1;

      if (fadein_FinalTriangle > 150) fadein_FinalTriangle = 150;
    }
  }


  fill(255, 255, 255, 150);
  text("@Inaki_Huarte", 80, 410);

  // Guardo Frames //

  String Filename;
  Filename = "Animation5/frame_" + foto + ".png";
  saveFrame(Filename);
  foto += 1;
}

//Funciones utilizadas //

float sign(float num) {
  return num > 0 ? 1 : -1;
}

void vtriangle(PVector a, PVector b, PVector c) {

  beginShape();
  vertex(a.x, a.y);
  vertex(b.x, b.y);
  vertex(c.x, c.y);
  endShape(CLOSE);
}

void vline(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}

void vcircle(PVector a) {
  circle(a.x, a.y, 15);
}

float calculaDistancia (PVector a, PVector b) {
  float distancia = 0;

  distancia = sqrt((a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y));
  return distancia;
}
