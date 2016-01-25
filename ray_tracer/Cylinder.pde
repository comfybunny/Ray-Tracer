public class Cylinder extends Shape{
  
  private float radius;
  private Point location;
  private float ymax;
  
  public Cylinder(float radius, Point location, float ymax, Surface surface){
    this.radius = radius;
    this.location = location;
    this.ymax = ymax;
    addSurface(surface);
  }
  
  public float getRadius(){
    return radius;
  }
  
  public Point getLocation(){
    return location;
  }
  
  public float getYmax(){
    return ymax;
  }
  
  
  public float intersects(Ray tempRay){
    Point origin = tempRay.getOrigin();
    PVector direction = tempRay.getDirection();
    
    return -1;
  }
  
  
  public PVector shapeNormal(Point hitPoint){
    // if it hits the bottom of the cylinder
    if(hitPoint.getY() == location.getY()){
      return new PVector(0,-1,0);
    }
    // if it hits the top of the cylinder
    else if(hitPoint.getY() == ymax){
      return new PVector(0,1,0);
    }
    // if it hits the body of the cylinder
    PVector cylinderNormal = hitPoint.subtract(new Point(location.getX(), hitPoint.getY(), location.getZ()));
    return cylinderNormal.div(cylinderNormal.mag());
  }
  
  
}