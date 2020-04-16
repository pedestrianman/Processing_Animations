PVector curva(float phi){
  
    PVector new_point = new PVector();
    
    float x = phi + sin(phi);
    float y = cos(phi);
    
    new_point.x = x;
    new_point.y = y;
    
    return new_point;
}

PVector [] crea_curva( PVector pos_ini_curva, int puntos_curva, float h_ramp){
  
  PVector[] Ptos_Curva = new PVector[puntos_curva];
  PVector Vect_aux = new PVector();
  float phi;
  
  
  for (int i = 0; i < puntos_curva; i++) {
       
      phi = (float)(i)/(puntos_curva-1) * PI - PI;
      Vect_aux = curva(phi);
      Vect_aux.mult(h_ramp/2);
      Vect_aux.add(pos_ini_curva);
      Ptos_Curva[i] = Vect_aux;
      
  }
  return Ptos_Curva;
  
}



int puntos_curva = 800;
float x0_ramp = 300;
float y0_ramp = 0;
float h_ramp = 380;
PVector cooordenada_ini_curva = new PVector(x0_ramp,y0_ramp);
PVector[] coordenadas_curva = new PVector[puntos_curva];
int cuerpos = 4;
Mover[] movers = new Mover[cuerpos];
float masa_ini = 1.0;
float phi_pendulum = 0;
float phi_wheel = 0;
float t = 0;
PVector factor = new PVector ();
PVector vel_norm = new PVector();
PVector acc = new PVector();
PFont mono;
PImage Finish,Podio;
int n_cohetes = 20;
Mover[] cohetes = new Mover[n_cohetes];
float transparency = 0;

void setup() {
  
    size(700, 500);
    imageMode(CENTER);
    Finish = loadImage("Finish.png");
    Podio = loadImage("podio.png");
    coordenadas_curva = crea_curva(cooordenada_ini_curva,puntos_curva,h_ramp);
    for (int i = 0; i < cuerpos; i++) {
      movers[i] = new Mover(x0_ramp, y0_ramp, masa_ini);  
      masa_ini -= 0.2;
    }
    
    for (int i = 0; i < n_cohetes; i++) {
      cohetes[i] = new Mover(coordenadas_curva[puntos_curva-1].x, coordenadas_curva[puntos_curva-1].y,masa_ini);
    }
    mono = createFont("font.ttf",33);
    textFont(mono);
}

void draw() {
    
    tint(255,255);
    background(0);
    translate(width/2,height/2);
    
    fill(44,85,69,150);
    stroke(255,255,255,180);
    strokeWeight(4);
    beginShape();
    image(Finish,coordenadas_curva[puntos_curva-1].x-9,coordenadas_curva[puntos_curva-1].y - 45,100,150); 
    
    for (int i = 0; i < puntos_curva; i++) {
       vertex(coordenadas_curva[i].x,coordenadas_curva[i].y); 
    }
    vertex(coordenadas_curva[0].x,coordenadas_curva[puntos_curva-1].y);
    endShape(CLOSE);
    
    
    for (int i = 0; i < puntos_curva-1; i++) {
        stroke(128,64,0);
        strokeWeight(5);
        line(coordenadas_curva[i].x,coordenadas_curva[i].y,coordenadas_curva[i+1].x,coordenadas_curva[i+1].y);
    }
    
    for (int i = 0; i < cuerpos; i++) {
        
      if(coordenadas_curva[puntos_curva-1].y -0.005 > movers[0].position.y){   
      
          phi_pendulum = movers[i].mass *  -cos(t*PI/2);
          phi_wheel = 2*asin(phi_pendulum);
          phi_wheel = -abs(phi_wheel);
          factor = curva(phi_wheel);
          factor.mult(h_ramp/2);
          
          vel_norm.x = 1+cos(phi_wheel);
          vel_norm.y = -sin(phi_wheel);
          vel_norm.mult(h_ramp/2);
          vel_norm.normalize();
          acc = vel_norm;
          acc.mult(80*-phi_pendulum);
          
          
          movers[i].arrow(movers[i].position.x,movers[i].position.y,movers[i].position.x + acc.x , movers[i].position.y+ acc.y);
          movers[i].update(factor, x0_ramp,y0_ramp);
          movers[i].display(i);
          
      }else{
        
          movers[i].display(i);
          //if (transparency == 0) { transparency += 0.25; }
          //tint(255, transparency);
          if(frameCount > 450){
            tint(255,transparency);
            image(Podio,0,65,400,250); 
            transparency += 0.25;
          }
      }
    }
    t += 0.0025;
    fill(255,255,255,150);
    text("@Inaki_Huarte",90,-200);
    saveFrame("Output/frame_####.png");
}
