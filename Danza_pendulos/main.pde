int cuerpos = 15;
Pendulum[] movers = new Pendulum[cuerpos];

float [] longitudes  = {
280.473864753876,269.790133958888,259.705419090364,250.175762079846,241.161164371845,
232.625166525776,224.53447898579,216.858657022839,209.569813911184,202.642367284676,
196.052814357654,189.779532316554,183.802600711724,178.103643121297,172.665685733688,
};

int cont = cuerpos-1;
PImage bg;
PImage sun;
PFont mono;

int cont_files = 1;

void setup() {
  size(650,650);
  colorMode(HSB,255);
  for (int i = 0; i < cuerpos; i++){
        movers[i] = new Pendulum(new PVector(width/2,0),longitudes[cont]*2); 
        cont -= 1;
  }
  bg = loadImage("bg3.jpg");
  sun = loadImage("sun.png");
  bg.resize(width,height);
  mono = createFont("font.ttf",33);
  textFont(mono);
}

void draw() {
  background(0);
  
  for (int i = 0; i < cuerpos; i++){
      movers[i].go(i);  
  }
  colorMode(RGB,255);
  fill( 255,255,255,180 );
  text("@Inaki_Huarte", 405,610);
  
  
  if (frameCount <= 1000){
    String name = "Output/S1/frame_"+ str(cont_files)+".png";
    saveFrame(name); 
  }else if(frameCount <= 1900){
    String name = "Output/S2/frame_"+ str(cont_files-1000)+".png";
    saveFrame(name); 
  }else if(frameCount <= 2350){
    String name = "Output/S3/frame_"+ str(cont_files-1900)+".png";
    saveFrame(name); 
  }else if(frameCount <= 2600){
    String name = "Output/S4/frame_"+ str(cont_files-2350)+".png";
    saveFrame(name); 
  }else if(frameCount <= 3100){
    String name = "Output/S5/frame_"+ str(cont_files-2600)+".png";
    saveFrame(name); 
  }else if(frameCount <= 4000){
    String name = "Output/S6/frame_"+ str(cont_files-3100)+".png";
    saveFrame(name); 
  }else if(frameCount <= 4800){
    String name = "Output/S7/frame_"+ str(cont_files-4000)+".png";
    saveFrame(name); 
  }else if(frameCount <= 7800){
    String name = "Output/S8/frame_"+ str(cont_files-4800)+".png";
    saveFrame(name); 
  }else if(frameCount <= 8750){
    String name = "Output/S9/frame_"+ str(cont_files-7800)+".png";
    saveFrame(name); 
  }else{
    exit();  
  }
  
  cont_files += 1;
  
}
