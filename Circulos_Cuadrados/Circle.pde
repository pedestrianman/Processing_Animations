class Circle{
  
 ArrayList squares;
 PVector position;
 float rotation = 0.f;  
 int radio;
 
 Circle(int radius, int numSquares){
   
   squares = new ArrayList();
   position = new PVector();
   
   for(int i=0; i<numSquares; i++){
     Square s = new Square();
     float angle = TWO_PI*i/(float)numSquares;
     s.setPosition( radius*cos(angle), radius*sin(angle));
     s.setColor(i%2==0 ? 0 : 255 );
     squares.add( s );
   }
 }
 
 void setPosition(float _x, float _y){
   position.x = _x;
   position.y = _y;
 }
 
 void serRadius(int a){
    radio = a; 
 }
 void setRotation(float a){
   rotation = a;
 }
 
 void rotateSquares(float a){
   for(int i=0; i<squares.size(); i++){
     Square s = (Square) squares.get(i);
     float angle = TWO_PI*i/(float)squares.size();
     s.rotation = a + angle; 
   }
 }
 
 void update(){
 }
 
 void display(){
   
   pushMatrix();
     translate(position.x, position.y);
     rotate(rotation);
     for(int i=0; i<squares.size(); i++){
       Square s = (Square) squares.get(i);
       s.display();
     }
   popMatrix();
 }
 
 void display_circle(){
     noFill();
     stroke(255,0,0);
     circle(position.x,position.y,2*radio);
 }
  
}
