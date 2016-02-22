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
  
  public Ray randomRayOnLens(Ray ray){
    float timeIntersectionFocalPlane = -1.0*focal_distance/ray.getDirection().z;
    Point Q = new Point();
    Q.movePoint(ray.getDirection(), timeIntersectionFocalPlane);
    Point P = new Point();
    Point Pprime = new Point((random(2) - 1)*radius, (random(2) - 1)*radius, 0);
    while(Pprime.euclideanDistance(P) > radius){
      Pprime = new Point((random(2) - 1)*radius, (random(2) - 1)*radius, 0);
    }
    Ray lens_ray = new Ray();
    lens_ray.setOrigin(Pprime);
    lens_ray.setDirection(Q.subtract(Pprime));
    return lens_ray;
  }
}