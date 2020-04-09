color c1 = #FF0000;
color c2 = #FF7F00;
color c3 = #FFFF00;
color c4 = #00FF00;
color c5 = #0000FF;
color c6 = #2E2B5F;
color c7 = #8B00FF;
color c8 = #FFFFFF;
color[] colors  = {c1, c2, c3, c4, c5, c6, c7, c8};

import java.util.*;
Mover[] movers = new Mover[8];
Attractor a;
PImage Tierra;
float[] V_i = {0.0,4.1,6.75,8.25,8.815,9.25,9.40,9.9};
PImage bg;
int[] active = {1,0,0,0,0,0,0,0};
PGraphics canvas;
float px2 = -1;
float py2 = -1;

void setup() {
  
  size(600,600);
  //canvas = createGraphics(600,600);
  //canvas.beginDraw();
  //canvas.background(0);
  //canvas.endDraw();
  
  Tierra = loadImage("Tierra.png");
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(V_i[i]);
  }
  a = new Attractor();
  bg = loadImage("bg.jpg");
  bg.resize(width, height);
  
  
}

void draw() {
    
    background(bg);
    
    //image(canvas,300,300);    
    a.display();
 
    PVector Posa = a.position;
    for (int i = 0; i < movers.length; i++) {
      
      if(active[i] > 0){
          PVector force = a.attract(movers[i]);
          movers[i].applyForce(force);
          PVector Posm = movers[i].position;
          
          PVector diff = PVector.sub(Posm,Posa);
        
          if(diff.mag()<=197.0){
             movers[i].velocity = new PVector(0.0,0);
             movers[i].acceleration = new PVector(0.0,0);
             active[i+1] = 1;
          }
      
          movers[i].update();
          movers[i].display(i);
      }
    }
    
    
    //canvas.beginDraw();
    //canvas.translate(500, 500);
    //canvas.strokeWeight(4);
    //canvas.stroke(255);
    //if (frameCount > 1){
    //canvas.line(px2,py2,movers[7].position.x,movers[7].position.y); 
    //}
    //canvas.endDraw();
    
    px2 = movers[7].position.x;
    py2 = movers[7].position.y;
    
    textSize(30);
    fill( 169, 142, 200 );
    text("@Inaki_Huarte", width -250,height -35); 
    
    saveFrame("Output/frame_####.png");
    delay(25);
}


  
