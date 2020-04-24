

// FUNCIONES A UTILIZAR //

int sigo_movimiento( Mover mover, int iter, float[] targets_x, float[] targets_y){
  
  int muevo = 0;
  
  PVector pos_target = new PVector(targets_x[iter], targets_y[iter]);
  PVector diff_pos = new PVector();
  
  diff_pos.x = pos_target.x - mover.position.x;
  diff_pos.y = pos_target.y - mover.position.y;
  
  float mod = diff_pos.mag();
  
  if(mod <= 0.1){
     muevo = 1; //Paro el punto 
  }
  
  return muevo;
    
}


// VARIABLES GLOBALES //

int cuerpos = 1; 
Mover[] movers = new Mover[cuerpos];
Mover[] cuerpo_oculto = new Mover[cuerpos];

float offset_x = -80;
float long_line = abs(2*offset_x);

int muevo = 0; //Si es 0 me muevo si es 1 no.
int time_stop = 50; //40 optimo
int tiempo_parada = time_stop; //Iteraciones en las que el punto se para
int iter_total = 1500; //La iteracion inicial es 0
int iter_actual = 0;
 

float[] angulos = new float [iter_total];

float[] targets_x = new float[iter_total];
float[] targets_y = new float[iter_total];
float[] ptos_linea_x = new float[iter_total];
float[] ptos_linea_y = new float[iter_total];

PVector direccion_deseada = new PVector();
PVector Pos_anterior = new PVector();

float Delta_ang = 0.05;//0.05
float ang_ini = 0.0;
float aux = floor((2*PI)/Delta_ang);
int angulitos = int(aux);

float[] angulos_para_rectas = new float [angulitos];
float mod_vel = 5;

float zoom_out = 0;
float derecha = 0;
float abajo = 0;
PVector Camera_Pos = new PVector();
int foto = 1;

//////////////////
  /* MAIN */
//////////////////

void setup() {
    size(1280, 720, P3D);
    camera(width/2.0, height/2.0, (height/8) / tan(PI/6), width/2.0, height/2.0, 0, 0, 1, 0);
    ambientLight(255,255,255);
    

    
    angulos[0] = 0.0;
    
    targets_x[0] = long_line*cos(angulos[0]); 
    targets_y[0] = long_line*sin(angulos[0]);
    ptos_linea_x[0] = 0.0;
    ptos_linea_y[0] = 0.0;
    
    for (int i = 1; i < iter_total; i++) {
            angulos[i] = angulos[i-1] - i*Delta_ang;
            targets_x[i] = targets_x[i-1] +  long_line*cos(angulos[i]);  
            targets_y[i] = targets_y[i-1] +  long_line*sin(angulos[i]);
            ptos_linea_x[i] = targets_x[i-1];
            ptos_linea_y[i] = targets_y[i-1];
    }
    
    for (int i = 0; i < cuerpos; i++) {
      movers[i] = new Mover(0,0,mod_vel,0);
      cuerpo_oculto[i] = new Mover(0,0,mod_vel,0);
    }
    
    float aux2 = 0;
    for (int i = 0; i < angulitos; i++) {
      angulos_para_rectas[i] = aux2;
      aux2 += Delta_ang;
    }
    
    frameRate(60);
       
}

