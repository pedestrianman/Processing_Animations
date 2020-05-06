class Mover {

  PVector presPos;
  PVector position;
  float dir;
  float radius;
  float angle;

  Mover(int presPosx_ini, int presPosy_ini, int pos_x,int pos_y,float dir1, float radius1,float angle1) {
    presPos = new PVector(presPosx_ini,presPosy_ini);
    position = new PVector(pos_x,pos_y);
    dir = dir1;
    radius = radius1;
    angle = angle1;
  }
  
}
