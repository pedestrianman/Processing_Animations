
int total = 600;
Mover[] movers = new Mover[total];
PImage bg;
PFont mono;
int foto;

void setup() {

  size(600, 800); //Cambiar Tamaño de Canvas dependiendo de la horientación de la imagen.
  background(0);
  bg = loadImage("MonaLisa.jpg");
  bg.resize(width, height);

  float random = 0;
  for (int i = 0; i < total; i++) {
    random = random(0, 1);
    if (random > 0.5) random = 1;
    else random = -1;
    movers[i] = new Mover(width/2, height/2, width/2, height/2, random, random(3, 10), 0);
  }

  mono = createFont("font.ttf", 33);
  textFont(mono);
}

void draw() {

  for (int i = 0; i < total; i++) {

    Mover circle = movers[i];
    circle.angle += 1/circle.radius*circle.dir;

    circle.position.x += cos(circle.angle) * circle.radius;
    circle.position.y += sin(circle.angle) * circle.radius;
    if (brightness(bg.get(round(circle.position.x), round(circle.position.y))) > 100 || circle.position.x < 0 || circle.position.x > width || circle.position.y < 0 || circle.position.y > height) {
      circle.dir *= -1;
      circle.radius = random(3, 10);
      circle.angle += PI;
    }
    stroke(bg.get((int)circle.position.x, (int)circle.position.y));
    line(circle.presPos.x, circle.presPos.y, circle.position.x, circle.position.y);

    circle.presPos.x = circle.position.x;
    circle.presPos.y = circle.position.y;
  }


  fill(255, 255, 255,180);
  text("@Inaki_Huarte", width - 250, height - 30);

  // GUARDO FRAMES //

  String Filename;
  Filename = "Guernica/frame_" + foto + ".png";
  saveFrame(Filename);
  foto += 1;
}
