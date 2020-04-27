
// VARIABLES GLOBALES //

int cuerpos = 40;
int rectas = cuerpos - 1 ;
Mover[] movers = new Mover[cuerpos];

float[] ptos_linea_x = new float[rectas];
float[] ptos_linea_y = new float[rectas];
float[] longitudes_rectas = new float [rectas];

FloatList posiciones_ultimo_mover_x = new FloatList();
FloatList posiciones_ultimo_mover_y = new FloatList();

float offset_x = -145;
float long_line = 130;
float factor_reduccion = 0.75;

float Delta_ang = 0.01;//0.05
float ang_ini = 0.0;

int foto = 1;
PFont mono;

//////////////////
  /* MAIN */
//////////////////

void setup() {
    
  size(600, 600);
  translate(width/2+2*offset_x,height/2);
  
  movers[0] = new Mover(0,0,0,0);
  movers[1] = new Mover(long_line,0,0,0);
  longitudes_rectas[0] = long_line;
  
  for (int i = 2; i < cuerpos; i++) {
    movers[i] = new Mover(movers[i-1].position.x + long_line*pow(factor_reduccion,(i-1)),0,0,0);
    longitudes_rectas[i-1] = long_line*pow(factor_reduccion,(i-1));
  }
 
  mono = createFont("font.ttf",30);
  textFont(mono);
}

void draw() {
  
    
    background(0);
    translate(width/2+2*offset_x,height/2);
    
    //// INICIO SIMULACION ////
   
   //Movimiento mover 3 circular
   
   movers[2].position.x = movers[1].position.x + longitudes_rectas[1]*cos(ang_ini);
   movers[2].position.y = movers[1].position.y + longitudes_rectas[1]*sin(ang_ini);
   
   //Actualizo el resto de movimientos
   for (int i = 3;i<cuerpos;i++){
       movers[i].position.x = movers[i-1].position.x + longitudes_rectas[i-1]*cos((i-1)*ang_ini);
       movers[i].position.y = movers[i-1].position.y + longitudes_rectas[i-1]*sin((i-1)*ang_ini);
       
   }
   
   
   ang_ini -= Delta_ang;
    
   for (int i = 0;i<cuerpos;i++){
     
      movers[i].display();
   }
   
   stroke(255);
   strokeWeight(3);
   
   for (int i = 0;i<cuerpos-1;i++){
      line(movers[i].position.x,movers[i].position.y,movers[i+1].position.x,movers[i+1].position.y) ;
   }
   
   posiciones_ultimo_mover_x.append(movers[cuerpos-1].position.x);
   posiciones_ultimo_mover_y.append(movers[cuerpos-1].position.y);
   
   stroke(37, 121, 80);
   strokeWeight(5);
   
   if(frameCount == 1){
     line(posiciones_ultimo_mover_x.get(posiciones_ultimo_mover_y.size()-1),posiciones_ultimo_mover_y.get(posiciones_ultimo_mover_y.size()-1),movers[cuerpos-1].position.x,movers[cuerpos-1].position.y);
   }
   
   if(frameCount > 1){
     for( int i = 1; i < posiciones_ultimo_mover_y.size();i++){
          line(posiciones_ultimo_mover_x.get(i),posiciones_ultimo_mover_y.get(i),posiciones_ultimo_mover_x.get(i-1),posiciones_ultimo_mover_y.get(i-1));    
      }
   }
      
   fill(255,255,255,150);
   text("@Inaki_Huarte",335,270);
    
    // GUARDO FRAMES //
    
    String Filename;
    Filename = "Output/frame_" + foto + ".png";
    saveFrame(Filename);
    foto += 1;
    
   
    
}
