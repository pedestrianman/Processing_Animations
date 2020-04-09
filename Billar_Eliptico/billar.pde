/////////////////////////////////
float [] calcula_pos_focos(float ancho,float alto){
  
    float[] pos_foco = new float[2];
    
    pos_foco[0] = sqrt(ancho*ancho-alto*alto);
    pos_foco[1] = -pos_foco[0];
    
    pos_foco[0]/= 2;
    pos_foco[1]/= 2;
    
    return pos_foco;
}
//////////////////////////////////
int estoy_dentro(float px, float py, float ancho_ell, float largo_ell){
  
    int dentro_fuera;
     
    float position = (4*px*px)/(ancho_ell*ancho_ell) + (4*py*py)/(largo_ell*largo_ell);
    
    if(position <= 0.95){
        dentro_fuera = 0;
    }else{
        dentro_fuera = 1;
    }
      
    return dentro_fuera; 
}


float distancia_foco(float px, float py, float focox, float focoy){
  
  float delta_X = px - focox;
  float delta_Y = py - focoy;
  float distancia_foco = sqrt(delta_X * delta_X + delta_Y * delta_Y);
  
  return distancia_foco;
}
///////////////////////////////////
  

PVector calculo_vector(float px_ellipse,float py_ellipse,float px_foco,float py_foco){
  
    PVector vector = new PVector();
    
    vector.x = px_foco - px_ellipse;
    vector.y = py_foco - py_ellipse;
    vector.normalize();
    return vector;
}

/////////////////////////
int cuerpos = 37;
Mover[] movers = new Mover[cuerpos];
float[] focos = new float[2];
int[] dentro_fuera = new int[cuerpos]; //0 dentro,1 fuera
float[] distancia = new float[cuerpos];
float ancho;
float alto;
float cx = 0;
float cy = 0;
float mod_vel = 1;
float Delta_ang = (180/(12)) * PI/180.0;
float ang_ini = PI/2;
PVector vector = new PVector();
PGraphics canvas;
PFont mono;

//////////////////
/* INICIO SETUP */
//////////////////

void setup() {
    size(1000, 500);
    canvas = createGraphics(1000,600);
    canvas.beginDraw();
    canvas.background(25,25,25);
    canvas.endDraw();
    alto =  height -30;
    ancho = width -400;//-450 esta chulo
    ellipse(cx, cy, ancho, alto);
    focos = calcula_pos_focos(ancho,alto);
    mono = createFont("font.ttf",33);
    textFont(mono);
    
    for (int i = 0; i < 13; i++) {
      movers[i] = new Mover(cx + focos[1],cy,mod_vel*cos(ang_ini),-mod_vel*sin(ang_ini));
      ang_ini += Delta_ang;
      dentro_fuera[i] = 0;
      distancia[i] = 10000;
    }
    
    Delta_ang = (85/(12)) * PI/180.0;
    ang_ini = Delta_ang;
    for (int i = 13; i < 25; i++) {
      movers[i] = new Mover(cx + focos[1],cy,mod_vel*cos(ang_ini),-mod_vel*sin(ang_ini));
      ang_ini += Delta_ang;
      dentro_fuera[i] = 0;
      distancia[i] = 10000;
    }
    
    ang_ini = -Delta_ang;
    for (int i = 25; i < cuerpos; i++) {
      movers[i] = new Mover(cx + focos[1],cy,mod_vel*cos(ang_ini),-mod_vel*sin(ang_ini));
      ang_ini -= Delta_ang;    
    }
    
}

void draw() {
    //background(112,128,144);
    image(canvas, 0,0);
    translate(width/2,height/2);
    stroke(128,64,0);
    strokeWeight(8);
    fill(44,85,69,150);
    ellipse(cx, cy, ancho, alto);
    focos = calcula_pos_focos(ancho,alto);
    
    fill(0,200);
    stroke(255,0,0,115);
    strokeWeight(5);
    circle(focos[0], cy, 20);
    
    fill(255,150);
    noStroke();
    circle(focos[1], cy, 14);
    
    for (int i = 0; i < movers.length; i++) {
      
        movers[i].update();
        movers[i].display();
      
        dentro_fuera[i] = estoy_dentro(movers[i].position.x, movers[i].position.y, ancho,alto);
        
        if(dentro_fuera[i] > 0){
           vector = calculo_vector(movers[i].position.x,movers[i].position.y,focos[0],cy);
           movers[i].velocity.x = mod_vel*vector.x;
           movers[i].velocity.y = mod_vel*vector.y;
        }
        
        distancia[i] = distancia_foco(movers[i].position.x, movers[i].position.y,cx + focos[0],cy); 
        
        if(distancia[i] < 1){
           movers[i].velocity.x = 0.0;
           movers[i].velocity.y = 0.0;
        }
        
        canvas.beginDraw();
        canvas.translate(width/2,height/2);
        canvas.strokeWeight(4);
        canvas.stroke(255,255,255,35);
        canvas.point(movers[i].position.x,movers[i].position.y);
        canvas.endDraw();
        
      }
      
    fill( 255,255,255,180 );
    text("@Inaki_Huarte", 250,230);
    saveFrame("Output/frame_####.png");
    
}
