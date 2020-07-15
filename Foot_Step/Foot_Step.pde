
int a=80; // Lado del cuadrado en pixeles
int b=40; //Posicion y de los cuadrados
int s=0; // 0 para límite inferior 1 para límite superiro
float alpha_rect = 255; // Para quitar el fondo
float alpha_amarillo = 0; //Para cambiar el color amarillo a negro
PFont mono;
int foto = 0;

void setup() {
  size(760, 320);
  mono = createFont("font.ttf", 23);
  textFont(mono);
}

void draw() {
  background(210, 210, 210);

  s = comprueba_posicion(b, s);
  b = direccion_movimiento(b, s);

  //Rectangulos Fondo
  rectMode(CORNER);
  noStroke();
  fill(0,0,0,alpha_rect);
  
  //Fade In/Out Rectangulos
  if(frameCount > 200 && frameCount < 350) /*alpha_amarillo += 2;*/alpha_rect -= 2; //Comentar alguna de las dos para cada versión de la animación
  if(frameCount > 450)  /*alpha_amarillo -= 2;*/alpha_rect += 3; //Comentar alguna de las dos para cada versión de la animación
  if(frameCount > 950) exit();
  
  for (int y=0; y<300; y=y+40) {
    rect(0, y, 800, 20);
  }
  
  //Cuadrados
  rectMode(CENTER);
  //Azul
  fill(0, 0, 70);
  rect(320, b, a, a);
  rect(640, b, a, a);
  //Amarillo
  fill(255-alpha_amarillo, 255-alpha_amarillo, 0);
  rect(160, b, a, a);
  rect(480, b, a, a);
  
  fill(25, 25, 25);
  text("@Inaki_Huarte", 585, 315);

  // GUARDO FRAMES //

  String Filename;
  Filename = "AnimationV1/frame_" + foto + ".png";
  saveFrame(Filename);
  foto += 1;
}

// Definicion de Funciones //

int comprueba_posicion (int b, int s) {

  if (b >=height-a/2) {
    s=1;
  }
  if (b==a/2) {
    s=0;
  }
  return s;
}

int direccion_movimiento (int b, int s) {

  if (s==0) {
    b++;
  } else {
    b--;
  }
  return b;
}
