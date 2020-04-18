float r1 = 200; // length of first pendulum
float r2 = 200; // length of second pendulum
float m1 = 20; //  mass of first pendulum excluding weight of string
float m2 = 20; // mass of second pendulum excluding weight of string
float g = 1; //gravitational constant (realistic value not considered for simplicity )

float cx, cy; //centre of x and y for background

int cuerpos = 50;
float[] a1 = new float[cuerpos];
float[] a2 = new float[cuerpos];
float[] a1_v = new float[cuerpos];
float[] a2_v = new float[cuerpos];
float[] px2 = new float[cuerpos];
float[] py2 = new float[cuerpos];

float ini_speed = -0.09;

float num1, num2, num3,num4,den,a1_a,a2_a,x1,y1,x2,y2;
PGraphics canvas;
PFont mono;

void setup() {
  colorMode(RGB, cuerpos);
  size(800, 720); 
  cx = width/2;
  cy = height/2 + -75;
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(25,25,25);
  canvas.endDraw();
  mono = createFont("font.ttf",33);
  textFont(mono);
  
  for (int i=0;i<cuerpos;i++){
     
    a1[i] =  PI/2;
    a2[i] =  PI/2;
    a1_v[i] = 0;
    a2_v[i] = ini_speed;
    px2[i] = 0.0;
    py2[i] = 0.0;
    ini_speed += 0.00001;
  }
  
}

void draw() {
  
  background(0);
  imageMode(CORNER);
  image(canvas, 0, 0, width, height);
  translate(cx, cy);
  
  // numerators are moduled 
  
  for (int i = 0; i < cuerpos; i++){
    
      num1 = -g * (2 * m1 + m2) * sin(a1[i]);
      num2 = -m2 * g * sin(a1[i]-2*a2[i]);
      num3 = -2*sin(a1[i]-a2[i])*m2;
      num4 = a2_v[i]*a2_v[i]*r2+a1_v[i]*a1_v[i]*r1*cos(a1[i]-a2[i]);
      den = r1 * (2*m1+m2-m2*cos(2*a1[i]-2*a2[i]));
      a1_a = (num1 + num2 + num3*num4) / den;
    
      num1 = 2 * sin(a1[i]-a2[i]);
      num2 = (a1_v[i]*a1_v[i]*r1*(m1+m2));
      num3 = g * (m1 + m2) * cos(a1[i]);
      num4 = a2_v[i]*a2_v[i]*r2*m2*cos(a1[i]-a2[i]);
      den = r2 * (2*m1+m2-m2*cos(2*a1[i]-2*a2[i]));
      a2_a = (num1*(num2+num3+num4)) / den;
    
      
      
      x1 = r1 * sin(a1[i]);
      y1 = r1 * cos(a1[i]);
    
      x2 = x1 + r2 * sin(a2[i]);
      y2 = y1 + r2 * cos(a2[i]);
    
      stroke(128,64,0);
      strokeWeight(2);
      line(0, 0, x1, y1);
      fill(44,85,69,150);
      noStroke();
      ellipse(x1, y1, m1, m1);
      
      stroke(128,64,0);
      strokeWeight(2);
      line(x1, y1, x2, y2);
      fill(44,85,69,150);
      noStroke();
      ellipse(x2, y2, m2, m2);
    
      a1_v[i] += a1_a;
      a2_v[i] += a2_a;
      a1[i] += a1_v[i];
      a2[i] += a2_v[i];
      
      canvas.beginDraw();
      canvas.translate(cx, cy);
      canvas.stroke(colors[i+40],90);
      canvas.strokeWeight(1);
      if (frameCount > 1) {
        canvas.line(px2[i], py2[i], x2, y2);
      }
      canvas.endDraw();
      
      //delay(1000);
      px2[i] = x2;
      py2[i] = y2;
  }
    fill( 255,255,255,180 );
    text("@Inaki_Huarte", 160,400);
    //saveFrame("Output/frame_####.png");
}
