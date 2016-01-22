public class Sphere extends Shape{    // TODO CHANGE TO ABSTRACT CLASS

  private float radius;
  private Point location;
  
  
  public Sphere(float radius, Point location, Surface diffuseSurface){
    this.radius = radius;
    this.location = location;
    addSurface(diffuseSurface);
  }
  
  public float getRadius(){
    return radius;
  }
  
  public Point getLocation(){
    return location;
  }
  
  public float intersects(Ray ray){
    Point origin = ray.getOrigin();
    PVector direction = ray.getDirection();
    //println(ray.debug());
    float a = direction.dot(direction);
    //PVector centerSphereToOrigin = origin.subtract(location);
    //float b = 2*(centerSphereToOrigin.dot(ray.getDirection()));
    //float c = (centerSphereToOrigin.dot(centerSphereToOrigin)) - sq(radius);
    float b = 2*direction.x*(origin.getX() - location.getX()) + 2*direction.y*(origin.getY() - location.getY()) + 2*direction.z*(origin.getZ() - location.getZ());
    float c = sq(location.getX()) + sq(location.getY()) + sq(location.getZ())
           + sq(origin.getX()) + sq(origin.getY()) + sq(origin.getZ())
           + -2*(location.getX()*origin.getX() + location.getY()*origin.getY() + location.getZ()*origin.getZ()) - sq(radius);
    float discriminant = sq(b) - (4*a*c);
        
    if(discriminant < 0){
      return -1;
    }
    float retValPlus = ((-1*b+sqrt(discriminant))/(2.0f*a));
    float retValMinus = ((-1*b-sqrt(discriminant))/(2.0f*a));
    if(retValPlus > retValMinus && retValMinus>0){
      //println("retValMinus : " + retValMinus);
      return retValMinus;
    }
    //println("retValPlus : " + retValPlus);
    return retValPlus;
  }
  
  public Point hitPoint(Ray ray, float time){
    PVector direction = ray.getDirection();
    Point origin = ray.getOrigin();
    return new Point(origin.getX() + time*direction.x, origin.getY() + time*direction.y, origin.getZ() + time*direction.z);
  }
  
  public PVector shapeNormal(Point hitPoint){
    PVector sphereNormal = hitPoint.subtract(location);
    return sphereNormal.div(sphereNormal.mag());
  }

}