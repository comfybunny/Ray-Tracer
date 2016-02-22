public class Lens{
  private float radius;
  private float focal_distance;
  private PVector lens_normal;
  
  public Lens(float radius, float focal_distance){
    this.radius = radius;
    this.focal_distance = focal_distance;
    lens_normal = new PVector(0, 0, 1.0);
  }
  
  public float getRadius(){
    return radius;
  }
  
  public float getFocalDistance(){
    return focal_distance;
  }
  
  public PVector getLensNormal(){
    return lens_normal;
  }
}