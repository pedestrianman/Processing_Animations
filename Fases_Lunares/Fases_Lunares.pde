
float comprueba_distancia (float p1x, float p1y, float p2x, float p2y){
  
  float distancia;
  
  float dif_x = p1x-p2x;
  float dif_y = p1y-p2y;
  distancia = sqrt(dif_x*dif_x + dif_y*dif_y);
  
  return distancia;
}


int cuerpos = 10;
float diametro = 350;
PImage Luna;
float[] static_x = new float[cuerpos];
float[] static_y = new float[cuerpos];
float[] movers_x = new float[cuerpos];
float[] movers_y = new float[cuerpos];
float[] velocidades ={1.5,1.5,1.5,1.5,1.5,1.5,-1.5,-1.5,-1.5,-1.5}; 
float[] distancias = {0,10,20,30,55,90,55,30,20,10};
float[] offset_inicial = {100,100,100,120,150,190,-100,-100,-120,-130};
int[] inicio_movimiento = new int[cuerpos]; //0 si el mover i no se mueve, 1 si lo hace.
int[] saturacion = new int[cuerpos]; //0 si lo saturamos, 1 si no
int[] fill_circle = new int[cuerpos]; //0 si mo lo pintamos, 1 si sí

float delta_ang = 2*PI/cuerpos;
float ang_ini = 0;
float acum = 0;
float vel_x = 1.5;
float distancia;
PFont mono;
int foto = 1;

void setup() {
  
  size(600,600);
  Luna = loadImage("Moon.png");
  mono = createFont("font.ttf",33);
  textFont(mono);
  for (int i = 0; i < cuerpos; i++){
      static_x[i] = diametro/2*cos(ang_ini);
      static_y[i] = diametro/2*sin(ang_ini);
      ang_ini += delta_ang;
      movers_x[i] = static_x[i] - offset_inicial[i];
      movers_y[i] = static_y[i];
      inicio_movimiento[i] = 0;
      saturacion[i] = 0;
      fill_circle[i] = 0;
  }
  
  inicio_movimiento[0] = 1;
  fill_circle[0] = 1;
}

void draw() {
  
  background(0);
  translate(width/2,height/2);
  
  for (int i = 0; i < cuerpos; i++){
    
    imageMode(CENTER);
    if(saturacion[i] == 1){
      tint(255, 255);
    }else{
      tint(255, 60);
    }
    image(Luna,static_x[i],static_y[i],100,100); 
   
   if(fill_circle[i] == 1){
      fill(0,0,0);
   }else{
      noFill();
   }
    noStroke();
    circle(movers_x[i],movers_y[i],95);
  }
  
  //Actualizacion Movimiento Mover;
  
   for (int i = 0; i < cuerpos; i++){
      
     if(inicio_movimiento[i] == 1){
         
       movers_x[i] += velocidades[i];
       distancia = comprueba_distancia(static_x[i],static_y[i],movers_x[i],movers_y[i]);  
       
       if(abs(distancia-distancias[i]) <= 2 ){
           saturacion[i] = 1;
           inicio_movimiento[i] = 0;
           
           if(i <= cuerpos-2){
             inicio_movimiento[i+1] = 1;
             fill_circle[i+1] = 1;
           }
       }
     }
     
   }
  
  fill( 255,255,255,180 );
  text("@Inaki_Huarte", 40,265);
  
  // GUARDO FRAMES //
    
   String Filename;
   Filename = "Output/frame_" + foto + ".png";
   saveFrame(Filename);
   foto += 1;
  
  if(frameCount >= 650){
     exit(); 
  }
  
}
