public class Sphere{    // TODO CHANGE TO ABSTRACT CLASS

  private float radius;
  private Point location;
  private DiffuseSurface diffuseSurface;
  
  public Sphere(float radius, Point location, DiffuseSurface diffuseSurface){
    this.radius = radius;
    this.location = location;
    this.diffuseSurface = diffuseSurface;
  }
  
  public float getRadius(){
    return radius;
  }
  
  public Point getLocation(){
    return location;
  }
  
  public DiffuseSurface getDiffuseSurface(){
    return diffuseSurface;
  }
}