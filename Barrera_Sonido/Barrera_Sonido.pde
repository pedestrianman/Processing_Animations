
Projectile p;
ArrayList<Wave> waves;
PImage Aircraft;
PImage bg;
PFont mono;
int foto = 0;
void setup()
{
  size(800, 500);
  p = new Projectile(width/2, 0, -0.0015, -0.015);
  waves = new ArrayList<Wave>();
  Aircraft = loadImage("Plane.png");
  bg = loadImage("bg.jpg");
  bg.resize(width, height);
  mono = createFont("font.ttf", 35);
  textFont(mono);
}

void draw()
{
  translate(width/2, height/2);
  background(bg);

  p.draw();
  p.update();

  for (Wave w : waves)
  {
    w.draw();
    w.update();
  }

  fill(25, 25, 25,150);
  text("@Inaki_Huarte", 150, 225);

  // GUARDO FRAMES //

  String Filename;
  Filename = "Animation/frame_" + foto + ".png";
  saveFrame(Filename);
  foto += 1;
}


class Projectile
{
  float x, y;
  float vx, vy;
  float ax, ay;

  float r = 20;
  float it = 0;

  Projectile(float _x, float _y, float _vx, float _ax)
  {
    x = _x;
    y = _y;
    vx = _vx;
    vy = 0;
    ax = _ax;
    ay = 0;
  }

  void draw()
  {
    color c = color(50);

    fill(c);
    imageMode(CENTER);
    image(Aircraft, x+90, y, 11*r, 4*r); 

    //ellipse(x,y,r,r);
  }

  boolean in_bounds()
  {
    return (-width/2 < x && x < width/2);
  }

  void update()
  {
    x += vx;
    y += vy;
    vx += ax;
    vy += ay;

    if (it%10 == 0 && in_bounds())
      waves.add(new Wave(x, y, r));

    it++;
  }
}

class Wave
{
  float x, y;
  float r;

  Wave(float _x, float _y, float _r)
  {
    x = _x;
    y = _y;
    r = _r;
  }

  void draw()
  {
    color c = color(255, 0, 0,150);

    noFill();    
    stroke(c);
    strokeWeight(2);
    ellipse(x, y, r, r);
  }

  void update()
  {
    r += 4;
  }
}