void draw() {
  
    
    background(0);
    translate(width/2+2*offset_x,height/2);
    
    //// AJUSTES CAMARA ////
    
    if(frameCount < 1250){
      camera(movers[0].position.x , movers[0].position.y, (height/6.75) / tan(PI/6) + zoom_out, movers[0].position.x , movers[0].position.y, 0, 0, 1, 0);
      zoom_out += 0.05;
      if(frameCount > 350){
         zoom_out += 1; 
      }
      if(zoom_out > 1700){
         zoom_out = 1700; 
      }
    }else if(frameCount < 1500){
       if(frameCount == 1250){
          Camera_Pos.x =  movers[0].position.x;
          Camera_Pos.y =  movers[0].position.y;
       }
      camera(Camera_Pos.x,Camera_Pos.y, (height/6.75) / tan(PI/6) + zoom_out, Camera_Pos.x,Camera_Pos.y, 0, 0, 1, 0);
       zoom_out += 2; 
       if(zoom_out > 1700){
         zoom_out = 1700; 
       }
    }else if(frameCount < 2500){
      
          camera(Camera_Pos.x+derecha,Camera_Pos.y+abajo, (height/6.75) / tan(PI/6) + zoom_out, Camera_Pos.x+derecha,Camera_Pos.y+abajo, 0, 0, 1, 0);
          derecha += 1;
          abajo += 2.5;
          zoom_out += 2;
          
          if(derecha >  600){
             derecha = 600;
          }

          if(abajo > 2500){
             abajo = 2500; 
          }
    }else if(frameCount < 6500){
      
           camera(Camera_Pos.x+derecha,Camera_Pos.y+abajo, (height/6.75) / tan(PI/6) + zoom_out, Camera_Pos.x+derecha,Camera_Pos.y+abajo, 0, 0, 1, 0);
           abajo += 10;
           zoom_out += 10;
           derecha += 5;
           
           if(abajo > 3000){
              abajo = 3000; 
           }
           if(zoom_out > 5950){
              zoom_out = 5950; 
           }
           if(derecha > 4000){
              derecha = 4000; 
           }
           
    }
    
    //// INICIO SIMULACION ////
    
    muevo = sigo_movimiento(movers[0], iter_actual, targets_x, targets_y);  //Devuelve 0 si se sigue moviendo, 1 si el punto se para.
    
    if(iter_actual >= 17){
         if(muevo == 1){
           muevo = 0;
           iter_actual+=1;
         }
         mod_vel = 40;
    }
    
    
    if(muevo == 0){ //Si el punto se mueve, debe hacerlo hacia el target
       
       direccion_deseada.x = targets_x[iter_actual];
       direccion_deseada.y = targets_y[iter_actual];
       direccion_deseada.sub(movers[0].position);
       direccion_deseada.normalize();
       movers[0].velocity.x = mod_vel * direccion_deseada.x;
       movers[0].velocity.y = mod_vel * direccion_deseada.y;
       
    }
    
    if(muevo == 1 && tiempo_parada > 0){ //Si el punto esta parado y no se ha acabado su tiempo de parada sigue parado
        movers[0].velocity.x = 0;
        movers[0].velocity.y = 0;
        tiempo_parada -= 1; //Resto una iteracion al tiempo de parada
               
    }
    
    if(muevo == 1 && tiempo_parada == 0){ //Si el tiempo de parada se agota, cambio de iteración.
        iter_actual += 1;
        tiempo_parada = time_stop;
        
    }
    
    if(iter_actual < 60){
      if(iter_actual >= 0 && tiempo_parada < time_stop/2){
  
        for(int k=0;k<iter_actual+2;k++){
               
               if (k==0){
                 strokeWeight(3);
                 stroke(255,255,255,255);
               }else if(k<=iter_actual){
                 strokeWeight(2);
                 stroke(255,255,255,150);
               }else{
                 strokeWeight(3);
                 stroke(255,255,255,255);
               }
               
               line(targets_x[iter_actual],targets_y[iter_actual],targets_x[iter_actual]+long_line*cos(angulos[iter_actual+1]+angulos_para_rectas[k]),targets_y[iter_actual]+long_line*sin(angulos[iter_actual+1]+angulos_para_rectas[k])); 
               
        }
        
      }else if(iter_actual > 0 && abs(movers[0].velocity.x) > 0){
       
        for(int k=0;k<iter_actual+1;k++){
               
               if (k==0){
                 strokeWeight(3);
                 stroke(255,255,255,255);
               }else if(k<=iter_actual-1){
                 strokeWeight(2);
                 stroke(255,255,255,150);
               }else{
                 strokeWeight(3);
                 stroke(255,255,255,255);
               }
               
               line(targets_x[iter_actual-1],targets_y[iter_actual-1],targets_x[iter_actual-1]+long_line*cos(angulos[iter_actual]+angulos_para_rectas[k]),targets_y[iter_actual-1]+long_line*sin(angulos[iter_actual]+angulos_para_rectas[k])); 
               
        }
        
      }
    }
    
    
    Pos_anterior = movers[0].position;
    movers[0].update();
    movers[0].display();
    
    cuerpo_oculto[0].position.x = movers[0].position.x;
    cuerpo_oculto[0].position.y = movers[0].position.y;
    
    strokeWeight(3);
    stroke(255,0,0,255);
    
       
    if(iter_actual == 0){
       line(0,0, cuerpo_oculto[0].position.x, cuerpo_oculto[0].position.y);   
    }else{
      line(targets_x[iter_actual-1],targets_y[iter_actual-1],cuerpo_oculto[0].position.x, cuerpo_oculto[0].position.y);
      
      for(int iter=0; iter < iter_actual; iter++){
           line(ptos_linea_x[iter],ptos_linea_y[iter],ptos_linea_x[iter+1],ptos_linea_y[iter+1]); 
      }
      
      
    }
    
    
    // GUARDO FRAMES //
    
    String Filename;
    if(frameCount <= 3000){
      Filename = "80FPS/frame_" + foto + ".png";
      if (frameCount == 3000){
         foto = 1; 
      }
    }else{
      Filename = "200FPS/frame_" + foto + ".png";
    }
    
    if(frameCount > 5800){
        exit(); 
    }
    
    saveFrame(Filename);
    foto += 1;
    
   
    
}
