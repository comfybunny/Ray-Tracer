public class MovingSphere extends Sphere{
  
  private Point location2;
  
  private PVector pointer;
  
  public MovingSphere(float radius, Point location, Surface surface, Point location2){
    super(radius, location, surface);
    this.location2 = location2;
    pointer = location.subtract(location2);
  }
  
  public Point getLocation2(){
    return location2;
  }
  
  public void setLocation(Point location){
    location2 = location;
  }
  
  public IntersectionObject intersects(Ray ray){
    float randomTime = random(1);
    
    Point movingCenter = location2.newPoint(pointer, randomTime);
    Point origin = ray.getOrigin();
    PVector direction = ray.getDirection();

    float a = direction.dot(direction);
    PVector centerSphereToOrigin = origin.subtract(movingCenter);
    float b = 2*(centerSphereToOrigin.dot(ray.getDirection()));
    float c = (centerSphereToOrigin.dot(centerSphereToOrigin)) - sq(getRadius());
    
    float discriminant = sq(b) - (4*a*c);
    if(discriminant < 0){
      return new IntersectionObject(-1, null);
    }
    float retValPlus = ((-1*b+sqrt(discriminant))/(2.0f*a));
    float retValMinus = ((-1*b-sqrt(discriminant))/(2.0f*a));
    if(retValPlus > retValMinus && retValMinus>0){
      PVector sphereNormal = ray.hitPoint(retValMinus).subtract(movingCenter);
      sphereNormal.div(sphereNormal.mag());
      return new IntersectionObject(retValMinus, sphereNormal);
    }
    PVector sphereNormal = ray.hitPoint(retValPlus).subtract(movingCenter);
    sphereNormal.div(sphereNormal.mag());
    return new IntersectionObject(retValMinus, sphereNormal);
    
  }
}