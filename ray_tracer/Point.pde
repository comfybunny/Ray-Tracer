public class Point{
  private float x;
  private float y;
  private float z;
  
  public Point(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
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
  
  public PVector subtract(Point a){
    PVector B = new PVector(x, y, z);
    return B.sub(a.getX(), a.getY(), a.getZ());
  }
}