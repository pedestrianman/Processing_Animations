
ArrayList circles;
int numRings = 4;

boolean draw_circles = false;

int increment = 0;
int foto;
PFont mono;

/* MAIN ROUTINES */

void setup(){
  size(500,500);
  mono = createFont("font.ttf", 30);
  textFont(mono);
  circles = new ArrayList();
  
  // Creo numRings circulos con sus cuadrados.
  for(int i=0; i<numRings; i++){
    Circle c = new Circle(55 + 40*i, 15 + 14*i); //Primera argumento el radio del circulo y segundo el # cuadrados
    c.serRadius(55 + 40*i);
    c.setPosition(width/2,height/2);
    circles.add( c );
  }
}

void draw(){
  background(125);
    
  if(frameCount > 100) rotateCircles();
  
  for(int i=0; i<circles.size(); i++){
    Circle c = (Circle) circles.get(i);
    int direction = i%2==0 ? -1 : 1; 
    c.rotateSquares(direction*PI*0.106); // El 0.1106 es la rotación óptima de los cuadrados para ver la ilusión.
    c.display();
    if(draw_circles) c.display_circle();
  }
  
  fill(255, 255, 255, 150);
  text("@Inaki_Huarte", 80, 410);

  // Saving Frames //
  String Filename;
  Filename = "Animation/frame_" + foto + ".png";
  //saveFrame(Filename);
  foto += 1;
}

/* FUNCTION DEFINITIONS */

void mousePressed(){
  draw_circles = !draw_circles;
}

void rotateCircles(){
  
  increment++;
  
  for(int i=0; i<circles.size(); i++){
    Circle c = (Circle) circles.get(i);
    int direction = i%2==0 ? -1 : 1;
    c.setRotation(direction*PI*increment/500.f);
  }
}
