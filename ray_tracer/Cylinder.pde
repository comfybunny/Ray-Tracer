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
    
    // equation for infinite cylinder along y axis is : (x-a)^2 + (z-b)^2 = r^2
    Point origin = tempRay.getOrigin();
    PVector direction = tempRay.getDirection();
    PVector centerToOrigin = origin.subtract(location);
    float a = sq(direction.x) + sq(direction.z);
    float b = 2*direction.x*(centerToOrigin.x) + 2*direction.z*(centerToOrigin.z);
    float c = sq(centerToOrigin.x) + sq(centerToOrigin.z) - sq(radius);
    float discriminant = sq(b) - (4*a*c);
        
    if(discriminant < 0){
      return -1;
    }
    
    float retValPlus = ((-1*b+sqrt(discriminant))/(2.0*a));
    float retValMinus = ((-1*b-sqrt(discriminant))/(2.0*a));
    
    float y1 = origin.getY() + retValMinus*direction.y;
    float y2 = origin.getY() + retValPlus*direction.y;
    
    float ymin = location.getY();
    
    float tMin = -1;
    
    // minimum time to hit body of cylinder
    if(ymin <= y1 && y1 <= ymax && ymin <= y2 && y2 <= ymax){
      // if both past test, return smallest nonnegative time
      tMin = StaticUtility.smallestPositive(retValMinus, retValPlus);
    }
    else if((ymin <= y1 && y1 <= ymax) || (ymin <= y2 && y2 <= ymax)){
      tMin = StaticUtility.smallestPositive(retValMinus, retValPlus);
    }
    // else it doesn't hit body of cylinder
    
    // check minimum time of hitting end caps

    if((y1 <= location.getY() && y2 >= ymax) || (y2 <= location.getY() && y1 >= ymax)){
      float tempTime1 = (ymax - origin.getY())/direction.y;
      float tempTime2 = (location.getY() - origin.getY())/direction.y;
      tMin = StaticUtility.smallestPositive(tempTime1, tempTime2);
    }
    // this is on either side of top cap so it intersects top
    else if((y1 <= ymax && ymax <= y2) || (y2 <= ymax && ymax <= y1)){
      float tempT = (ymax - origin.getY())/direction.y;
      tMin = StaticUtility.smallestPositive(tempT, tMin);
    }
    else if((y1 <= location.getY() && location.getY() <= y2) || (y2 <= location.getY() && location.getY() <= y1)){
     float tempT = (location.getY() - origin.getY())/direction.y;
     tMin = StaticUtility.smallestPositive(tempT, tMin);
    }
    return tMin;
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
  
  public String debug(){
    return "Cylinder\t\tradius: " + radius + "\tlocation: " + location.debug() + "\tymax: " + ymax;
  }
  
}