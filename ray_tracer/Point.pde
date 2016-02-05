public class Point{
  private float x;
  private float y;
  private float z;
  
  public Point(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public Point(float[] input){
    if(input.length >= 3){
      x = input[0];
      y = input[1];
      z = input[2];
    }
  }
  
  public Point(){
    x = 0;
    y = 0;
    z = 0;
  }
  
  public float getX(){
    return x;
  }

  public float getY(){
    return y;
  }

  public float getZ(){
    return z;
  }
  
  public void setX(float x){
    this.x = x;
  }
  
  public void setY(float y){
    this.y = y;
  }
  
  public void setZ(float z){
    this.z = z;
  }
  
  public void setXYZ(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  // B.subtract(A) is a vector from A to B
  public PVector subtract(Point a){
    PVector B = new PVector(x, y, z);
    return B.sub(a.getX(), a.getY(), a.getZ());
  }
  
  public void movePoint(PVector move, float a){
    x = x + move.x * a;
    y = y + move.y * a;
    z = z + move.z * a;
  }
  
  public String debug(){
    return "X: " + x + "\tY: " + y + "\tZ: " + z;
  }
  
  public float euclideanDistance(Point b){
    return sqrt(sq(x-b.getX()) + sq(y-b.getY()) + sq(z-b.getZ()));
  }
  
  public PVector getPVector(){
    return new PVector(x,y,z);
  }
}