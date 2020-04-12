
//////////////////////////
// FUNCIONES A UTILIZAR //
//////////////////////////

int estoy_dentro(float px, float py, float diametro){
  
    int dentro_fuera;
    float radio = diametro/2.0;
    
    float position = sqrt(px*px + py*py);
    
    if(position <= radio - 4){
        dentro_fuera = 0;
    }else{
        dentro_fuera = 1;
    }
      
    return dentro_fuera; 
}

int suma_vector(int[] vector, int dimension){
  
    int suma = 0;
    
    for (int i = 0; i < dimension; i++) {
        suma += vector[i];
    }
    
    return suma;
}


PVector calculo_vector(float px_ellipse,float py_ellipse,float px_foco,float py_foco){
  
    PVector vector = new PVector();
    
    vector.x = px_foco - px_ellipse;
    vector.y = py_foco - py_ellipse;
    vector.normalize();
    return vector;
}

float[] calculo_vector_Rotacion(Mover[] movers, int cuerpos){
  
    PVector p1,p2;
    PVector aux = new PVector();
    float [] Vectores_Rotacion = new float[cuerpos*2];
    
     for (int i = 0; i < cuerpos; i++) {
        p1 = movers[i].position;
        p2 = movers[cuerpos + i].position;
        aux.x = (p2.x + p1.x)/2;
        aux.y = (p2.y + p1.y)/2;
        Vectores_Rotacion[i] = aux.x;
        Vectores_Rotacion[i+cuerpos] =aux.y; 
        
     }
    
    return Vectores_Rotacion;
    
}


float [] longitudes_rectas(Mover[] movers, int cuerpos){
  
  
    float [] longitudes = new float[cuerpos];
    PVector p1,p2;
    PVector aux = new PVector();
    float magnitud;
    
    for (int i = 0; i < cuerpos; i++) {
        p1 = movers[i].position;
        p2 = movers[cuerpos + i].position;
        aux.x = p2.x - p1.x;
        aux.y = p2.y - p1.y;
        magnitud = aux.mag();
        longitudes[i] = magnitud;
        
    }
    return longitudes;
}

/////////////////////////
int cuerpos = 90; //90 optimo
Mover[] movers = new Mover[2*cuerpos];
int[] dentro_fuera = new int[cuerpos]; //0 dentro,1 fuera
float[] longitudes = new float[cuerpos]; 
float[] angulos_inico = new float[cuerpos];
float[] Vectores_Rotacion = new float[2*cuerpos];
float cx = 0;
float cy = 0;
float diametro = 450;
float mod_vel = 2;
float Delta_ang = (360/(cuerpos)) * PI/180.0;
float ang_ini = 0.0;
PVector vector = new PVector();
PGraphics canvas;
PFont mono;
int inicio_rotacion = 0;
int calculo = 0;
float angle = 0.0;

//////////////////
/* INICIO SETUP */
//////////////////

void setup() {
    size(600, 500);
    mono = createFont("font.ttf",25);
    textFont(mono);
    
    circle(cx, cy, diametro);
    for (int i = 0; i < cuerpos; i++) {
      movers[i] = new Mover(cx + 150,cy,mod_vel*cos(ang_ini),mod_vel*sin(ang_ini));
      angulos_inico[i] = ang_ini;
      ang_ini += Delta_ang;
      dentro_fuera[i] = 0; 
    }
    for (int i = cuerpos; i < 2*cuerpos; i++) {
      movers[i] = new Mover(cx + 150,cy,0,0);
    }

}

void draw() {
  
    background(0);
    translate(width/2,height/2);
    
    //Centro circulo
    fill(255,0,0,100);
    noStroke();
    circle(0, 0, 7);
    
    //Circulo Principal
    stroke(255);
    strokeWeight(2);
    fill(0,0,0,0);
    circle(cx, cy, diametro);
   
    //Punto Origen Rectas
    fill(255,255,255,100);
    noStroke();
    circle(cx + 150, cy, 7);
    
    if (frameCount >= 75){
      for (int i = 0; i < cuerpos; i++) {
        
          movers[i].update();
          movers[i].display();
          
          dentro_fuera[i] = estoy_dentro(movers[i].position.x, movers[i].position.y,diametro); 
          
          if(dentro_fuera[i] > 0){
             movers[i].velocity.x = 0.0;
             movers[i].velocity.y = 0.0;
          }
          
          stroke(colors[i],95);
          //stroke(frameCount * 3 % 255, frameCount * 5 % 255,frameCount * 7 % 255,80);
          strokeWeight(2);
          line(movers[cuerpos+i].position.x, movers[cuerpos+i].position.y,movers[i].position.x, movers[i].position.y);
          
      }
      
      inicio_rotacion = suma_vector(dentro_fuera,cuerpos);
      
      if(inicio_rotacion == cuerpos || calculo == 1){
             if(calculo == 0){
               longitudes = longitudes_rectas(movers, cuerpos);
               Vectores_Rotacion = calculo_vector_Rotacion(movers, cuerpos);
               calculo = 1;
             }
             
             if (abs(angle) <= PI/2 & frameCount >= 250+75){
               for (int i = 0; i < cuerpos; i++) {
                  
                  movers[i].position.x =  Vectores_Rotacion[i] + longitudes[i]/2 * cos(angulos_inico[i] + angle);
                  movers[i].position.y =  Vectores_Rotacion[i+cuerpos] + longitudes[i]/2 * sin(angulos_inico[i] + angle);
                  
                  movers[i+cuerpos].position.x =  Vectores_Rotacion[i] + longitudes[i]/2 * cos((angulos_inico[i] + angle - PI));
                  movers[i+cuerpos].position.y =  Vectores_Rotacion[i+cuerpos] + longitudes[i]/2 * sin((angulos_inico[i] + angle - PI));
                  
                  angle-= 0.00009; 
                 
               }  
             }
      }
    }
    fill( 255,255,255,180 );
    text("@Inaki_Huarte", 115,230);
    //saveFrame("Output/frame_####.png");

    
}
