public class Ray{
  
  private Point origin;
  private PVector direction;
  
  public Ray(){
    origin = new Point();
    direction = new PVector();
  }
  
  public Ray(PVector direction){
    this.direction = direction;
  }
  public Ray(Point origin){
    this.origin = origin;
  }
  public Ray(Point origin, PVector direction){
    this.origin = origin;
    this.direction = direction;
  }
  
  public void setDirection(float x, float y, float z){
    direction.set(x, y, z);
  }
  
  public void setDirection(PVector dir){
    direction.set(dir.x, dir.y, dir.z);
  }
  
  public void setOrigin(float x, float y, float z){
    origin.setXYZ(x, y, z);
  }
  
  public void setOrigin(Point dir){
    origin.setXYZ(dir.x, dir.y, dir.z);
  }
  
  public Point getOrigin(){
    return origin;
  }
  
  public PVector getDirection(){
    return direction;
  }
  
  public String debug(){
    return "Origin: (" + origin.getX() + ", " + origin.getY() + ", " + origin.getZ() + ")\tDirection: (" + direction.x + ", " + direction.y + ", " + direction.z + ")";
  }
  
  public Point hitPoint(float time){
    return new Point(origin.getX() + time*direction.x, origin.getY() + time*direction.y, origin.getZ() + time*direction.z);
  }
}