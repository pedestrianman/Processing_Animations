
int cuerpos = 29;
float Delta_ang = (90/(14)) * PI/180.0;
float ang_ini = Delta_ang;
Mover[] movers = new Mover[cuerpos];
float[] Maximos = new float [cuerpos];
float [] Pos_Max = new float [2*cuerpos]; 
int[] activo = new int [cuerpos]; //Empieza en 1
int[] colorea = new int [cuerpos];//Empieza en 0
int izda_dcha = -1;
float suma;
PGraphics canvas;
PFont mono;

void setup() {
  size(1000, 600);
  canvas = createGraphics(1000,600);
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();
  mono = createFont("font.ttf",40);
  textFont(mono);
  
  for (int i = 0; i < 14; i++) {
    
    movers[i] = new Mover(-9*cos(ang_ini),-9*sin(ang_ini));
    Maximos[i] = 0.0;
    Pos_Max[2*i] = 0.0;
    Pos_Max[2*i +1] = 0.0;
    activo[i] = 1;
    colorea[i] = 0;
    ang_ini += Delta_ang;    
  }
  ang_ini = Delta_ang;
  for (int i = 14; i < 29; i++) {
    
    movers[i] = new Mover(9*cos(ang_ini),-9*sin(ang_ini));
    Maximos[i] = 0.0;
    Pos_Max[2*i] = 0.0;
    Pos_Max[2*i +1] = 0.0;
    activo[i] = 1;
    colorea[i] = 0;
    ang_ini += Delta_ang;    
  }
   
}


void draw() {
  
    //background(255);
    image(canvas, 0,0);
    translate(width/2,height - 100);
    
    stroke(0,127);
    line(-width/2, 0, width/2, 0);
    
    for (int i = 0; i < movers.length; i++) {
        
        movers[i].update();
        movers[i].display();
          
        if (activo[i] > 0){
          if (abs(movers[i].position.y) > Maximos[i]) {
              Maximos[i] = abs(movers[i].position.y);
          }else{
            
            Pos_Max[2*i] = movers[i].position.x;
            Pos_Max[2*i+1] = movers[i].position.y;
            activo[i] = 0;
            colorea[i] = 1;
          }
        }
    
        if (colorea[i] > 0){
          fill(255,0,0);
          stroke(255,0,0);
          circle(Pos_Max[2*i], Pos_Max[2*i + 1], 10);
        }
        
        
        if (movers[i].position.y >= 0){
          movers[i].position.y = 0.0;
          movers[i].velocity = new PVector(0,0);
          movers[i].acceleration = new PVector(0,0);
        }
        
         canvas.beginDraw();
         canvas.translate(width/2,height - 100);
         canvas.strokeWeight(4);
         canvas.stroke(255,255,255,35);
         canvas.point(movers[i].position.x,movers[i].position.y);
         canvas.endDraw();
      
    }//Fin bucle particulas
    
    suma = suma_vels(movers);
    
    if((suma == 0) && (frameCount > 250) ){
         for (int i = 0; i < 13; i++) {
             stroke(255,0,0,100);
             line(Pos_Max[2*i], Pos_Max[2*i+1], Pos_Max[2*(i+1)], Pos_Max[2*(i+1)+1]);
         }
         
         for (int i = 14; i < 28; i++) {
           stroke(255,0,0,100);
             line(Pos_Max[2*i], Pos_Max[2*i+1], Pos_Max[2*(i+1)], Pos_Max[2*(i+1)+1]);
         }
         stroke(255,0,0,100);
         line(Pos_Max[2*13], Pos_Max[2*13+1], Pos_Max[2*(27+1)], Pos_Max[2*(27+1)+1]);
         line(0,0, Pos_Max[0], Pos_Max[1]);
         line(0,0, Pos_Max[2*14], Pos_Max[2*14+1]);
    }
  
    //textSize(40);
    fill( 255,255,255,180 );
    text("@Inaki_Huarte", 200,65); 
    
    //saveFrame("Output/frame_####.png");
    
}



float suma_vels(Mover[] movers) {
  float suma = 0;
  for (int i = 0; i < movers.length; i++) {
      suma +=  movers[i].position.y;
  }
  return suma;
}
