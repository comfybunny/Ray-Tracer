public class Sphere extends Shape{    // TODO CHANGE TO ABSTRACT CLASS

  private float radius;
  private Point location;
  
  
  public Sphere(float radius, Point location, Surface surface){
    this.radius = radius;
    this.location = location;
    addSurface(surface);
  }
  
  public Sphere(float radius, float[] location, Surface surface, XMatrix3D ctm){
    float[] newLocation = ctm.vectorMultiply(location);
    
    this.radius = radius;
    this.location = new Point(newLocation[0], newLocation[1], newLocation[2]);
    addSurface(surface);
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
    PVector centerSphereToOrigin = origin.subtract(location);
    float b = 2*(centerSphereToOrigin.dot(ray.getDirection()));
    float c = (centerSphereToOrigin.dot(centerSphereToOrigin)) - sq(radius);
    //float b = 2*direction.x*(origin.getX() - location.getX()) + 2*direction.y*(origin.getY() - location.getY()) + 2*direction.z*(origin.getZ() - location.getZ());
    //float c = sq(location.getX()) + sq(location.getY()) + sq(location.getZ())
    //      + sq(origin.getX()) + sq(origin.getY()) + sq(origin.getZ())
    //      + -2*(location.getX()*origin.getX() + location.getY()*origin.getY() + location.getZ()*origin.getZ()) - sq(radius);
    float discriminant = sq(b) - (4*a*c);
    if(discriminant < 0){
      return -1;
    }
    float retValPlus = ((-1*b+sqrt(discriminant))/(2.0f*a));
    float retValMinus = ((-1*b-sqrt(discriminant))/(2.0f*a));
    if(retValPlus > retValMinus && retValMinus>0){
      return retValMinus;
    }
    return retValPlus;
  }
  
  public PVector shapeNormal(Point hitPoint){
    PVector sphereNormal = hitPoint.subtract(location);
    return sphereNormal.div(sphereNormal.mag());
  }
  
  public String debug(){
    return "Location: (" + location.debug();
  }

}